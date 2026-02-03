with fy as (

    select financial_year from {{ ref('stg_snomed_presentations') }}
    union
    select financial_year from {{ ref('stg_presentations') }}
    union
    select financial_year from {{ ref('stg_chemical_substances') }}

),

clean as (

    select distinct
        nullif(trim(financial_year), '') as financial_year
    from fy

),

filtered as (

    select financial_year
    from clean
    where financial_year is not null
      and regexp_substr(financial_year, '^[0-9]{4}') is not null
      and regexp_substr(financial_year, '[0-9]{2}$') is not null

),

parsed as (

    select
        financial_year,
        try_cast(regexp_substr(financial_year, '^[0-9]{4}') as integer) as fy_start_year,
        try_cast(left(financial_year, 2) || regexp_substr(financial_year, '[0-9]{2}$') as integer) as fy_end_year
    from filtered

)

select
    md5(financial_year) as time_id,
    financial_year,
    fy_start_year,
    fy_end_year
from parsed
