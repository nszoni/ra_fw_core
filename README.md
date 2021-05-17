# RA Warehouse Framework Setup Steps

## Set Up Your Development Environment

1. Clone the [Core framework](https://github.com/rittmananalytics/ra_fw_core/edit/main/README.md) repo locally. 
2. The data warehouse is in the `data/dw` directory of that repo.
3. Ask your project's technical lead for the following:
    - Account and permissions to data warehouse
    - dbt profile to be added to your local `~/.dbt/profiles.yml` file
        - It should looking something like...

        ```yaml
        ra_data_warehouse:
          outputs:
            dev:
              type: bigquery
              method: service-account-json
              project: ra-development
              dataset: analytics
              location: europe-west2
              threads: 1
              timeout_seconds: 300
              keyfile_json:
                type: service_account
                project_id: ra-development
                private_key_id: f14ff3e3f832464e2f02f6cc964e1bdcf1ca4fb4
                private_key: "..."
        client_email: dbt-578@ra-development.iam.gserviceaccount.com
        client_id: 100669809469159724177
        auth_uri: https://accounts.google.com/o/oauth2/auth
        token_uri: https://oauth2.googleapis.com/token
        auth_provider_x509_cert_url: https://www.googleapis.com/oauth2/v1/certs
        client_x509_cert_url: https://www.googleapis.com/robot/v1/metadata/x509/dbt-578%40ra-development.iam.gserviceaccount.com
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


## Familiarize yourself with the framework
This framework has built-in architecture, tooling and conventions. Here's a list of what you should get familiar with:
- The [transformation and testing sequence](resources/transformation_testing_sequence_strategy.md) documents how we architect our dbt projects.
- The [dbt coding convention](resources/dbt_coding_conventions.md) which hightlights all the coding's best practices and conventions we follow.
- The [pull request template](pull_request_template.md) which tells you what's required before submitting a PR for review.
- The [project's relase process](resources/release_process.jpeg) which gives an overview of how we merge and release new features.