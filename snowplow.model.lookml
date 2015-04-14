- connection: snowplow_demo

- include: "*.view.lookml"       # include all the views
- include: "*.dashboard.lookml"  # include all the dashboards

- explore: event
  joins:
    - join: session
      type: inner
      relationship: many_to_one
      sql_on: ${event.domain_user_id} = ${session.domain_user_id} AND ${event.domain_session_index} = ${session.domain_session_index}
      
- explore: session
