# Install separate Python env for DBT
# Base environment could easily conflict with DBT
# so this step is HIGHLY recommended

python -m venv dbt-venv
source dbt-venv/bin/activate
pip install -r requirements.txt

# Initializing DBT project
cd dataplatform/dbt_greenplum/
dbt init

# DBT profile must include profile suitable for DBT project - see dbt-***/dbt_project.yml
nano /home/jupyter-admin/.dbt/profiles.yml

# Test run
dbt debug