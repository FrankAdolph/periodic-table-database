#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c "

# check if argument was given
if [[ $# == 0 ]]
then
  # if not, exit with message
  echo "Please provide an element as an argument."
else
  # if argument is given
  # check if argument is a number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    # use only atomic_number in where clause
    WHERE_CLAUSE="WHERE atomic_number = $1"
  else
    # use symbol and name in where clause
    WHERE_CLAUSE="WHERE symbol = '$1' OR name = '$1'"
  fi
  # check if element is in database
  PROPS_RESULT=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING (type_id) $WHERE_CLAUSE")
  # if not
  if [[ -z $PROPS_RESULT ]]
  then
    # exit with message
    echo "I could not find that element in the database."
  else
    # else 
    # display element information
    IFS="|" read ATOMIC_NUMBER SYMBOL NAME MASS MELTING_POINT BOILING_POINT TYPE <<< $PROPS_RESULT
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  fi
fi
