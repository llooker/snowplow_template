# Core view for the atomic.events table.
# Authors: Kevin Marr (marr@looker.com), Spencer Wanlass (swanlass@looker.com), Erin Franz (erin@looker.com)
# Last Updated: 4/6/15
# v1.0

- view: event
  sql_table_name: atomic.events
  fields:
  

# COMMON FIELDS #

  - dimension: app_id
    sql: ${TABLE}.app_id

  - dimension: platform
    sql: ${TABLE}.platform


# TIME FIELDS #

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
    sql: ${TABLE}.dvce_tstamp
    
  - dimension_group: device_sent
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.dvce_sent_tstamp

  - dimension_group: etl
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.etl_tstamp

  - dimension: operating_system.timezone
    sql: ${TABLE}.os_timezone
    
  - dimension_group: referrer_device
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.refr_dvce_tstamp


# EVENT FIELDS #

  - dimension: event
    sql: ${TABLE}.event
    
  - dimension: event_type
    sql: |
      case
        when ${event} = 'page_view' then coalesce(${page.url}, ${page.title}, ${page.url_host}, ${page.url_scheme})
        when ${event} = 'struct' then ${structured_event.action}
        else ${event}
      end

  - dimension: event_id
    primary_key: true
    sql: ${TABLE}.event_id

  - dimension: transaction_id
    type: int
    sql: ${TABLE}.txn_id
    
  - measure: count
    type: count
    drill_fields: count_drill*


# SNOWPLOW VERSION FIELDS #

  - dimension: version.collector
    sql: ${TABLE}.v_collector

  - dimension: version.etl
    sql: ${TABLE}.v_etl

  - dimension: version.tracker
    sql: ${TABLE}.v_tracker

  - dimension: version.name_tracker
    sql: ${TABLE}.name_tracker
    
  - dimension: version.etl_tags
    sql: ${TABLE}.etl_tags


# USER FIELDS #

  - dimension: domain_session_index
    type: number
    hidden: true
    sql: ${TABLE}.domain_sessionidx
    
  - dimension: domain_session_id
    hidden: true
    sql: ${TABLE}.domain_sessionid

  - dimension: user.domain_user_id
    sql: ${TABLE}.domain_userid

  - dimension: user.id
    sql: ${TABLE}.user_id

  - dimension: user.ip_address
    sql: ${TABLE}.user_ipaddress

  - dimension: user.network_user_id
    sql: ${TABLE}.network_userid

  - measure: user.events_per_user
    type: number
    decimals: 2
    sql: ${count}::float / NULLIF(${user.count}, 0)


# DEVICE AND OPERATING SYSTEM FIELDS #

  - dimension: device.is_mobile
    type: yesno
    sql: ${TABLE}.dvce_ismobile

  - dimension: device.screen_height
    type: int
    sql: ${TABLE}.dvce_screenheight

  - dimension: device.screen_width
    type: int
    sql: ${TABLE}.dvce_screenwidth

  - dimension: device.type
    sql: ${TABLE}.dvce_type

  - dimension: device.user_agent
    sql: ${TABLE}.useragent

  - dimension: operating_system.family
    sql: ${TABLE}.os_family

  - dimension: operating_system.manufacturer
    sql: ${TABLE}.os_manufacturer

  - dimension: operating_system.name
    sql: ${TABLE}.os_name


# LOCATION FIELDS #

  - dimension: location.city
    sql: ${TABLE}.geo_city

  - dimension: location.country
    sql: ${TABLE}.geo_country

  - dimension: location.region
    sql: ${TABLE}.geo_region

  - dimension: location.region_name
    sql: ${TABLE}.geo_region_name

  - dimension: location.latitude
    sql: ${TABLE}.geo_latitude

  - dimension: location.longitude
    sql: ${TABLE}.geo_longitude
    
  - dimension: location.timezone
    sql: ${TABLE}.geo_timezone

  - dimension: location.zipcode
    sql: ${TABLE}.geo_zipcode


# IP FIELDS #

  - dimension: ip.domain
    sql: ${TABLE}.ip_domain

  - dimension: ip.isp
    sql: ${TABLE}.ip_isp

  - dimension: ip.net_speed
    sql: ${TABLE}.ip_netspeed

  - dimension: ip.organization
    sql: ${TABLE}.ip_organization


