with source as (

    {% if target.name != 'prod' %}

        select * from {{ source('app_dev', 's_patient') }}

    {% else %}

        select from {{ source('app', 's_patient') }}
    
    {% endif %}

),

base as (

    select
        cast(ID as varchar) as patient__app__natural_key

    from source

)

select * from base