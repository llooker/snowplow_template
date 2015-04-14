- view: session
  derived_table:
  
    # Rebuilds at midnight database time. Adjust as needed.
    sql_trigger_value: select current_date
    
    sortkeys: [start_at, domain_userid, domain_sessionidx]
    distkey: domain_userid
  
    sql: |
      with
      
      sessions_pre as (
        select domain_userid || domain_sessionidx as session_pkey
          , domain_userid
          , domain_sessionidx
          , min(collector_tstamp) as start_at
          , max(collector_tstamp) as last_event_at
          , count(1) as number_of_events
        from atomic.events
        where domain_userid is not null
          and domain_sessionidx is not null
        group by 1, 2, 3
      )
      
      select session_pkey
          , domain_userid
          , domain_sessionidx
          , start_at
          , least(last_event_at + interval '1 minute', lead(start_at) over (partition by domain_userid order by domain_sessionidx)) as end_at
          , number_of_events
      from sessions_pre


  fields:


# DIMENSIONS #

  - dimension: session_pkey
    primary_key: true
    hidden: true
    sql: ${TABLE}.session_pkey

  - dimension: domain_user_id
    sql: ${TABLE}.domain_userid

  - dimension: domain_session_index
    type: number
    sql: ${TABLE}.domain_sessionidx

  - dimension_group: start
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.start_at

  - dimension_group: end
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.end_at

  - dimension: number_of_events
    type: number
    sql: ${TABLE}.number_of_events

  - dimension: duration_minutes
    type: number
    sql: DATEDIFF(MINUTES, ${TABLE}.start_at, ${TABLE}.end_at)    

  - dimension: bounced
    type: yesno
    sql: ${number_of_events} = 1

  - dimension: is_first_session
    type: yesno
    sql: ${domain_session_index} = 1


# MEASURES #
    
  - measure: count
    type: count
    drill_fields: count_drill*

  - measure: average_number_of_events
    type: average
    decimals: 2
    sql: ${number_of_events}

  - measure: average_duration_minutes
    type: average
    decimals: 2
    sql: ${duration_minutes}

  - measure: sessions_per_user
    type: number
    sql: ${count}::float/NULLIF(${user.count},0)
    decimals: 2

  - measure: user.count
    type: count_distinct
    sql: ${domain_user_id}
    drill_fields: [user.domain_user_id, user.id, user.ip_address, location.city, location.country]


# SETS #

  sets:
    count_drill:
      - domain_userid
      - domain_sessionidx
      - start_at
      - end_at
      - duration_minutes
      - num_events

