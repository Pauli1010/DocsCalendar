# README

This project was created as a recruitment task, based on the description in `SWE_Candidate_Take_Home_Assessment.pdf` file.

Additional information about data models and code flow is provided in file: `---`

## Technical details

### Ruby version
3.1.3

### System dependencies

## Configuration
Below are all the needed steps to launch app locally.

App uses the newest Rails version `7.1.2` and Ruby `3.1.3`. 
It is recommended to use some Ruby version manager to safely switch between ruby versions.

To install Rails run command below in command line:

`gem install rails -v 7.1.2`

or from the app folder run:

`bundle install`

For encryption purposes on your local machine create the master key with the command:

`bin/rails credentials:edit -e development`

Or for not environment specific use command:

`bin/rails credentials:edit`

It will create files holding keys for encryption.

To initialize DB make sure you have installed PostgresSQL DB.
Default configuration for databases is set in `config/database.yml`.
It is recommended to create `.env` file with all the necessary constants for local environment.

After updating credentials you initialize your db:

`bin/rails db:setup`

which will initialize database, run all migrations and seed data.

Seeder uses FactoryBot definitions - the same that are being used in test suite.

### How to run the test suite

Tests are being handled by Rspec. To run all tests from the main app folder run command:

`rspec`

You can also specify singular files:

`rspec spec/models/user_spec.rb`

or singular tests by providing line number:

`rspec spec/models/user_spec.rb:52`

