#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~~~~~~~~~ Salon ~~~~~~~~~~~~~~\n"

MAIN_MENU_SERVICES() {
#------------------------------------------ Display services by a "Case Menu" --------------------------------
  if [[ $1 ]]
  then
    echo -e "\n$1?"
  fi
  echo "Choose a service"
  # Get services
  SERVICES=$($PSQL "SELECT service_id,name FROM services WHERE service_id IS NOT NULL ORDER BY service_id")
  

  # If not found
  if [[ -z $SERVICES ]]
  then
    echo "Sorry we don't have any service right now"
  else
    # Display the services
    echo "$SERVICES" | while read SERVICE_ID BAR NAME 
    do
      echo -e "$SERVICE_ID) $NAME"
    done
    read SERVICE_ID_SELECTED
    case $SERVICE_ID_SELECTED in
      1) CUT_SERVICE ;;
      2) MASSAGE_SERVICE ;;
      3) SHAMPOO_SERVICE ;;
      *) MAIN_MENU_SERVICES "Please enter a valid option." ;;
    esac
  fi
}

#-------------------------------------- Cut Service -----------------------------------------------------

CUT_SERVICE() {
  INSERTING_METHOD
}
#-------------------------------------- Message Serivice --------------------------------------------------

MASSAGE_SERVICE() {
 INSERTING_METHOD
}

#-------------------------------------- Shampoo Service ----------------------------------------------------

SHAMPOO_SERVICE() {
  INSERTING_METHOD

}
#------------------ Inserting function to just put the function into the other services functions ----------------

INSERTING_METHOD () {
  # Get a service_id
  SERVICE_ID=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  # Get customer info 
  # Get a phone
    # ask for a phone number
  echo "please enter a phone number"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

  # if CUSTOMER_NAME doesn't exist 
  if [[ -z $CUSTOMER_NAME ]]
  then

    echo -e "\nWhat's your name"
    read CUSTOMER_NAME
    
    INSERT_CUSTOMER_DATA=$($PSQL "INSERT INTO customers(phone,name) VALUES ('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
        
  fi


  echo -e "\nat what time"
  read SERVICE_TIME 
  # get customer id
    
  NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

  INSERT_APPOINTMENT_DATA=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES ($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")

  echo "I have put you down for a $NAME at $SERVICE_TIME, $CUSTOMER_NAME."

}
#---------------------------------------------------------------------------------------------------------------

MAIN_MENU_SERVICES
