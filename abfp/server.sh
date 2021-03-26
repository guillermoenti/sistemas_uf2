#!/bin/bash

PROTOCOL="ABFP"
PORT=2021

echo "(0) Server ABFP"

echo "(1) Listening: $PORT"
HEADER=`nc -l -p $PORT`

echo "TEST! $HEADER"
PREFIX=`echo $HEADER | cut -d " " -f 1`
IP_CLIENT=`echo $HEADER | cut -d " " -f 2`

echo "(4) Response" 
if [ "$PREFIX" != $PROTOCOL ]; then

	echo "Header error"
	sleep 1
	echo "KO_CONN" | nc -q 1 $IP_CLIENT $PORT
	exit 1

fi

sleep 1
echo "OK_CONN" | nc -q 1 $IP_CLIENT $PORT

echo "(5) Listening:"
HANDSHAKE=`nc -l -p $PORT`

echo "TEST! $HANDSHAKE"
if [ "$HANDSHAKE" != "THIS_IS_MY_CLASSROOM" ]; then

	echo "Handshake error"
	sleep 1
	echo "KO_HANDSHAKE" | nc -q 1 $IP_CLIENT $PORT

fi

echo "(8) Response:"
sleep 1
echo "YES_IT_IS" | nc -q 1 $IP_CLIENT $PORT 

echo "(9) Listening:"
FILE_NAME=`nc -l -p $PORT`

PREFIX=`echo $FILE_NAME | cut -d " " -f 1`
NAME_MD5=`echo $FILE_NAME | cut -d " " -f 3`
FILE_NAME=`echo $FILE_NAME | cut -d " " -f 2`

if [ "$PREFIX" != "FILE_NAME" ]; then
	echo "ERROR: Prefijo FILE_NAME incorrecto"
	
	sleep 1
	echo "KO_FILE_NAME" | nc -q 1 $IP_CLIENT $PORT

	exit 1
fi

TEMP_MD5=`echo $NAME | md5sum | cut -d " " -f 1`

if [ "$NAME_MD5" != "$TEMP_MD5" ]; then
	
	echo "ERRORç: MD5 Incorrecto"

	sleep 1
	echo "KO_FILE_NAME_MD5" | nc -q 1 $IP_CLIENT $PORT
	exit 1
fi

sleep 1
echo "OK_FILE_NAME" | nc -q 1 $IP_CLIENT $PORT

DATA=`nc -l -p $PORT
echo $DATA

exit 0
