# Set up project and fork framework
Create a private copy of the Rittman Analytics Data Warehouse core framework
- Create a new empty and private repository for your project
- Create a temporary local directory to setup the core framework
- Create a bare clone of the core framework within that temp directory
    - `git clone --bare https://github.com/rittmananalytics/ra_fw_core.git`
- Mirror-push your bare clone to the new client repository
    - `cd ra_fw_core.git`
    - `git push --mirror https://github.com/project_account/project_repository.git`
-Delete your local temporary directory

Add upstream remotes
- Clone the project's repository
- Add the `ra_dw_core` repository as the a remote to fetch future changes
    - `git remote add core_fw https://github.com/rittmananalytics/ra_fw_core.git`
- List remotes
    - `git remote -v`

To update client’s repository with upstream changes
- Fetch and merge changes
    - `git pull core_fw main`

Finish setting up project
- Update `dbt_config.yml` configurations
- Bring in initial dependencies with `dbt deps`
- Compile to validate all works: `dbt compile`


# Add sources and warehouses
Add submodules
- `git submodule add https://github.com/rittmananalytics/ra_fw_source_segment.git models/staging/segment/`
- To remove submodules
    1. `git submodule deinit -f -- ra_fw_source_segment`
    2. `rm -rf .git/modules/a/ra_fw_source_segment`
    3. `git rm -f a/ra_fw_source_segment`

Update a submodule
* Go to the submodules root and update as with any git repository
* You can see that it points to that module's git repository: `git remote -v`
* Update to latest version: `git pull origin master` 

Initialising submodules when clone a repository
* `git submodule init`
* `git submodule update`

Here's a resource for [more info on working with submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules)

# Package dependencies
* Some modules depend on dbt packages, so be sure to...
    * Add them in `packages.yml`
    * Configure you `dbt_project.yml` consequently
    * Run `dbt deps`
