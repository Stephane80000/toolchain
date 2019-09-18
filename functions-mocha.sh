#!/bin/bash
# set -x
if [ -f ./actions/*/tests/*.js ]; then
  npm install -g mocha nyc 
  npm install --save-dev chai express
  nyc --reporter=lcov --reporter=json-summary _mocha -- -R xunit -O output=./tests/mocha.xml 'actions/*/tests/*.js'
  RESULT=$?
  export FILE_LOCATION=./tests/mocha.xml
  ls -l *
  cat ./tests/mocha.xml
  cat ./coverage/coverage-summary.json
  if [ ! -z "${FILE_LOCATION}" ]; then
    echo "FILE_LOCATION : ${FILE_LOCATION}"
    if [ ${RESULT} -ne 0 ]; then STATUS=fail; else STATUS=pass; fi
      cat _toolchain.json
      if jq -e '.services[] | select(.service_id=="draservicebroker")' _toolchain.json; then
        echo "publishtestrecord"
        ibmcloud login --apikey ${IBM_CLOUD_API_KEY} --no-region
        ibmcloud doi publishtestrecord --type unittest --buildnumber ${BUILD_NUMBER} --filelocation ${FILE_LOCATION} \
          --buildnumber ${BUILD_NUMBER} --logicalappname ${IMAGE_NAME}
        #ibmcloud doi publishtestrecord --type code --buildnumber ${BUILD_NUMBER} --filelocation ./coverage/coverage-summary.json \
          --buildnumber ${BUILD_NUMBER} --logicalappname ${IMAGE_NAME}
      fi
  fi
else
  echo "Test runner script not found: ./actions/*/tests/*.js"
fi
