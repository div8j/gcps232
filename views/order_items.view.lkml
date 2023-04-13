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
    sql: ROUND(${TABLE}.sale_price,1) ;;
  }

  parameter: rtd_th_lower_value {
   # hidden: yes
    type: number
    label: "Lower Threshold Value (RTD)"
    view_label: "Thresholds"
default_value: "-10"
  }

  parameter: rtd_th_upper_value {
    #hidden: yes
    type: number
    label: "Upper Threshold Value (RTD)"
    view_label: "Thresholds"
default_value: "0"
  }

  measure: curr_rev_var_pcnt_to_date {
    type: number
   # hidden: yes
    label: "Revenue - Var. % (Current Period)"
    group_label: "RTD - Current Period (Var.)"
    value_format_name: percent_2
    sql: ${sale_price}/100;;

    html: {% assign var_rtd_lower_th = rtd_th_lower_value._parameter_value | plus:0 %}
    {% assign var_rtd_upper_th = rtd_th_upper_value._parameter_value | plus:0 %}
    {% if var_rtd_lower_th < var_rtd_upper_th %}
    {% if value < var_rtd_lower_th %}
    <div style="color: indianred; font-size:100%"; title="Lower threshold ({{var_rtd_lower_th}}) & Upper threshold ({{var_rtd_upper_th}})">{{rendered_value}}</div>
    {% elsif value >= var_rtd_upper_th %}
    <div style="color: green; font-size:100%"; title="Lower threshold ({{var_rtd_lower_th}}) & Upper threshold ({{var_rtd_upper_th}})">{{rendered_value}}</div>
    {% else %}
    <div style="color: orange; font-size:100%"; title="Lower threshold ({{var_rtd_lower_th}}) & Upper threshold ({{var_rtd_upper_th}})">{{rendered_value}}</div>
    {% endif %}
    {% else %}
    <div style="color: blue; font-size:100%"; title="Threshold values not configured properly, values grayed out">{{rendered_value}}</div>
    {% endif %}
    ;;
  }


  measure: count {
    type: count
    drill_fields: [id, orders.id, inventory_items.id]
  }
  }
