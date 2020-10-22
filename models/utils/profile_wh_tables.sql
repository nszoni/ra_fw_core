{{ config(
    tags=["manual"]
) }}

{% set warehouse_schema = target.schema %}

{{ profile_schema(warehouse_schema) }}
