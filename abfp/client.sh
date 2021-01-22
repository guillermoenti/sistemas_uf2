#!/bin/bash

PORT=2021
IP_CLIENT="127.0.0.1"
IP_SERVER="127.0.0.1"

echo "Client ABFP"

echo "(2) Sending Headers"
echo "ABFP $IP_CLIENT" | nc -q 1 $IP_SERVER $PORT

echo "(3) Listening: $PORT"
RESPONSE=`nc -l -p $PORT`

echo "TEST! $RESPONSE"
if [ "$RESPONSE" != "OK_CONN" ]; then

	echo "Connexion with the server error"
	exit 1

fi

echo "(6) Sending Handshake"
sleep 1
echo "THIS_IS_MY_CLASSROOM" | nc -q 1 $IP_SERVER $PORT

echo "(7) Listening:"
RESPONSE=`nc -l -p $PORT`

exit 0
