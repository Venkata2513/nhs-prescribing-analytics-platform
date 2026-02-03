with contexts as (

    select
        preparation_class,
        prescribed_preparation_class,
        advanced_service_type
    from {{ ref('stg_snomed_presentations') }}

    union

    select
        preparation_class,
        prescribed_preparation_class,
        advanced_service_type
    from {{ ref('stg_presentations') }}

),

standardised as (

    select distinct
        preparation_class,
        prescribed_preparation_class,
        nullif(trim(advanced_service_type), '') as advanced_service_type
    from contexts

),

final as (

    select
        -- Deterministic key: same inputs always produce same id
        md5(
            coalesce(cast(preparation_class as varchar), '∅') || '|' ||
            coalesce(cast(prescribed_preparation_class as varchar), '∅') || '|' ||
            coalesce(advanced_service_type, '∅')
        ) as prescribing_context_id,

        preparation_class,
        prescribed_preparation_class,
        advanced_service_type

    from standardised

)

select *
from final
