#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# tested

# check if user provided an argument or not
if [[ -z "$1" ]]
  then
    echo "Please provide an element as an argument."
  else

    # checking argument if it's a number
    if [[ $1 =~ ^[0-9]+$ ]]
      then
      # checking requested element found or not
      ATOMIC_NUMBER_RESULT=$($PSQL "SELECT * FROM elements WHERE atomic_number=$1")
      REQ_RESULT=$($PSQL "SELECT * FROM elements FULL JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE atomic_number = $1")
      IFS='|'

      if [[ -z $ATOMIC_NUMBER_RESULT ]]
        then
          # if element could not be found
          echo "I could not find that element in the database."
        else
          # element's found
          
          read -a args <<< "$REQ_RESULT"
          ATOMIC_NUMBER="${args[1]}"
          SYMBOL="${args[2]}"
          NAME="${args[3]}"
          ATOMIC_MASS="${args[4]}"
          MELTING="${args[5]}"
          BOILING="${args[6]}"
          TYPE="${args[7]}"
          echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a nonmetal, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
        fi

    elif [[ -n $1 ]]
      then
        # checking requested element found or not
      ATOMIC_NUMBER_RESULT=$($PSQL "SELECT * FROM elements WHERE symbol = '$1' OR name = '$1'")
      REQ_RESULT=$($PSQL "SELECT * FROM elements FULL JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE symbol = '$1' OR name = '$1'")

      IFS='|'

      if [[ -z $REQ_RESULT ]]
        then
          # if element could not be found
          echo "I could not find that element in the database."
        else
          
          # element's found
          read -a args <<< "$REQ_RESULT"
          ATOMIC_NUMBER="${args[1]}"
          SYMBOL="${args[2]}"
          NAME="${args[3]}"
          ATOMIC_MASS="${args[4]}"
          MELTING="${args[5]}"
          BOILING="${args[6]}"
          TYPE="${args[7]}"


          echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a nonmetal, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
        fi
    else
        # if element could not be found
        echo "I could not find that element in the database."
    fi
fi