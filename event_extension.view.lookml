# This view is a denormalized extension onto the events table, one row for every event_id. Adjust the SQL and LookML as needed to add more material columns/dimensions.
# Authors: Kevin Marr (marr@looker.com), Spencer Wanlass (swanlass@looker.com), Erin Franz (erin@looker.com)
# Last Updated: 4/6/15
# v1.0

- view: event_extension
  derived_table:
  
    sql_trigger_value: select current_date      # Rebuilds at midnight database time. Adjust as needed.
    sortkeys: [event_id]
    distkey: event_id
  
    sql: |
      with
      
      base as (
        select *
          , first_value(collector_tstamp ignore nulls) over (partition by domain_userid, domain_sessionidx order by collector_tstamp, dvce_tstamp, event_id rows between unbounded preceding and unbounded following) as first_session_event_at
          , last_value(collector_tstamp ignore nulls) over (partition by domain_userid, domain_sessionidx order by collector_tstamp, dvce_tstamp, event_id rows between unbounded preceding and unbounded following) as last_session_event_at
          , row_number() over (partition by domain_userid, domain_sessionidx order by collector_tstamp desc, dvce_tstamp desc, event_id desc) as next_session_offset
        from (select *, count(*) over (partition by event_id rows between unbounded preceding and unbounded following) > 1 as is_duped from atomic.events) as detect_dupes
        where not is_duped
      )
      
      select event_id
        , strtol(left(md5(domain_userid || domain_sessionidx), 15), 16) as domain_session_id
        , first_session_event_at as session_start_at
        , least(last_session_event_at + interval '1 minute'
          , case
            when lead(collector_tstamp, next_session_offset::int) ignore nulls over (partition by domain_userid order by domain_sessionidx, collector_tstamp, dvce_tstamp, event_id) < last_session_event_at then last_session_event_at
            else lead(collector_tstamp, next_session_offset::int) ignore nulls over (partition by domain_userid order by domain_sessionidx, collector_tstamp, dvce_tstamp, event_id)
            end
          ) as session_end_at
        , row_number() over (partition by domain_userid, domain_sessionidx order by collector_tstamp, dvce_tstamp, event_id) as event_seq_num_in_session
        , count(*) over (partition by domain_userid, domain_sessionidx rows between unbounded preceding and unbounded following) as events_in_session
      from base

# coalesce(domain_userid,'') || coalesce(domain_sessionidx,'')

  fields:


# EVENT FIELDS #

  - dimension: event_id
    primary_key: true
    hidden: true
    sql: ${TABLE}.event_id

  - dimension: event.sequence_number_in_session
    type: number
    sql: ${TABLE}.event_seq_num_in_session


# SESSION FIELDS #

  - dimension: session.id
    type: int
    sql: ${TABLE}.domain_session_id

  - dimension_group: session.start
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.session_start_at

  - dimension_group: session.end
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.session_end_at

  - dimension: session.events_in_session
    type: number
    sql: ${TABLE}.events_in_session
  
  - dimension: session.duration_minutes
    type: number
    sql: DATEDIFF(MINUTES, ${TABLE}.session_start_at, ${TABLE}.session_end_at)    
  
  - dimension: session.bounced
    type: yesno
    sql: ${session.events_in_session} = 1

  - measure: session.count
    type: count_distinct
    sql: ${session.id}
    drill_fields: [session.id, user.domain_user_id, user.id, session.start_time, session.end_time, session.events_in_session, session.domain_session_sequence_number]
  
  - measure: session.approximate_count
    type: number
    sql: APPROXIMATE COUNT(DISTINCT ${session.id})
    drill_fields: [session.id, user.domain_user_id, user.id, session.start_time, session.end_time, session.events_in_session, session.domain_session_sequence_number]
    
  - measure: session.events_per_session
    type: number
    decimals: 2
    sql: ${event.count}::float / NULLIF(${session.count}, 0)
    
  # Looker symmetric measure to guarantee removal of duplicates
  - measure: session.sum_duration_minutes
    type: number
    sql: (SUM(DISTINCT (CAST(FLOOR(COALESCE(${session.duration_minutes}, 0) * (1000000 * 1.0)) AS DECIMAL(38, 0))) + CAST(STRTOL(LEFT(MD5(CONVERT(VARCHAR, ${session.id})), 15), 16) AS DECIMAL(38, 0)) * 1.0e8 + CAST(STRTOL(RIGHT(MD5(CONVERT(VARCHAR, ${session.id})), 15), 16) AS DECIMAL(38, 0)) ) - SUM(DISTINCT CAST(STRTOL(LEFT(MD5(CONVERT(VARCHAR, ${session.id})), 15), 16) AS DECIMAL(38, 0)) * 1.0e8 + CAST(STRTOL(RIGHT(MD5(CONVERT(VARCHAR, ${session.id})), 15), 16) AS DECIMAL(38, 0))) ) / (1000000 * 1.0)
    
  - measure: session.minutes_per_session
    type: number
    decimals: 2
    sql: 1.0 * ${session.sum_duration_minutes} / NULLIF(${session.approximate_count}, 0)


# USER FIELDS #

  - measure: user.sessions_per_user
    type: number
    decimals: 2
    sql: ${session.count}::float / NULLIF(${user.count}, 0)

