- dashboard: sessions_overview
  title: Sessions Overview
  layout: grid
  rows:
    - elements: [total_sessions, unique_users, sessions_per_user, minutes_per_session]
      height: 250
    - elements: [daily_sessions_by_bounce]
      height: 500
    - elements: [daily_sessions_by_new_repeat]
      height: 500
    - elements: [sessions_bounced_pie, sessions_new_repeat_pie]
      height: 400
    - elements: [custom_funnel]
      height: 500

  filters:
  
  - name: date
    title: Date
    type: date_filter
    default_value: 90 Days

  - name: event_1
    type: field_filter
    explore: event
    field: event.event_type
    default_value: "http://snowplowanalytics.com/"
    
  - name: event_2
    type: field_filter
    explore: event
    field: event.event_type
    default_value: "http://snowplowanalytics.com/product/index.html"
    
  - name: event_3
    type: field_filter
    explore: event
    field: event.event_type
    default_value: "http://snowplowanalytics.com/analytics/index.html"
    
  - name: event_4
    type: field_filter
    explore: event
    field: event.event_type
    default_value: "Funnel analysis - Snowplow Analytics"


  elements:

  - name: total_sessions
    title: Total Sessions
    type: single_value
    model: snowplow
    explore: session
    measures: [session.count]
    listen:
      date: session.start_time
    sorts: [session.count desc]
    limit: 500
    value_format: '[>=1000000] #,##0.0,,"M";[<1000] 0;#,##0.0,"k"'
    font_size: medium
    height: 4
    width: 6
  
  - name: unique_users
    title: Unique Users
    type: single_value
    model: snowplow
    explore: session
    measures: [user.count]
    listen:
      date: session.start_time
    sorts: [user.count desc]
    limit: 500
    value_format: '[>=1000000] #,##0.0,,"M";[<1000] 0;#,##0.0,"k"'
    font_size: medium
    height: 4
    width: 6
    
  - name: sessions_per_user
    title: Sessions per User
    type: single_value
    model: snowplow
    explore: snowplow
    measures: [user.sessions_per_user]
    listen:
      date: session.start_time
    sorts: [user.sessions_per_user desc]
    limit: 500
    font_size: medium
    height: 4
    width: 6

  - name: minutes_per_session
    title: Minutes per Session
    type: single_value
    model: snowplow
    explore: event
    measures: [session.minutes_per_session]
    listen:
      date: session.start_time
    sorts: [session.minutes_per_session desc]
    limit: 500
    font_size: medium
    height: 4
    width: 6
    
  - name: sessions_bounced_pie
    title: Sessions Bounced vs. Not Bounced
    type: looker_pie
    model: snowplow
    explore: event
    dimensions: [session.bounced]
    measures: [session.count]
    listen:
      date: session.start_time
    sorts: [session.count desc]
    limit: 500
    series_labels:
      'Yes': Bounced
      'No': Not Bounced

  - name: sessions_new_repeat_pie
    title: Sessions by New vs. Repeat User
    type: looker_pie
    model: snowplow
    explore: event
    dimensions: [session.is_first_session]
    measures: [session.count]
    listen:
      date: session.start_time
    sorts: [session.count desc]
    limit: 500
    series_labels:
      'Yes': New
      'No': Repeat
    colors: ['#8a7d9c', '#F6989D']

  - name: daily_sessions_by_bounce
    title: Daily Sessions by Bounced (Y/N)
    type: looker_area
    model: snowplow
    explore: event
    dimensions: [session.bounced, session.start_date]
    pivots: [session.bounced]
    measures: [session.count]
    listen:
      date: session.start_time
    sorts: [session.start_date]
    limit: 500
    show_null_points: true
    stacking: normal
    show_value_labels: false
    show_view_names: true
    series_labels:
      'Yes': Bounced
      'No': Not Bounced
    point_style: none
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    x_axis_gridlines: true
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_labels: [Count Sessions]
    x_axis_scale: auto
    x_axis_label: Session Start Date
    point_style: none
    interpolation: linear
    
  - name: daily_sessions_by_new_repeat
    title: Daily Sessions by New Visitor (Y/N)
    type: looker_area
    model: snowplow
    explore: event
    dimensions: [session.is_first_session, session.start_date]
    pivots: [session.is_first_session]
    measures: [session.approximate_count]
    listen:
      date: session.start_time
    sorts: [session.start_date desc]
    limit: 500
    colors: ['#8a7d9c', '#F6989D']
    show_null_points: true
    stacking: normal
    show_value_labels: false
    show_view_names: true
    series_labels:
      'Yes': New
      'No': Repeat
    x_axis_gridlines: true
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_labels: [Count Sessions]
    x_axis_scale: auto
    x_axis_label: Session Start Date
    point_style: none
    interpolation: linear
    
  - name: custom_funnel
    title: Custom Funnel Analysis
    type: looker_column
    model: snowplow
    explore: event
    measures: [funnel.event_1_count_sessions, funnel.event_2_count_sessions, funnel.event_3_count_sessions,
      funnel.event_4_count_sessions]
    listen:
      event_1: event.event_1
      event_2: event.event_2
      event_3: event.event_3
      event_4: event.event_4
    sorts: [session.start_date desc, funnel.event_1_count_sessions desc]
    limit: 500
    show_dropoff: true
    show_value_labels: true
    show_view_names: true
    show_null_labels: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_combined: true
    y_axis_labels: [Count Sessions]
    x_axis_gridlines: false
    show_x_axis_label: true
    show_x_axis_ticks: true
    series_labels:
      funnel.event_1_count_sessions: Event 1
      funnel.event_2_count_sessions: Event 2
      funnel.event_3_count_sessions: Event 3
      funnel.event_4_count_sessions: Event 4
    stacking: ''
    x_axis_scale: auto
 

