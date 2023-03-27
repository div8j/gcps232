view: users {
  sql_table_name: demo_db.users ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }
parameter: test {
  type: unquoted
  allowed_value: {
    value: "Raj"
  }
  allowed_value: {
    value: "sekhar"
  }
}
dimension: test_result {
  type: string
  sql: "{% parameter test %}" ;;
}
  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: city_link {
    type: string
    sql: ${city} ;;
    link: {
      label: "Google"
      url: "http://www.google.com/search?q={{users.state._value}}"
    }
  }

  measure: id_link {
    type: number
    sql: ${id} ;;
    link: {
      label: "Google"
      url: "http://www.google.com/search?q={{users.state._value}}"
    }
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
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

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  dimension: expiry_indicator2 {
    order_by_field: expiry_indicator2_ord
    type: string
    sql:
      CASE
      WHEN ${age} is null THEN '> 90'
      WHEN ${age} < 0     THEN 'Expired'
      WHEN ${age} <= 30   THEN '0 - 30'
      WHEN ${age} <= 60   THEN '31 - 60'
      WHEN ${age} <= 90   THEN '61 - 90'
                                     ELSE '> 90'
      END
  ;;
  }


  dimension: expiry_indicator2_ord {
    type: number
    sql:
      CASE
      WHEN ${age} is null then 5
      WHEN ${age} < 0   THEN 1
      WHEN ${age} <= 30 THEN 2
      WHEN ${age} <= 60 THEN 3
      WHEN ${age} <= 90 THEN 4
      ELSE 5
      END
  ;;
  }


  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      first_name,
      last_name,
      events.count,
      orders.count,
      saralooker.count,
      sindhu.count,
      user_data.count
    ]
  }
}
