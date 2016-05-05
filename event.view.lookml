# View for the events table.
# Authors: Kevin Marr (marr@looker.com), Spencer Wanlass (swanlass@looker.com), Erin Franz (erin@looker.com)

- view: event
  sql_table_name: demo.events
  fields:
  

# Common Fields #

  - dimension: app_id
    sql: ${TABLE}.app_id

  - dimension: platform
    sql: ${TABLE}.platform


# Time Fields #

  - dimension_group: collector
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.collector_tstamp

  - dimension_group: derived
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.derived_tstamp

  - dimension_group: device
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.dvce_created_tstamp
    
  - dimension_group: device_sent
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.dvce_sent_tstamp

  - dimension_group: etl
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.etl_tstamp

  - dimension: os_timezone
    group_label: "Operating System"
    sql: ${TABLE}.os_timezone
    
  - dimension_group: referrer_device
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.refr_dvce_tstamp


# Event Fields #

  - dimension: event
    sql: ${TABLE}.event
    
  - dimension: event_type
    sql: |
      case
        when ${event} = 'page_view' then coalesce(${page_url}, ${page_title}, ${page_url_host}, ${page_url_scheme})
        when ${event} = 'struct' then ${se_action}
        else ${event}
      end

  - dimension: event_id
    primary_key: true
    sql: ${TABLE}.event_id

  - dimension: transaction_id
    type: number
    sql: ${TABLE}.txn_id
    
  - measure: count
    type: count
    drill_fields: count_drill*


# Snowplow Version Fields #

  - dimension: collector
    group_label: 'Version'
    sql: ${TABLE}.v_collector

  - dimension: etl
    group_label: 'Version'
    sql: ${TABLE}.v_etl

  - dimension: tracker
    group_label: 'Version'
    sql: ${TABLE}.v_tracker

  - dimension: name_tracker
    group_label: 'Version'
    sql: ${TABLE}.name_tracker
    
  - dimension: etl_tags
    group_label: 'Version'
    sql: ${TABLE}.etl_tags


# User Fields #

  - dimension: domain_session_index
    type: number
    hidden: true
    sql: ${TABLE}.domain_sessionidx
    
  - dimension: domain_session_id
    hidden: true
    sql: ${TABLE}.domain_sessionid
  
  - dimension: domain_user_id
    hidden: true
    sql: ${TABLE}.domain_userid

  - dimension: user_id
    group_label: 'User'
    sql: ${TABLE}.user_id

  - dimension: ip_address
    group_label: 'User'
    sql: ${TABLE}.user_ipaddress

  - dimension: network_user_id
    group_label: 'User'
    sql: ${TABLE}.network_userid

  - measure: events_per_user
    group_label: 'User'
    type: number
    sql: ${count}::float / NULLIF(${user.count}, 0)
    value_format_name: decimal_2


# Device and Operating System Fields #

  - dimension: device_is_mobile
    group_label: 'Device'
    type: yesno
    sql: ${TABLE}.dvce_ismobile

  - dimension: device_screen_height
    group_label: 'Device'
    type: number
    sql: ${TABLE}.dvce_screenheight

  - dimension: device_screen_width
    group_label: 'Device'
    type: number
    sql: ${TABLE}.dvce_screenwidth

  - dimension: device_type
    group_label: 'Device'
    sql: ${TABLE}.dvce_type

  - dimension: user_agent
    group_label: 'Device'
    sql: ${TABLE}.useragent

  - dimension: os_family
    group_label: 'Operating System'
    sql: ${TABLE}.os_family

  - dimension: os_manufacturer
    group_label: 'Operating System'
    sql: ${TABLE}.os_manufacturer

  - dimension: os_name
    group_label: 'Operating System'
    sql: ${TABLE}.os_name


# Location Fields #

  - dimension: city
    group_label: 'Location'
    sql: ${TABLE}.geo_city

  - dimension: country
    group_label: 'Location'
    sql: ${TABLE}.geo_country

  - dimension: region
    group_label: 'Location'
    sql: ${TABLE}.geo_region
    
  - dimension: region_name
    group_label: 'Location'
    sql: ${TABLE}.geo_region_name

  - dimension: latitude
    group_label: 'Location'
    hidden: true
    sql: ${TABLE}.geo_latitude
    
  - dimension: longitude
    group_label: 'Location'
    hidden: true
    sql: ${TABLE}.geo_longitude    
    
  - dimension: geo_location
    group_label: 'Location'
    type: location
    sql_latitude: ${latitude}
    sql_longitude: ${longitude}
    
  - dimension: timezone
    group_label: 'Location'
    sql: ${TABLE}.geo_timezone

  - dimension: zipcode
    group_label: 'Location'
    sql: ${TABLE}.geo_zipcode


# IP Fields #

  - dimension: ip_domain
    group_label: 'IP'
    sql: ${TABLE}.ip_domain

  - dimension: ip_isp
    group_label: 'IP'
    sql: ${TABLE}.ip_isp

  - dimension: ip_net_speed
    group_label: 'IP'
    sql: ${TABLE}.ip_netspeed

  - dimension: ip_organization
    group_label: 'IP'
    sql: ${TABLE}.ip_organization


