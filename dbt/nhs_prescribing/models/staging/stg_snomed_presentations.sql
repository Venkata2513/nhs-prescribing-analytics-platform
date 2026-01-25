select
    *
from {{ source('raw', 'snomed_presentations') }}
