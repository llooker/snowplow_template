# View for the session table (PDT). This table uses session_prep during its build process.
# Authors: Erin Franz (erin@looker.com), Kevin Marr (marr@looker.com)

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
          , min(dvce_created_tstamp) AS dvce_min_tstamp
          , max(dvce_created_tstamp) AS dvce_max_tstamp
          , count(1) as number_of_events
          , count(distinct(floor(extract(epoch from dvce_created_tstamp)/30)))/2::float AS time_engaged_with_minutes
        from demo.events
        where domain_userid is not null
          and domain_sessionidx is not null
          and domain_userid != ''
          and dvce_created_tstamp IS NOT NULL
          and dvce_created_tstamp > '2000-01-01' -- Prevent SQL errors
          and dvce_created_tstamp < '2030-01-01' -- Prevent SQL errors
        group by 1, 2, 3
      )
      
      select domain_userid
        , domain_sessionidx
        , start_at
        , least(last_event_at + interval '1 minute', lead(start_at) over (partition by domain_userid order by domain_sessionidx)) as end_at
        , number_of_events
        , time_engaged_with_minutes
        , b.*
      from sessions_pre
        inner join ${session_prep.SQL_TABLE_NAME} as b
          on sessions_pre.session_pkey = b.session_pkey


  fields:


# Basic Session Fields #

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
  
  - dimension: time_engaged_with_minutes
    sql: ${TABLE}.time_engaged_with_minutes

  - dimension: bounced
    type: yesno
    sql: ${number_of_events} = 1

  - dimension: is_first_session
    type: yesno
    sql: ${domain_session_index} = 1
  
  - dimension: new_vs_returning_visitor
    sql_case:
      new: ${domain_session_index} = 1
      returning: ${domain_session_index} > 1
      else: unknown
      
  - measure: count
    type: count
    drill_fields: count_drill*
  
  - measure: bounced_session_count
    type: count
    filter: 
      bounced: yes
    drill_fields: count_drill*
  
  - measure: bounce_rate
    type: number
    sql: ${bounced_session_count}::float/NULLIF(${count},0)

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
  
  - measure: average_time_engaged_minutes
    type: average
    sql: ${time_engaged_with_minutes}
  
  - measure: sessions_from_new_visitors_count
    type: count
    filters:
      domain_session_index: 1
    drill_fields: count_drill*
  
  - measure: sessions_from_returning_visitors_count
    type: count
    filter: 
      domain_session_index: '>1'
    drill_fields: count_drill*
  
  - measure: percent_new_visitor_sessions
    type: number
    value_format: '#.00%'
    sql: ${sessions_from_new_visitors_count}::float/NULLIF(${count},0)

  - measure: percent_returning_visitor_sessions
    type: number
    value_format: '#.00%'
    sql: ${sessions_from_returning_visitors_count}::float/NULLIF(${count},0)
 
 
# Geo Fields #
  
  - dimension: geography_country
    sql: ${TABLE}.geo_country

  - dimension: geography_region
    sql: ${TABLE}.geo_region

  - dimension: geography_city
    sql: ${TABLE}.geo_city


# Landing and Exit Pages #
  
  - dimension: landing_page_urlhost
    sql: ${TABLE}.landing_page_urlhost

  - dimension: landing_page_urlpath
    sql: ${TABLE}.landing_page_urlpath

  - dimension: exit_page_urlhost
    sql: ${TABLE}.exit_page_urlhost

  - dimension: exit_page_urlpath
    sql: ${TABLE}.exit_page_urlpath


# Browser Fields #
  
  - dimension: browser
    sql: ${TABLE}.br_name
  
  - dimension: browser_family
    sql: ${TABLE}.br_family

  - dimension: browser_version
    sql: ${TABLE}.br_version
    
  - dimension: browser_type
    sql: ${TABLE}.br_type
    
  - dimension: browser_renderengine
    sql: ${TABLE}.br_renderengine
    
  - dimension: browser_language
    sql: ${TABLE}.br_lang
    
  - dimension: browser_has_director_plugin
    type: yesno
    sql: ${TABLE}.br_features_director
    
  - dimension: browser_has_flash_plugin
    type: yesno
    sql: ${TABLE}.br_features_flash
    
  - dimension: browser_has_gears_plugin
    type: yesno
    sql: ${TABLE}.br_features_gears
    
  - dimension: browser_has_java_plugin
    type: yesno
    sql: ${TABLE}.br_features_java
    
  - dimension: browser_has_pdf_plugin
    type: yesno
    sql: ${TABLE}.br_features_pdf
    
  - dimension: browser_has_quicktime_plugin
    type: yesno
    sql: ${TABLE}.br_features_quicktime
    
  - dimension: browser_has_realplayer_plugin
    type: yesno
    sql: ${TABLE}.br_features_realplayer
    
  - dimension: browser_has_silverlight_plugin
    type: yesno
    sql: ${TABLE}.br_features_silverlight
    
  - dimension: browser_has_windowsmedia_plugin
    type: yesno
    sql: ${TABLE}.br_features_windowsmedia
    
  - dimension: browser_supports_cookies
    type: yesno
    sql: ${TABLE}.br_cookies
  
  
# OS Fields #
    
  - dimension: operating_system
    sql: ${TABLE}.os_name
    
  - dimension: operating_system_family
    sql: ${TABLE}.os_family
    
  - dimension: operating_system_manufacturer
    sql: ${TABLE}.os_manufacturer
    
    
# Device Fields #
    
  - dimension: device_type
    sql: ${TABLE}.dvce_type
    
  - dimension: device_is_mobile
    type: yesno
    sql: ${TABLE}.dvce_ismobile
    
  - dimension: device_screen_width
    sql: ${TABLE}.dvce_screenwidth
    
  - dimension: device_screen_height
    sql: ${TABLE}.dvce_screenheight
    

# Referrer Fields (All Acquisition Channels) #
    
  - dimension: referrer_medium
    sql_case:
      email: ${TABLE}.refr_medium = 'email'
      search: ${TABLE}.refr_medium = 'search'
      social: ${TABLE}.refr_medium = 'social'
      other_website: ${TABLE}.refr_medium = 'unknown'
      else: direct
    
  - dimension: referrer_source
    sql: ${TABLE}.refr_source
    
  - dimension: referrer_term
    sql: ${TABLE}.refr_term
    
  - dimension: referrer_url_host
    sql: ${TABLE}.refr_urlhost
  
  - dimension: referrer_url_path
    sql: ${TABLE}.refr_urlpath
    
    
# Marketing Fields (Paid Acquisition Channels)
    
  - dimension: campaign_medium
    sql: ${TABLE}.mkt_medium
  
  - dimension: campaign_source
    sql: ${TABLE}.mkt_source
  
  - dimension: campaign_term
    sql: ${TABLE}.mkt_term
  
  - dimension: campaign_name
    sql: ${TABLE}.mkt_campaign

  - dimension: campaign_content
    sql: ${TABLE}.mkt_content


# Sets #

  sets:
    count_drill:
      - domain_userid
      - domain_sessionidx
      - start_at
      - end_at
      - duration_minutes
      - num_events
      
      