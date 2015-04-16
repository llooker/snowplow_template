- view: session_facts
  derived_table:
    persist_for: 1 hour
    
    sortkeys: [session_pkey]
    distkey: session_pkey

    sql: |
      select distinct domain_userid || domain_sessionidx as session_pkey
                    
              , first_value(geo_country ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_tstamp rows between unbounded preceding and unbounded following) as geo_country 
              , first_value(geo_region ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_tstamp rows between unbounded preceding and unbounded following) as geo_region
              , first_value(geo_city ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_tstamp rows between unbounded preceding and unbounded following) as geo_city
              
              , first_value(page_urlhost ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_tstamp rows between unbounded preceding and unbounded following) as landing_page_urlhost
              , first_value(page_urlpath ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_tstamp rows between unbounded preceding and unbounded following) as landing_page_urlpath
              
              , last_value(page_urlhost ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_tstamp rows between unbounded preceding and unbounded following) as exit_page_urlhost
              , last_value(page_urlpath ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_tstamp rows between unbounded preceding and unbounded following) as exit_page_urlpath
              
              , first_value(br_name ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_tstamp rows between unbounded preceding and unbounded following) as br_name
              , first_value(br_family ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_tstamp rows between unbounded preceding and unbounded following) as br_family
              , first_value(br_version ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_tstamp rows between unbounded preceding and unbounded following) as br_version
              , first_value(br_type ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_tstamp rows between unbounded preceding and unbounded following) as br_type
              , first_value(br_renderengine ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_tstamp rows between unbounded preceding and unbounded following) as br_renderengine
              , first_value(br_lang ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_tstamp rows between unbounded preceding and unbounded following) as br_lang
              , first_value(br_features_director ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_tstamp rows between unbounded preceding and unbounded following) as br_features_director
              , first_value(br_features_flash ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_tstamp rows between unbounded preceding and unbounded following) as br_features_flash
              , first_value(br_features_gears ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_tstamp rows between unbounded preceding and unbounded following) as br_features_gears
              , first_value(br_features_java ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_tstamp rows between unbounded preceding and unbounded following) as br_features_java
              , first_value(br_features_pdf ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_tstamp rows between unbounded preceding and unbounded following) as br_features_pdf
              , first_value(br_features_quicktime ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_tstamp rows between unbounded preceding and unbounded following) as br_features_quicktime
              , first_value(br_features_realplayer ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_tstamp rows between unbounded preceding and unbounded following) as br_features_realplayer
              , first_value(br_features_silverlight ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_tstamp rows between unbounded preceding and unbounded following) as br_features_silverlight
              , first_value(br_features_windowsmedia ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_tstamp rows between unbounded preceding and unbounded following) as br_features_windowsmedia
              , first_value(br_cookies ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_tstamp rows between unbounded preceding and unbounded following) as br_cookies
              
              , first_value(os_name ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_tstamp rows between unbounded preceding and unbounded following) as os_name
              , first_value(os_family ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_tstamp rows between unbounded preceding and unbounded following) as os_family
              , first_value(os_manufacturer ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_tstamp rows between unbounded preceding and unbounded following) as os_manufacturer
              , first_value(os_timezone ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_tstamp rows between unbounded preceding and unbounded following) as os_timezone
              
              , first_value(dvce_type ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_tstamp rows between unbounded preceding and unbounded following) as dvce_type
              , first_value(dvce_ismobile ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_tstamp rows between unbounded preceding and unbounded following) as dvce_ismobile
              , first_value(dvce_screenwidth ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_tstamp rows between unbounded preceding and unbounded following) as dvce_screenwidth
              , first_value(dvce_screenheight ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_tstamp rows between unbounded preceding and unbounded following) as dvce_screenheight
              
              , first_value((CASE WHEN mkt_source = '' OR refr_medium = 'internal' THEN NULL ELSE mkt_source END) ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_tstamp rows between unbounded preceding and unbounded following) as mkt_source
              , first_value((CASE WHEN mkt_medium = '' OR refr_medium = 'internal' THEN NULL ELSE mkt_medium END) ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_tstamp rows between unbounded preceding and unbounded following) as mkt_medium
              , first_value((CASE WHEN mkt_campaign = '' OR refr_medium = 'internal' THEN NULL ELSE mkt_campaign END) ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_tstamp rows between unbounded preceding and unbounded following) as mkt_campaign
              , first_value((CASE WHEN mkt_term = '' OR refr_medium = 'internal' THEN NULL ELSE mkt_term END) ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_tstamp rows between unbounded preceding and unbounded following) as mkt_term
              
              , first_value((CASE WHEN refr_source = '' OR refr_medium = 'internal' THEN NULL ELSE refr_source END) ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_tstamp rows between unbounded preceding and unbounded following) as refr_source
              , first_value((CASE WHEN refr_medium = '' OR refr_medium = 'internal' THEN NULL ELSE refr_medium END) ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_tstamp rows between unbounded preceding and unbounded following) as refr_medium
              , first_value((CASE WHEN refr_term = '' OR refr_medium = 'internal' THEN NULL ELSE refr_term END) ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_tstamp rows between unbounded preceding and unbounded following) as refr_term
              , first_value((CASE WHEN refr_urlhost = '' OR refr_medium = 'internal' THEN NULL ELSE refr_urlhost END) ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_tstamp rows between unbounded preceding and unbounded following) as refr_urlhost
              , first_value((CASE WHEN refr_urlpath = '' OR refr_medium = 'internal' THEN NULL ELSE refr_urlpath END) ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_tstamp rows between unbounded preceding and unbounded following) as refr_urlpath
          from atomic.events
          where domain_userid is not null
            and domain_sessionidx is not null
            and domain_userid != ''
            and dvce_tstamp IS NOT NULL
            and dvce_tstamp > '2000-01-01' -- Prevent SQL errors
            and dvce_tstamp < '2030-01-01' -- Prevent SQL errors

  fields:
  - measure: count
    type: count
    drill_fields: detail*

  - dimension: session_pkey
    sql: ${TABLE}.session_pkey

  # Geo fields #
  
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
  
    # OS fields #
    
  - dimension: operating_system
    sql: ${TABLE}.os_name
    
  - dimension: operating_system_family
    sql: ${TABLE}.os_family
    
  - dimension: operating_system_manufacturer
    sql: ${TABLE}.os_manufacturer
    
  # Device fields #
    
  - dimension: device_type
    sql: ${TABLE}.dvce_type
    
  - dimension: device_is_mobile
    type: yesno
    sql: ${TABLE}.dvce_ismobile
    
  - dimension: device_screen_width
    sql: ${TABLE}.dvce_screenwidth
    
  - dimension: device_screen_height
    sql: ${TABLE}.dvce_screenheight
    

  # Referer fields (all acquisition channels) #
    
  - dimension: referer_medium
    sql_case:
      email: ${TABLE}.refr_medium = 'email'
      search: ${TABLE}.refr_medium = 'search'
      social: ${TABLE}.refr_medium = 'social'
      other_website: ${TABLE}.refr_medium = 'unknown'
      else: direct
    
  - dimension: referer_source
    sql: ${TABLE}.refr_source
    
  - dimension: referer_term
    sql: ${TABLE}.refr_term
    
  - dimension: referer_url_host
    sql: ${TABLE}.refr_urlhost
  
  - dimension: referer_url_path
    sql: ${TABLE}.refr_urlpath
    
  # MKT fields (paid acquisition channels)
    
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


