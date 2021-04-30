# Rittman Analytics Core Framework
This SOP documents the standard approach to work collaboratively on dbt projects in a clean and structured way.

# Setting Up Your Development Environment

## Setup Local Dev Copy of the RA DW Framework

### If you're creating a new project

1. Create a private copy of the [Rittman Analytics Data Warehouse framework](https://github.com/rittmananalytics/ra_data_warehouse)
    1. Create a bare clone of the `ra-data-warehouse` repository
        - `git clone --bare https://github.com/rittmananalytics/ra_data_warehouse.git`
    2. Create a new private repository in the client's account
    3. Mirror-push your bare clone to the new client repository
        - `cd ra_data_warehouse.git`
        - `git push --mirror https://github.com/clientaccount/repository.git`
    4. Remove the temporary ra-data-warehouse local repository
        - `rm -rf ra_data_warehouse.git`
2. Add upstream remotes
    1. Clone the client’s repository
    2. Add the ra-data-warehouse repository as the a remote to fetch future changes
        - `git remote add upstream https://github.com/rittmananalytics/ra_data_warehouse.git`
    3. List remotes
        - `git remote -v`
3. To update client’s repository with upstream changes (**Still needs to be validated)**
    1. Fetch and merge changes
        - `git pull upstream master`


### If you're added as a collaborator to an existing project

1. Clone the repository to your local environment
2. Ask the project's technical lead for instructions to specific configurations required for that project
- Ask your project's technical lead for the following:
    - Account and permissions to data warehouse
    - dbt profile to be added to your local `~/.dbt/profiles.yml` file
        - It should looking something like...

        ```yaml
        clientA:
        	target: dev
        	outputs:
        		dev:
        			type: bigquery
        			method: service-account
        			project: clientA-data-project
        			dataset: analytics_olivier
        			location: EU
        			threads: 1
        			keyfile: /Path/to/json/keyfile.json
        			timeout_seconds: 300
        			priority: interactive
        			retries: 1
        ```

    ### To set up schema / datasets that are to be dedicated to your development work

    The dbt DW framework expanded the number of datasets used for an environment from one (“analytics”) to four, to separate out database objects used for data transformation and process logging from the tables end-users were going to query:

    - `analytics`, the dataset used by end-users and Looker - think of this as the **“**base**”** dataset for their dbt environment
    - `analytics_staging`, a dataset containing SQL views and tables used in the data transformation process
    - `analytics_seed`, a dataset containing tables of reference and lookup data populated from files within the dbt project
    - `analytics_logs`, a dataset that contains audit, profile and logging tables created during data loads

    Note that all of these datasets are automatically created in BigQuery on first run of the dbt DW framework, as long as the GCP service account used by the developer or dbtCloud has the BigQuery Admin role granted.

    For an individual dbt developer, their “base” dataset is determined by the dataset configuration setting in their profiles.yml file

    ```jsx
    ra_data_warehouse: 
    	outputs: 
    		dev: 
    			type: bigquery 
    			method: service-account-json 
    			project: ra-development 
    			dataset: analytics_dev
    ```

    ### Development Environment(s) Naming

    As a developer (as opposed to being dbtCloud), our team should use analytics_dev as their dataset value in the profiles.yml configuration file, which would lead to the following dataset names being created on first run of their dbt project:

    - `analytics_dev`
    - `analytics_staging_dev`
    - `analytics_seed_dev`
    - `analytics_logs_dev`

    This, combined with developing in [git feature branches](https://github.com/rittmananalytics/ra_data_warehouse/blob/master/docs/git_branch_development.md), works out fine for single-developer projects.

    However if there are multiple developers working on the project (note - not doing training exercises), dbt can be configured to use a schema prefix (e.g. “mark”, “lewis”, the developer’s first name) by setting an environment variable before running any of the dbt CLI tools, see the [doc notes on how this works](https://github.com/rittmananalytics/ra_data_warehouse/blob/master/docs/setup.md#cli-steps).

    `export schema_prefix=mark`

    This will thereafter instruct dbt to create dataset names, for individual developer environments, named like this:

    - `mark_analytics_dev`
    - `mark_analytics_staging_dev`
    - `mark_analytics_seed_dev`
    - `mark_analytics_logs_dev`

    This approach of having a separate dev environment for each developer aligns with the [development environment naming approach](https://docs.getdbt.com/docs/running-a-dbt-project/using-the-dbt-ide/#setting-up-developer-credentials) used by the dbtCloud IDE.


## 1.3 Install dbt and its virtual environment

Each project has its own version of dbt and packages that it depends on. To not run into dependancy issues, virtual environments are used to development under the same environment as the one in production. Talk to your project's technical lead to learn about this project's dbt version and packages used.

1. Setup your virtual environment: pyenv virtualenvs
    - If you require a new python environment
        - `pyenv versions`
        - `pyenv install 3.7.5`
    - If you require a new virtual environment
        - `cd ~`
        - `pyenv virtualenv venv_clientA`
2. Use appropriate virtual environment within git project
    - `cd ~/git_project`
    - `nano .python-version`
    - Write name of virtual environment to use: `venv_clientA`
    - Save and exit
    - Exclude `.python-version` from `.gitignore`


# 2. Development Process

### 2.1 Decide what's the scope of a development branch

- Usually associated to a story (either a feature, bug, technical debt, etc.) that is assigned to you
- **Resist the urge to add more than what's scoped by the story and push back on anyone asking to integrate more than is required**


### 2.2 Development steps

1. Create a development branch: `git checkout -b my_development_branch`
2. dbt development, testing and documentation
3. Regularly compile your under-development models: `dbt run --model my_cool_model` (implicitly, this will run against the `dev` profile as we have made it the default)
4. View results of your changes using your favorite SQL IDE. For example: 
5. select * from analytics_olivier.transactions_fact
6. Compile the whole dbt project: `dbt run`
7. Test the whole project: `dbt test` 
8. Commit your changes
    - `git add -A`
    - `git commit -m "Those are the changes I'm making with this commit"`
    - `git push origin my_development_branch`


# 3. Deployment Process

### 3.1 Check whether PR is ready using this checklist

- [ ]  The proposed changes accomplish the story's requirements
- [ ]  The branch compiles and the tests run successfully
- [ ]  You ran `dbt docs generate & serve` and all proposed changes are reflected in the new documentations


### 3.2 Submit the PR using this checklist

- [ ]  Commit your latest revision of the branch to the repository
- [ ]  Press the **Create Pull Request** button in Github
- [ ]  Fill out the PR's submission template that is documented below
- [ ]  Github will then, via dbt, run an automatic build test of branch which will need to pass before the pull request can be merged into the master branch of the dbt repo (talk to the project's technical lead if not automated build tests are being ran)
- [ ]  Add reviewers (at least including the technical lead) once you've created your PR, so that other team members get familiarized with your work and validate that the proposed changes will indeed accomplish the story's requirements, follow coding standards, be fully tested and documented
- [ ]  Inform the project team that a PR has been submitted for the story you'r working on and that anyone is welcomed to review and submit questions/changes if they so desire
- [ ]  Once the review process is completed, it is the responsibility of the technical lead to merge the PR with `master`
- [ ]  It is also the technical lead's responsibility to announce to the project team that a new version of `master` has been created and that everyone should refresh their local `master` branch.
