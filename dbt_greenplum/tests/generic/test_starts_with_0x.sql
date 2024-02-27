{% test test_starts_with_0x(model, column_name) %}

select {{ column_name }}
from {{ model }}
where SUBSTRING({{ column_name }},1,2) <> '0x'

{% endtest %}