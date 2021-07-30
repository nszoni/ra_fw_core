{% macro inject_regression_logic(columns_to_compare, target_date, start_date, end_date, model_targeted, model_pk) %}  

    {% set prod_model %}
        select * from analytics.{{ model_targeted }}
        where date({{ target_date }}) >= {{ start_date }}
        and date({{ target_date }}) <= {{ end_date }}
    {% endset %}

    {% set dev_model %}
        select * from {{ ref( model_targeted ) }}
        where date({{ target_date }}) >= {{ start_date }}
        and date({{ target_date }}) <= {{ end_date }}
    {% endset %}

    {% for column in columns_to_compare %}
        {% set audit_query = audit_helper.compare_column_values(
            a_query = prod_model,
            b_query = dev_model,
            primary_key = model_pk,
            column_to_compare = column)
        %}

        {{ audit_query }}

        {% set audit_results = run_query(audit_query) %}

        {% if execute %}
            {{ log('Comparing column "' ~ column ~'"', info=True) }}   
            {% do audit_results.print_table() %}
            {{ log("", info=True) }}
        {% endif %}
    {% endfor %}

{% endmacro %}