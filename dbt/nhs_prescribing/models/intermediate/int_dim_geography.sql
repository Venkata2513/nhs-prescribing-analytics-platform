with from_snomed as (

    select
        nullif(trim(region_code), '') as region_code,
        nullif(trim(region_name), '') as region_name,
        nullif(trim(icb_code), '')    as icb_code,
        nullif(trim(icb_name), '')    as icb_name
    from {{ ref('stg_snomed_presentations') }}

),

from_presentations as (

    select
        nullif(trim(region_code), '') as region_code,
        nullif(trim(region_name), '') as region_name,
        nullif(trim(icb_code), '')    as icb_code,
        nullif(trim(icb_name), '')    as icb_name
    from {{ ref('stg_presentations') }}

),

from_chemicals as (

    select
        nullif(trim(region_code), '') as region_code,
        nullif(trim(region_name), '') as region_name,
        nullif(trim(icb_code), '')    as icb_code,
        nullif(trim(icb_name), '')    as icb_name
    from {{ ref('stg_chemical_substances') }}

),

unioned as (

    select * from from_snomed
    union
    select * from from_presentations
    union
    select * from from_chemicals

),

deduped as (

    select
        icb_code,
        max(icb_name) as icb_name,
        max(region_code) as region_code,
        max(region_name) as region_name
    from unioned
    where icb_code is not null
    group by icb_code

)

select
    -- deterministic key: stable across runs
    md5(icb_code) as geography_id,

    icb_code,
    icb_name,
    region_code,
    region_name

from deduped
