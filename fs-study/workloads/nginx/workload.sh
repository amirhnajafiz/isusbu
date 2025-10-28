#!/usr/bin/env bash

# check to see if apache-benchmark is installed
if ! command -v ab &> /dev/null
then
    echo "apache-benchmark could not be found, please install it to run this workload."
    exit 1
fi

# use apache-benchmark to send requests to nginx server
ab -n 1000 -c 10 http://localhost/
