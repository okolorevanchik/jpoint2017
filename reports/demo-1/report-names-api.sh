#!/usr/bin/env bash

# -- warm up
echo "==> warming up"
echo "GET http://192.168.5.2:8080/name" | vegeta attack -duration=10s | vegeta report
sleep 1


# -- stress test

# initiate app update
(cd ../../vms && ansible-playbook -i vagrant play-update-names-api.yml && echo "==> app updated") &

# simulate load
REPORT_NAME=names-api

echo "==> simulation load"

echo "GET http://192.168.5.2:8080/name" | vegeta attack -duration=10s -rate=200 > $REPORT_NAME.bin
cat $REPORT_NAME.bin | vegeta report
cat $REPORT_NAME.bin | vegeta report -reporter=plot > $REPORT_NAME.html