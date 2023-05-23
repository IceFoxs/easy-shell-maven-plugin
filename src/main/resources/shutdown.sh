#!/bin/bash

cd $(dirname $0)/../target
target_dir=$(pwd)

pid=$(ps ax | grep -i ${appIdentityId} | grep ${target_dir} | grep java | grep -v grep | awk '{print $1}')
if [ -z "$pid" ]; then
  echo "No ${appName} service running."
  exit -1
fi

echo "The ${appName} service (${pid}) is running..."

kill -9 ${pid}

echo "Send shutdown request to ${appName} service(${pid}) OK"
