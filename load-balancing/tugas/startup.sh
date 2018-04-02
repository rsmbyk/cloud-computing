#!/usr/bin/env bash

methods=($(ls balancer/methods))

if [ ! "$1"]
then
    echo Load Balancing method must be specified.
    exit 1
fi

function is_method_valid () {
    for method in ${methods[*]}
    do
        if [ "$1" = "$method" ]
        then
            return 1
        fi
    done
    return 0
}

is_method_valid $1

if [ $? -eq 0 ]
then
    echo Load Balancing method can not be found.
    echo -e Available methods are: '\e[93m'${methods[*]}'\e[0m'
    exit 1
fi

# start balancer
echo Starting Load Balancer...
cp -f balancer/methods/${1} balancer/balancer.conf
cd balancer
vagrant up
cd ..

# start workers
echo Starting Workers...
cd workers
cd worker1
vagrant up
cd ..
cd worker1
vagrant up
cd ..

# return to root directory
cd ..
