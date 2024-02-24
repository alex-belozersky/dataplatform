from datetime import timedelta, datetime

from airflow import DAG
from airflow.utils.task_group import TaskGroup
from airflow.utils.dates import days_ago

from airflow_dbt.operators.dbt_operator import DbtRunOperator, DbtTestOperator

default_args = {
    'owner': 'Alex Belozersky',
    'start_date': datetime(2024, 1, 1),
    'retries': 3,
    'retry_delay': timedelta(minutes=5),
    'depends_on_past': False,
    # 'on_failure_callback': slack_fail_alert,

    # recommended for DBT
    'max_active_runs': 1,
    'profiles_dir': '/home/ubuntu/.dbt',
    'dir': '/home/ubuntu/airflow/dags/dbt_greenplum',
}
DAG_ID = 'airflow_data'



with DAG(
    dag_id=DAG_ID,
    description='Airflow models',
    start_date=days_ago(1),
    default_args=default_args,
    max_active_runs=1,
    catchup=False,
    schedule='@hourly'
) as dag:

    # LEVEL 1
    # run and test airflow sources
    dbt_run_airflow_operator = DbtRunOperator(
        task_id='dbt_run_pxf_load',
        retries=0,  # Fail with no retries if source is bad
        select='sources.pxf.airflow',
    )

    dbt_test_airflow_operator = DbtTestOperator(
        task_id='dbt_test_pxf_load',
        retries=0,  # Fail with no retries if source is bad
        select='sources.pxf.airflow',
    )
    dbt_run_airflow_operator >> dbt_test_airflow_operator

    # LEVEL 2
    # Run all models with airflow tag without sources
    dbt_run_airflow_models = DbtRunOperator(
        task_id='dbt_run_airflow_models',
        retries=0,
        select='tag:airflow',
        exclude='sources',
    )
    dbt_test_airflow_models = DbtTestOperator(
        task_id='dbt_test_airflow_models',
        retries=0,
        select='tag:airflow',
        exclude='sources',
    )
    dbt_test_airflow_operator >> dbt_run_airflow_models >> dbt_test_airflow_models

