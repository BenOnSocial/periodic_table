#!/bin/bash

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit 0
fi

PSQL="psql --username=freecodecamp --dbname=periodic_table -t -c"
JOIN="select atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements inner join properties using(atomic_number) inner join types using(type_id)"
RESULT=

if [[ $1 -gt 0 ]]
then
  RESULT="$($PSQL "${JOIN} where atomic_number=$1;")"
elif [[ $1 =~ ^[a-zA-Z][a-zA-Z]?$ ]]
then
  RESULT="$($PSQL "${JOIN} where symbol='$1';")"
else
  RESULT="$($PSQL "${JOIN} where name='$1';")"
fi

if [[ -z $RESULT ]]
then
  echo "I could not find that element in the database."
  exit 0
fi

echo $RESULT | while read ATOMIC_NUMBER BAR NAME BAR SYMBOL BAR TYPE BAR ATOMIC_MASS BAR MELTING_POINT_C BAR BOILING_POINT_C
do
  echo "The element with atomic number ${ATOMIC_NUMBER} is ${NAME} (${SYMBOL}). It's a ${TYPE}, with a mass of ${ATOMIC_MASS} amu. ${NAME} has a melting point of ${MELTING_POINT_C} celsius and a boiling point of ${BOILING_POINT_C} celsius."
done

exit 0
