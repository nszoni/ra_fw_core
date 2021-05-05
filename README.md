# Dr. B Data Warehouse

## Set Up Your Development Environment

1. Clone the [Core framework](https://github.com/rittmananalytics/ra_fw_core/edit/main/README.md) repo locally. 
2. The data warehouse is in the `data/dw` directory of that repo.
3. Ask your project's technical lead for the following:
    - Account and permissions to data warehouse
    - dbt profile to be added to your local `~/.dbt/profiles.yml` file
        - It should looking something like...

        ```yaml
        drb_dw:
            target: dev
            outputs:
                dev:
                    type: snowflake
                    account: yga40986.us-east-1
                    user: dev1
                    password: "PWD"
                    role: TRANSFORMER_DEV
                    database: DW_DEV
                    warehouse: TRANSFORMING_DEV
                    schema: dbt_dev1
                    threads: 1
                    client_session_keep_alive: False
        ```




## Install dbt and its virtual environment

To not run into dependancy issues, virtual environments are recommended for development.

1. Setup your virtual environment: pyenv virtualenvs
    - If you require a new python environment
        - `pyenv versions`
        - `pyenv install 3.7.5`
    - If you require a new virtual environment
        - `cd ~`
        - `pyenv virtualenv venv_drb`
2. Use appropriate virtual environment within git project
    - `cd ~/git_project`
    - `nano .python-version`
    - Write name of virtual environment to use: `venv_drb`
    - Save and exit
    - Exclude `.python-version` from `.gitignore`
3. You'll need to install the following in your project:
    - `pip install dbt==0.19.1`
    - `pip install sqlfluff`
4. Test run your develoment environment
    - `dbt deps` to load packages in your local copy
    - `dbt compile` to compile the project and see if your connection to the data warehouse works as expected
    - `dbt run` to materialize the models in your development schemas
