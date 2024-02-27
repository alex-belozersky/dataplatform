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
DAG_ID = 'crypto'

with DAG(
    dag_id=DAG_ID,
    description='Crypto models',
    start_date=days_ago(1),
    default_args=default_args,
    max_active_runs=1,
    catchup=False,
    schedule='@hourly'
) as dag:

    dbt_run_crypto = DbtRunOperator(
        task_id='dbt_run_crypto',
        retries=0,
        select='demo.lvl3',
    )

    dbt_test_crypto = DbtTestOperator(
        task_id='dbt_test_crypto',
        retries=0,
        select='demo.lvl_3',
    )

    dbt_run_crypto >> dbt_test_crypto
