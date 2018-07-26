#!/bin/bash
sleep 60
test $(curl calculator:9080/sum?a=1\&b=2) -eq 3
