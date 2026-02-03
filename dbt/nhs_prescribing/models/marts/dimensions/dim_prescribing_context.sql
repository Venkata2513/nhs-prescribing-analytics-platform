select
    prescribing_context_id,
    preparation_class,
    prescribed_preparation_class,
    advanced_service_type
from {{ ref('int_dim_prescribing_context') }}
