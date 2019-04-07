#!/bin/sh

TORRC_PATH=${TORRC_PATH:=/home/tor/torrc}

if [ -e usertorrc ]; then
  echo "Found user torrc configuration. Applying it..."
  cat usertorrc >> ${TORRC_PATH}
fi

PASSWORD_APPLIED=$(grep HashedControlPassword ${TORRC_PATH} -c)

if [ -e userscript.sh ]; then
  echo "Found userscript. Applying it..."
  /bin/sh userscript.sh
fi

if [ ! -z "$EXIT_NODES" ]; then
  "Found EXIT_NODES environment variable. Applying it..."
  echo "ExitNodes $EXIT_NODES" >> ${TORRC_PATH}
fi

if [ ! -z "$COUNTRY" ]; then
  "Found COUNTRY environment variable. Applying it as exit node..."
  echo "ExitNodes {$COUNTRY}" >> ${TORRC_PATH}
fi

if [ $PASSWORD_APPLIED -eq "0" ]; then

  echo "HashedControlPassword" `/usr/bin/tor --hash-password $PASSWORD` >> ${TORRC_PATH}
fi

echo "Resulting torrc config file:"
cat ${TORRC_PATH}

SOCKS_PORT=${SOCKS_PORT:=9050}
CONTROL_PORT=${CONTROL_PORT:=9151}
sed -e -i "s/@@SOCKS_PORT@@/${SOCKS_PORT}/g" ${TORRC_PATH}
sed -e -i "s/@@CONTROL_PORT@@/${CONTROL_PORT}/g" ${TORRC_PATH}

tor -f ${TORRC_PATH}



