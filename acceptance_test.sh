#!/bin/bash
CALCULATOR_PORT=$(docker-compose port calculator 9080 | cut -d: -f2)
#test $(curl localhost:$CALCULATOR_PORT/sum?a=1\&b=2) -eq 3
test $(./gradlew acceptanceTest -Dcalculator.url=http://localhost:9080) -eq 3
