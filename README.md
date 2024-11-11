# CS586_Bikeshop_RelDB
https://www.kaggle.com/datasets/dillonmyrick/bike-store-sample-database/data?select=staffs.csv <-- you can find a link to the dataset here!

Step 1: To build the DB, first create a database called bikeshop_reldb

Step 2: After you have downloaded the file, create the tables and their defined schema by running the command "psql -U <YourUser> -d bikeshop_reldb -f schema.sql"

Step 3: After the tables have been created you can load the data from the csv files by running the commond "psql -v <Path/To/Your/Working/Directory> -d bikeshop_reldb -f load_csv.sql"

This should be enough for you to start working with the database!  
