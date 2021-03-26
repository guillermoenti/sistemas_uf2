#!/bin/bash


PORT=2021

IP_CLIENT="127.0.0.1"

if [ "$1" == "" ]; then
	IP_SERVER="127.0.0.1"
else
	IP_SERVER="$1"
fi

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
if [ "$RESPONSE" != "YES_IT_IS" ];then
	echo "ERROR: Handshake incorrecto"
	exit 1
fi

FILE_NAME="vaca_salida.txt"
FILE_MD5=`echo $FILE_NAME | md5sum | cut -d " " -f 1`

sleep 1
echo "FILE_NAME $FILE_NAME $FILE_MD5" | nc -q 1 $IP_SERVER $PORT

RESPONSE=`nc -l -p $PORT`

if [ "$RESPONSE" != "OK_FILE_NAME" ]; then
	echo "ERROR: Envío de archivo fallido"
	exit 1

fi

sleep 1
cat $FILE_NAME | nc -q 1 $IP_SERVER $PORT

exit 0