# Page Fields #

  - dimension: page_referrer
    group_label: 'Page'
    sql: ${TABLE}.page_referrer

  - dimension: page_title
    group_label: 'Page'
    sql: ${TABLE}.page_title

  - dimension: page_url
    group_label: 'Page'
    sql: ${TABLE}.page_url

  - dimension: page_url_fragment
    group_label: 'Page'
    sql: ${TABLE}.page_urlfragment

  - dimension: page_url_host
    group_label: 'Page'
    sql: ${TABLE}.page_urlhost

  - dimension: page_url_path
    group_label: 'Page'
    sql: ${TABLE}.page_urlpath

  - dimension: page_url_port
    group_label: 'Page'
    type: number
    sql: ${TABLE}.page_urlport

  - dimension: page_url_query
    group_label: 'Page'
    sql: ${TABLE}.page_urlquery

  - dimension: page_url_scheme
    group_label: 'Page'
    sql: ${TABLE}.page_urlscheme

  - dimension: referrer_medium
    group_label: 'Page'
    sql: ${TABLE}.refr_medium

  - dimension: referrer_source
    group_label: 'Page'
    sql: ${TABLE}.refr_source

  - dimension: referrer_term
    group_label: 'Page'
    sql: ${TABLE}.refr_term

  - dimension: referrer_url_fragment
    group_label: 'Page'
    sql: ${TABLE}.refr_urlfragment

  - dimension: referrer_url_host
    group_label: 'Page'
    sql: ${TABLE}.refr_urlhost

  - dimension: referrer_url_path
    group_label: 'Page'
    sql: ${TABLE}.refr_urlpath

  - dimension: referrer_url_port
    group_label: 'Page'
    type: number
    sql: ${TABLE}.refr_urlport

  - dimension: referrer_url_query
    group_label: 'Page'
    sql: ${TABLE}.refr_urlquery
    

  - dimension: referrer_url_scheme
    group_label: 'Page'
    sql: ${TABLE}.refr_urlscheme
    
  - dimension: referrer_domain_user_id
    group_label: 'Page'
    sql: ${TABLE}.refr_domain_userid


# Document Fields #

  - dimension: charset
    group_label: 'Document'
    sql: ${TABLE}.doc_charset

  - dimension: height
    group_label: 'Document'
    type: number
    sql: ${TABLE}.doc_height

  - dimension: width
    group_label: 'Document'
    type: number
    sql: ${TABLE}.doc_width


# Marketing/Source Fields #

  - dimension: campaign
    group_label: 'Marketing'
    sql: ${TABLE}.mkt_campaign

  - dimension: content
    group_label: 'Marketing'
    sql: ${TABLE}.mkt_content

  - dimension: medium
    group_label: 'Marketing'
    sql: ${TABLE}.mkt_medium

  - dimension: source
    group_label: 'Marketing'
    sql: ${TABLE}.mkt_source

  - dimension: term
    group_label: 'Marketing'
    sql: ${TABLE}.mkt_term

  - dimension: click_id
    group_label: 'Marketing'
    sql: ${TABLE}.mkt_clickid

  - dimension: network
    group_label: 'Marketing'
    sql: ${TABLE}.mkt_network


# Browser Fields #

  - dimension: user_fingerprint
    group_label: 'Browser'
    sql: ${TABLE}.user_fingerprint

  - dimension: connection_type
    group_label: 'Browser'
    sql: ${TABLE}.connection_type

  - dimension: supports_persistent_cookies
    group_label: 'Browser'
    type: yesno
    sql: ${TABLE}.cookie

  - dimension: color_depth
    group_label: 'Browser'
    sql: ${TABLE}.br_colordepth

  - dimension: cookies_enabled
    group_label: 'Browser'
    type: yesno
    sql: ${TABLE}.br_cookies

  - dimension: family
    group_label: 'Browser'
    sql: ${TABLE}.br_family

  - dimension: features_director
    group_label: 'Browser'
    type: yesno
    sql: ${TABLE}.br_features_director

  - dimension: features_flash
    group_label: 'Browser'
    type: yesno
    sql: ${TABLE}.br_features_flash

  - dimension: features_gears
    group_label: 'Browser'
    type: yesno
    sql: ${TABLE}.br_features_gears

  - dimension: features_java
    group_label: 'Browser'
    type: yesno
    sql: ${TABLE}.br_features_java

  - dimension: features_pdf
    group_label: 'Browser'
    type: yesno
    sql: ${TABLE}.br_features_pdf

  - dimension: features_quicktime
    group_label: 'Browser'
    type: yesno
    sql: ${TABLE}.br_features_quicktime

  - dimension: features_realplayer
    group_label: 'Browser'
    type: yesno
    sql: ${TABLE}.br_features_realplayer

  - dimension: features_silverlight
    group_label: 'Browser'
    type: yesno
    sql: ${TABLE}.br_features_silverlight

  - dimension: features_windowsmedia
    group_label: 'Browser'
    type: yesno
    sql: ${TABLE}.br_features_windowsmedia

  - dimension: javascript_version
    group_label: 'Browser'
    sql: ${TABLE}.br_jsversion
    
  - dimension: br_language
    group_label: 'Browser'
    sql: ${TABLE}.br_lang

  - dimension: br_name
    group_label: 'Browser'
    sql: ${TABLE}.br_name

  - dimension: render_engine
    group_label: 'Browser'
    sql: ${TABLE}.br_renderengine

  - dimension: br_type
    group_label: 'Browser'
    sql: ${TABLE}.br_type

  - dimension: br_version
    group_label: 'Browser'
    sql: ${TABLE}.br_version

  - dimension: br_view_height
    group_label: 'Browser'
    type: number
    sql: ${TABLE}.br_viewheight

  - dimension: br_view_width
    group_label: 'Browser'
    type: number
    sql: ${TABLE}.br_viewwidth


