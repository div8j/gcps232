view: order_items {
  sql_table_name: demo_db.order_items ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.order_id ;;
  }

  dimension: phone {
    type: string
    sql: ${TABLE}.phone ;;
  }

  dimension: phones {
    type: string
    sql: ${TABLE}.phones ;;
  }

  dimension_group: returned {
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
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  measure: count {
    type: count
    drill_fields: [id, orders.id, inventory_items.id]
  }

  parameter: demo {
    type: unquoted
    allowed_value: {
      label: "Less than 500"
      value: "sale_price"
    }
    allowed_value: {
      label: "Less than 10,000"
      value: "order_id"
    }
    allowed_value: {
      label: "All Results"
      value: "phones"
    }
}

measure: test {
  type: number
  sql: CASE
        WHEN {% parameter demo %} = 'sale_price'
        THEN ${sale_price}
        WHEN {% parameter demo %} = 'order_id'
        THEN ${order_id}
        WHEN {% parameter demo %} = 'phones'
        THEN ${phones}
        ELSE 1
        END
        ;;
}
}