# PAGE FIELDS #

  - dimension: page.referrer
    sql: ${TABLE}.page_referrer

  - dimension: page.title
    sql: ${TABLE}.page_title

  - dimension: page.url
    sql: ${TABLE}.page_url

  - dimension: page.url_fragment
    sql: ${TABLE}.page_urlfragment

  - dimension: page.url_host
    sql: ${TABLE}.page_urlhost

  - dimension: page.url_path
    sql: ${TABLE}.page_urlpath

  - dimension: page.url_port
    type: int
    sql: ${TABLE}.page_urlport

  - dimension: page.url_query
    sql: ${TABLE}.page_urlquery

  - dimension: page.url_scheme
    sql: ${TABLE}.page_urlscheme

  - dimension: page.referrer_medium
    sql: ${TABLE}.refr_medium

  - dimension: page.referrer_source
    sql: ${TABLE}.refr_source

  - dimension: page.referrer_term
    sql: ${TABLE}.refr_term

  - dimension: page.referrer_url_fragment
    sql: ${TABLE}.refr_urlfragment

  - dimension: page.referrer_url_host
    sql: ${TABLE}.refr_urlhost

  - dimension: page.referrer_url_path
    sql: ${TABLE}.refr_urlpath

  - dimension: page.referrer_url_port
    type: int
    sql: ${TABLE}.refr_urlport

  - dimension: page.referrer_url_query
    sql: ${TABLE}.refr_urlquery

  - dimension: page.referrer_url_scheme
    sql: ${TABLE}.refr_urlscheme
    
  - dimension: page.referrer_domain_user_id
    sql: ${TABLE}.refr_domain_userid


# DOCUMENT FIELDS #

  - dimension: document.charset
    sql: ${TABLE}.doc_charset

  - dimension: document.height
    type: int
    sql: ${TABLE}.doc_height

  - dimension: document.width
    type: int
    sql: ${TABLE}.doc_width


# MARKETING/SOURCE FIELDS #

  - dimension: marketing.campaign
    sql: ${TABLE}.mkt_campaign

  - dimension: marketing.content
    sql: ${TABLE}.mkt_content

  - dimension: marketing.medium
    sql: ${TABLE}.mkt_medium

  - dimension: marketing.source
    sql: ${TABLE}.mkt_source

  - dimension: marketing.term
    sql: ${TABLE}.mkt_term

  - dimension: marketing.click_id
    sql: ${TABLE}.mkt_clickid

  - dimension: marketing.network
    sql: ${TABLE}.mkt_network


# BROWSER FIELDS #

  - dimension: browser.user_fingerprint
    sql: ${TABLE}.user_fingerprint

  - dimension: browser.connection_type
    sql: ${TABLE}.connection_type

  - dimension: browser.supports_persistent_cookies
    type: yesno
    sql: ${TABLE}.cookie

  - dimension: browser.color_depth
    sql: ${TABLE}.br_colordepth

  - dimension: browser.cookies_enabled
    type: yesno
    sql: ${TABLE}.br_cookies

  - dimension: browser.family
    sql: ${TABLE}.br_family

  - dimension: browser.features_director
    type: yesno
    sql: ${TABLE}.br_features_director

  - dimension: browser.features_flash
    type: yesno
    sql: ${TABLE}.br_features_flash

  - dimension: browser.features_gears
    type: yesno
    sql: ${TABLE}.br_features_gears

  - dimension: browser.features_java
    type: yesno
    sql: ${TABLE}.br_features_java

  - dimension: browser.features_pdf
    type: yesno
    sql: ${TABLE}.br_features_pdf

  - dimension: browser.features_quicktime
    type: yesno
    sql: ${TABLE}.br_features_quicktime

  - dimension: browser.features_realplayer
    type: yesno
    sql: ${TABLE}.br_features_realplayer

  - dimension: browser.features_silverlight
    type: yesno
    sql: ${TABLE}.br_features_silverlight

  - dimension: browser.features_windowsmedia
    type: yesno
    sql: ${TABLE}.br_features_windowsmedia

  - dimension: browser.javascript_version
    sql: ${TABLE}.br_jsversion
    
  - dimension: browser.language
    sql: ${TABLE}.br_lang

  - dimension: browser.name
    sql: ${TABLE}.br_name

  - dimension: browser.render_engine
    sql: ${TABLE}.br_renderengine

  - dimension: browser.type
    sql: ${TABLE}.br_type

  - dimension: browser.version
    sql: ${TABLE}.br_version

  - dimension: browser.view_height
    type: int
    sql: ${TABLE}.br_viewheight

  - dimension: browser.view_width
    type: int
    sql: ${TABLE}.br_viewwidth


