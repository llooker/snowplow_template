- connection: snowplow_demo

- include: "*.view.lookml"       # include all the views
- include: "*.dashboard.lookml"  # include all the dashboards

- explore: event
  joins:
    - join: event_extension
      type: inner
      relationship: one_to_one
      foreign_key: event_id
