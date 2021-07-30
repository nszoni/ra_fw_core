{{
    config(
        enabled = false
    )
}}

{%- set columns_to_compare = [
    'metric_1',  
    'metric_2', 
    'metric_3']  -%}
{%- set start_date = 'date_add(current_date(), interval -14 day)' -%}
{%- set end_date = 'date_add(current_date(), interval -7 day)' -%}
{%- set model_targeted = 'xa_model' -%}
{%- set model_pk = 'xa_model_pk' -%}
{%- set target_date = 'update_ts' -%}

{{ inject_regression_logic(columns_to_compare, target_date, start_date, end_date, model_targeted, model_pk) }}