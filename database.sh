#!/bin/bash

# Checks if given directory exists
# Accepts one argument $1 (directory)
function dirExists() {
  if [ -d "$1" ]; then
    return 0
  else
    return 1
  fi
}

# Checks if given file exists
# Accepts one argument $1 (file)
function fileExists() {
  if [ -f "$1" ]; then
    return 0
  else
    return 1
  fi
}

# Creates a new table into the database
# Accepts one argument $1 (table_name)
function createTable() {
  if dirExists "$(pwd)/tables"; then
    if dirExists "$(pwd)/tables/$1"; then
      echo "❌️ Table already exists!"
      return
    fi
    mkdir "tables/$1"
    echo "✅ Table created succesfully!"
  else
    mkdir "tables"
    mkdir "tables/$1"
    echo "✅ Table created succesfully!"
  fi
}

# Inserts data into a table
# Accepts two arguments $1 (table_name), $2 (value_name)
function insertInTable() {
  if dirExists "$(pwd)/tables/$1"; then
    if fileExists "$(pwd)/tables/$1/$2"; then
      echo "❌ A value with this name already exists in this table!"
      return
    fi
    touch "$(pwd)/tables/$1/$2"
    echo "✅ $2 created succesfully in table $1!"
  else
    echo "❌ Table $1 does not exist in database!"
  fi
}

# Deletes an existing table
# Accepts one argument $1 (table_name)
function deleteTable() {
  if dirExists "$(pwd)/tables/$1"; then
    rm -rf "$(pwd)/tables/$1"
    echo "✅ Table $1 deleted succesfully!"
  else
    echo "❌ Table $1 does not exist in database!"
  fi
}

# Deletes a table value
# Accepts two arguments $1 (table_name), $2 (value_name)
function deleteTableValue() {
  if dirExists "$(pwd)/tables/$1"; then
    if fileExists "$(pwd)/tables/$1/$2"; then
      rm "$(pwd)/tables/$1/$2"
      echo "✅ Value $1 deleted from table $1 succesfully!"
    else
      echo "❌ A value with this name does not exist in this table!"
      return
    fi
  else
    echo "❌ Table $1 does not exist in database!"
  fi
}

# Lists existing tables in database
function listTables() {
  if dirExists "$(pwd)/tables"; then
    if [[ "$(ls  -1 $(pwd)/tables | wc -l)" -eq 0 ]]; then
      echo "❌ There are no tables in the database!"
    else
      echo "---------- 📂️ Tables in database 📂️ ----------"
      echo "$(ls  -1 $(pwd)/tables)"
    fi
  else
    echo "❌ There are no tables in the database!"
  fi
}

# Lists values from existing table
# Accepts one argument $1 (table_name)
function listTableValues() {
  if dirExists "$(pwd)/tables/$1"; then
    if [[ "$(ls  -1 $(pwd)/tables/$1 | wc -l)" -eq 0 ]]; then
      echo "❌ There are no values in table $1!"
    else
      echo "---------- 📂 Values in table $1 📂 ----------"
      echo "$(ls  -1 $(pwd)/tables/$1)"
    fi
  else
    echo "❌ Table $1 does not exist in database!"
  fi
}

# Checks if there is not arguments in the command
if [[ "$#" -eq 0 ]]; then
  echo "❌️ You did not set enough arguments! ❔️ Need help? Use bash database.sh help"
  exit
fi

# Sends commands guide if help is the first argument
if [[ "$1" == "help" ]]; then
  echo "------------------------------------------------ ❔ Commands Guide ❔ ------------------------------------------------"
  echo "· create table ( table_name ) -> Creates a new table"
  echo "· insert ( table_name ) ( value_name ) -> Inserts a new value into an existing table"
  echo "· delete table ( table_name ) -> Deletes a table whose name equals table_name"
  echo "· delete table-value ( table_name ) ( value_name ) -> Deletes a table value whose name equals value_name"
  echo "· list-tables -> Lists all existing tables"
  echo "· list-table-values ( table_name ) -> Lists all values from an existing table"
  echo "----------------------------------------------------------------------------------------------------------------------"
 exit
else
  # If given arguments are greater than 3, starts checking instructions
  if [[ "$1" == "create" && "$2" == "table" ]]; then
    if [[ "$#" -lt 3 ]]; then
      echo "❌ You did not set enough arguments! ❔ Need help? Use bash database.sh help"
      exit
    fi
    createTable "$3"
  elif [[ "$1" == "insert" ]]; then
    if [[ "$#" -lt 3 ]]; then
      echo "❌ You did not set enough arguments! ❔ Need help? Use bash database.sh help"
      exit
    fi
    insertInTable "$2" "$3"
  elif [[ "$1" == "delete" ]]; then
    if [[ "$#" -lt 3 ]]; then
      echo "❌ You did not set enough arguments! ❔ Need help? Use bash database.sh help"
      exit
    fi
    if [[ "$2" == "table" ]]; then
      deleteTable "$3"
    elif [[ "$2" == "table-value" ]]; then
      deleteTableValue "$3" "$4"
    fi
  elif [[ "$1" == "list-tables" ]]; then
    listTables
  elif [[ "$1" == "list-table-values" ]]; then
    if [[ "$#" -lt 2 ]]; then
      echo "❌ You did not set enough arguments! ❔ Need help? Use bash database.sh help"
      exit
    fi
    listTableValues "$2"
  fi
fi