# Page Ping Fields #

  - dimension: x_offset_max
    group_label: 'Page Ping'
    type: number
    sql: ${TABLE}.pp_xoffset_max

  - dimension: x_offset_min
    group_label: 'Page Ping'
    type: number
    sql: ${TABLE}.pp_xoffset_min

  - dimension: y_offset_max
    group_label: 'Page Ping'
    type: number
    sql: ${TABLE}.pp_yoffset_max

  - dimension: y_offset_min
    group_label: 'Page Ping'
    type: number
    sql: ${TABLE}.pp_yoffset_min


# Transaction Fields #

  - dimension: ti_category
    group_label: 'Transaction Item'
    sql: ${TABLE}.ti_category

  - dimension: ti_currency
    group_label: "Transaction Item"
    sql: ${TABLE}.ti_currency

  - dimension: ti_name
    group_label: "Transaction Item"
    sql: ${TABLE}.ti_name

  - dimension: ti_order_id
    group_label: "Transaction Item"
    sql: ${TABLE}.ti_orderid

  - dimension: ti_price
    group_label: "Transaction Item"
    type: number
    sql: ${TABLE}.ti_price

  - dimension: ti_quantity
    group_label: "Transaction Item"
    type: number
    sql: ${TABLE}.ti_quantity

  - dimension: ti_sku
    group_label: "Transaction Item"
    sql: ${TABLE}.ti_sku

  - dimension: tr_affiliation
    group_label: "Transaction"
    sql: ${TABLE}.tr_affiliation

  - dimension: tr_city
    group_label: "Transaction"
    sql: ${TABLE}.tr_city

  - dimension: tr_country
    group_label: "Transaction"
    sql: ${TABLE}.tr_country

  - dimension: tr_orderid
    group_label: "Transaction"
    sql: ${TABLE}.tr_orderid

  - dimension: tr_shipping
    group_label: "Transaction"
    type: number
    sql: ${TABLE}.tr_shipping

  - dimension: tr_state
    group_label: "Transaction"
    sql: ${TABLE}.tr_state

  - dimension: tr_tax
    group_label: "Transaction"
    type: number
    sql: ${TABLE}.tr_tax

  - dimension: tr_total
    group_label: "Transaction"
    type: number
    sql: ${TABLE}.tr_total


# Custom Structured Event Fields #

  - dimension: se_action
    group_label: "Structured Event"
    sql: ${TABLE}.se_action

  - dimension: se_category
    group_label: "Structured Event"
    sql: ${TABLE}.se_category

  - dimension: se_label
    group_label: "Structured Event"
    sql: ${TABLE}.se_label

  - dimension: se_property
    group_label: "Structured Event"
    sql: ${TABLE}.se_property

  - dimension: se_value
    group_label: "Structured Event"
    type: number
    sql: ${TABLE}.se_value
      
    

# Funnel Fields #
  
  - filter: event_1
    suggest_explore: event
    suggest_dimension: event_type

  - filter: event_2
    suggest_explore: event
    suggest_dimension: event_type
  
  - filter: event_3
    suggest_explore: event
    suggest_dimension: event_type
  
  - filter: event_4
    suggest_explore: event
    suggest_dimension: event_type

  - measure: funnel.event_1_count_sessions
    type: number
    sql: COUNT(DISTINCT CASE WHEN {% condition event_1 %} ${event_type} {% endcondition %} THEN ${domain_user_id} || ${domain_session_index} END)

  - measure: funnel.event_2_count_sessions
    type: number
    sql: COUNT(DISTINCT CASE WHEN {% condition event_2 %} ${event_type} {% endcondition %} THEN ${domain_user_id} || ${domain_session_index} END)

  - measure: funnel.event_3_count_sessions
    type: number
    sql: COUNT(DISTINCT CASE WHEN {% condition event_3 %} ${event_type} {% endcondition %} THEN ${domain_user_id} || ${domain_session_index} END)

  - measure: funnel.event_4_count_sessions
    type: number
    sql: COUNT(DISTINCT CASE WHEN {% condition event_4 %} ${event_type} {% endcondition %} THEN ${domain_user_id} || ${domain_session_index} END)


# Sets #

  sets:
    count_drill:
      - event_id
      - event_type
      - user.domain_user_id
      - user.id
      - collector_time


