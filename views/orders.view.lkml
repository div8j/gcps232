view: orders {
  sql_table_name: demo_db.orders ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: row_check{
    type: count
    html:
    {% if row['orders.status'] == 'cancelled'%}
      <p style="color: red">{{ rendered_value }}</p>
    {% elsif row['orders.status'] == 'complete'%}
      <p style="color: yellow">{{ rendered_value }}</p>
    {% else %}
      <p style="color: green">{{ rendered_value }}</p>
    {% endif %};;
  }

  measure: returned_count {
    type: count_distinct
    sql: ${id} ;;
    drill_fields: [detail*]
    link: {
      label: "Explore Top 20 Results"
      url: "{{ link }}&limit=20"
    }
  }
  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      users.id,
      users.first_name,
      users.last_name,
      billion_orders.count,
      fakeorders.count,
      hundred_million_orders.count,
      hundred_million_orders_wide.count,
      order_items.count,
      order_items_vijaya.count,
      ten_million_orders.count
    ]
  }
}
