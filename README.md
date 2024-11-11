# CS586_Bikeshop_RelDB
You can find the dataset [here on Kaggle](https://www.kaggle.com/datasets/dillonmyrick/bike-store-sample-database/data?select=staffs.csv).

### Steps to set up the Database

**Step 1:** To build the DB, first create a PostgreSQL database named 'bikeshop_reldb'

You can do this by logging into `psql` and running:
```sql
CREATE DATABASE bikeshop_reldb;
```

**Step 2:** After you have downloading the dataset, create the tables and their defined schema by running the command:
```bash
psql -U <YourUser> -d bikeshop_reldb -f schema.sql
```

**Step 3:** After the tables have been created you can load the data from the csv files by running the command:
```bash
"psql -v scriptdir=<Path/To/Your/Working/Directory> -U <YourUser> -d bikeshop_reldb -f load_csv.sql"
```

This should be enough for you to start working with the database!  
