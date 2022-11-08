#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ Salon booking service ~~~~~\n"


echo -e "\nWelcome to My Salon, how can i help you today?"
MAIN_MENU(){
if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
# available services
  
    AVAILABLE_SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
   echo "$AVAILABLE_SERVICES " | while read SERVICE_ID BAR SERVICE
   do
   echo "$SERVICE_ID) $SERVICE "
  done
  read SERVICE_ID_SELECTED
  case $SERVICE_ID_SELECTED in
    [1-5]) BOOK_MENU ;;
    9) EXIT ;;
    *) MAIN_MENU "I could not find that service. What would you like today?" ;;
    

  esac
}
BOOK_MENU() {
  # ask for service wanted, phone number, name and time
echo "What is your phone number?"
read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
# if number doesnt exist enter phone number and name and add to sql file
  if [[ -z $CUSTOMER_NAME ]] 
  then
  echo -e "\n i'm sorry, i dont have a record for that phone number, what is your name?"
  read CUSTOMER_NAME
  INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')") 
  fi
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = '$SERVICE_ID_SELECTED'")
  echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
  read SERVICE_TIME
# book appointment into diary 
      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone ='$CUSTOMER_PHONE'")
     INSERT_SERVICE_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES('$CUSTOMER_ID', '$SERVICE_ID_SELECTED', '$SERVICE_TIME')") 
# output message i have put you down for SERVICE at TIME, NAME.
echo -e "\n i have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
}
EXIT() {
  echo -e "\nThank you for stopping in.\n"
}

MAIN_MENU
