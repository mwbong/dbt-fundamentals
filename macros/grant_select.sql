{% macro grant_select(schema=target.project, role=target.dataset) %}

    {{ log('Project is: ' ~ target.project ~ ' and dataset is ' ~ target.dataset, info=True)}}

{% endmacro %}