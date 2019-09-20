ibmcloud login --apikey ${IBM_CLOUD_API_KEY} --no-region
ibmcloud doi evaluategate --logicalappname=${IMAGE_NAME} --buildnumber=${SOURCE_BUILD_NUMBER} --policy=staging --forcedecision true
