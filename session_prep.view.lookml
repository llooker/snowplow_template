# This is a pre-processing table that is used to build the session table.
# It is not used for analysis and is reaped within one hour after the session table is complete.
# Authors: Erin Franz (erin@looker.com), Kevin Marr (marr@looker.com)

- view: session_prep
  derived_table:
  
    persist_for: 1 hour
    
    sortkeys: [session_pkey]
    distkey: session_pkey

    sql: |
      select distinct domain_userid || domain_sessionidx as session_pkey
      
        -- geo fields
        , first_value(geo_country ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_created_tstamp rows between unbounded preceding and unbounded following) as geo_country 
        , first_value(geo_region ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_created_tstamp rows between unbounded preceding and unbounded following) as geo_region
        , first_value(geo_city ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_created_tstamp rows between unbounded preceding and unbounded following) as geo_city
        
        -- landing page fields
        , first_value(page_urlhost ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_created_tstamp rows between unbounded preceding and unbounded following) as landing_page_urlhost
        , first_value(page_urlpath ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_created_tstamp rows between unbounded preceding and unbounded following) as landing_page_urlpath
        
        -- exit page fields
        , last_value(page_urlhost ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_created_tstamp rows between unbounded preceding and unbounded following) as exit_page_urlhost
        , last_value(page_urlpath ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_created_tstamp rows between unbounded preceding and unbounded following) as exit_page_urlpath
        
        -- browser fields
        , first_value(br_name ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_created_tstamp rows between unbounded preceding and unbounded following) as br_name
        , first_value(br_family ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_created_tstamp rows between unbounded preceding and unbounded following) as br_family
        , first_value(br_version ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_created_tstamp rows between unbounded preceding and unbounded following) as br_version
        , first_value(br_type ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_created_tstamp rows between unbounded preceding and unbounded following) as br_type
        , first_value(br_renderengine ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_created_tstamp rows between unbounded preceding and unbounded following) as br_renderengine
        , first_value(br_lang ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_created_tstamp rows between unbounded preceding and unbounded following) as br_lang
        , first_value(br_features_director ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_created_tstamp rows between unbounded preceding and unbounded following) as br_features_director
        , first_value(br_features_flash ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_created_tstamp rows between unbounded preceding and unbounded following) as br_features_flash
        , first_value(br_features_gears ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_created_tstamp rows between unbounded preceding and unbounded following) as br_features_gears
        , first_value(br_features_java ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_created_tstamp rows between unbounded preceding and unbounded following) as br_features_java
        , first_value(br_features_pdf ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_created_tstamp rows between unbounded preceding and unbounded following) as br_features_pdf
        , first_value(br_features_quicktime ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_created_tstamp rows between unbounded preceding and unbounded following) as br_features_quicktime
        , first_value(br_features_realplayer ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_created_tstamp rows between unbounded preceding and unbounded following) as br_features_realplayer
        , first_value(br_features_silverlight ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_created_tstamp rows between unbounded preceding and unbounded following) as br_features_silverlight
        , first_value(br_features_windowsmedia ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_created_tstamp rows between unbounded preceding and unbounded following) as br_features_windowsmedia
        , first_value(br_cookies ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_created_tstamp rows between unbounded preceding and unbounded following) as br_cookies
        
        -- os fields
        , first_value(os_name ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_created_tstamp rows between unbounded preceding and unbounded following) as os_name
        , first_value(os_family ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_created_tstamp rows between unbounded preceding and unbounded following) as os_family
        , first_value(os_manufacturer ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_created_tstamp rows between unbounded preceding and unbounded following) as os_manufacturer
        , first_value(os_timezone ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_created_tstamp rows between unbounded preceding and unbounded following) as os_timezone
        
        -- device fields
        , first_value(dvce_type ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_created_tstamp rows between unbounded preceding and unbounded following) as dvce_type
        , first_value(dvce_ismobile ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_created_tstamp rows between unbounded preceding and unbounded following) as dvce_ismobile
        , first_value(dvce_screenwidth ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_created_tstamp rows between unbounded preceding and unbounded following) as dvce_screenwidth
        , first_value(dvce_screenheight ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_created_tstamp rows between unbounded preceding and unbounded following) as dvce_screenheight
        
        -- marketing fields
        , first_value((CASE WHEN mkt_source = '' OR refr_medium = 'internal' THEN NULL ELSE mkt_source END) ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_created_tstamp rows between unbounded preceding and unbounded following) as mkt_source
        , first_value((CASE WHEN mkt_medium = '' OR refr_medium = 'internal' THEN NULL ELSE mkt_medium END) ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_created_tstamp rows between unbounded preceding and unbounded following) as mkt_medium
        , first_value((CASE WHEN mkt_campaign = '' OR refr_medium = 'internal' THEN NULL ELSE mkt_campaign END) ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_created_tstamp rows between unbounded preceding and unbounded following) as mkt_campaign
        , first_value((CASE WHEN mkt_term = '' OR refr_medium = 'internal' THEN NULL ELSE mkt_term END) ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_created_tstamp rows between unbounded preceding and unbounded following) as mkt_term
        , first_value((CASE WHEN mkt_content = '' OR refr_medium = 'internal' THEN NULL ELSE mkt_content END) ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_created_tstamp rows between unbounded preceding and unbounded following) as mkt_content
        
        -- referrer fields
        , first_value((CASE WHEN refr_source = '' OR refr_medium = 'internal' THEN NULL ELSE refr_source END) ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_created_tstamp rows between unbounded preceding and unbounded following) as refr_source
        , first_value((CASE WHEN refr_medium = '' OR refr_medium = 'internal' THEN NULL ELSE refr_medium END) ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_created_tstamp rows between unbounded preceding and unbounded following) as refr_medium
        , first_value((CASE WHEN refr_term = '' OR refr_medium = 'internal' THEN NULL ELSE refr_term END) ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_created_tstamp rows between unbounded preceding and unbounded following) as refr_term
        , first_value((CASE WHEN refr_urlhost = '' OR refr_medium = 'internal' THEN NULL ELSE refr_urlhost END) ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_created_tstamp rows between unbounded preceding and unbounded following) as refr_urlhost
        , first_value((CASE WHEN refr_urlpath = '' OR refr_medium = 'internal' THEN NULL ELSE refr_urlpath END) ignore nulls) over (partition by domain_userid, domain_sessionidx order by dvce_created_tstamp rows between unbounded preceding and unbounded following) as refr_urlpath
        
      from demo.events
      where domain_userid is not null
        and domain_sessionidx is not null
        and domain_userid != ''
        and dvce_created_tstamp IS NOT NULL
        and dvce_created_tstamp > '2000-01-01' -- Prevent SQL errors
        and dvce_created_tstamp < '2030-01-01' -- Prevent SQL errors
        
        