# PAGE PING FIELDS #

  - dimension: page_ping.x_offset_max
    type: int
    sql: ${TABLE}.pp_xoffset_max

  - dimension: page_ping.x_offset_min
    type: int
    sql: ${TABLE}.pp_xoffset_min

  - dimension: page_ping.y_offset_max
    type: int
    sql: ${TABLE}.pp_yoffset_max

  - dimension: page_ping.y_offset_min
    type: int
    sql: ${TABLE}.pp_yoffset_min


# TRANSACTION FIELDS #

  - dimension: transaction_item.category
    sql: ${TABLE}.ti_category

  - dimension: transaction_item.currency
    sql: ${TABLE}.ti_currency

  - dimension: transaction_item.name
    sql: ${TABLE}.ti_name

  - dimension: transaction_item.order_id
    sql: ${TABLE}.ti_orderid

  - dimension: transaction_item.price
    type: number
    sql: ${TABLE}.ti_price

  - dimension: transaction_item.quantity
    type: int
    sql: ${TABLE}.ti_quantity

  - dimension: transaction_item.sku
    sql: ${TABLE}.ti_sku

  - dimension: transaction.affiliation
    sql: ${TABLE}.tr_affiliation

  - dimension: transaction.city
    sql: ${TABLE}.tr_city

  - dimension: transaction.country
    sql: ${TABLE}.tr_country

  - dimension: transaction.orderid
    sql: ${TABLE}.tr_orderid

  - dimension: transaction.shipping
    type: number
    sql: ${TABLE}.tr_shipping

  - dimension: transaction.state
    sql: ${TABLE}.tr_state

  - dimension: transaction.tax
    type: number
    sql: ${TABLE}.tr_tax

  - dimension: transaction.total
    type: number
    sql: ${TABLE}.tr_total


# CUSTOM STRUCTURED EVENTS FIELDS #

  - dimension: structured_event.action
    sql: ${TABLE}.se_action

  - dimension: structured_event.category
    sql: ${TABLE}.se_category

  - dimension: structured_event.label
    sql: ${TABLE}.se_label

  - dimension: structured_event.property
    sql: ${TABLE}.se_property

  - dimension: structured_event.value
    type: number
    sql: ${TABLE}.se_value


# CUSTOM UNSTRUCTURED EVENTS FIELDS #

  - dimension: unstructured_event.json
    sql: ${TABLE}.unstruct_event


# FUNNEL FIELDS #
  
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
    sql: COUNT(DISTINCT CASE WHEN {% condition event_1 %} ${event_type} {% endcondition %} THEN ${user.domain_user_id} || ${domain_session_index} END)

  - measure: funnel.event_2_count_sessions
    type: number
    sql: COUNT(DISTINCT CASE WHEN {% condition event_2 %} ${event_type} {% endcondition %} THEN ${user.domain_user_id} || ${domain_session_index} END)

  - measure: funnel.event_3_count_sessions
    type: number
    sql: COUNT(DISTINCT CASE WHEN {% condition event_3 %} ${event_type} {% endcondition %} THEN ${user.domain_user_id} || ${domain_session_index} END)

  - measure: funnel.event_4_count_sessions
    type: number
    sql: COUNT(DISTINCT CASE WHEN {% condition event_4 %} ${event_type} {% endcondition %} THEN ${user.domain_user_id} || ${domain_session_index} END)


# SETS #

  sets:
    count_drill:
      - event_id
      - event_type
      - user.domain_user_id
      - user.id
      - collector_time

