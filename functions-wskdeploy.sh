#!/bin/bash
# votre script ici
echo ">>> Downloading Whisk Deploy…"
wget -q https://github.com/apache/incubator-openwhisk-wskdeploy/releases/download/latest/openwhisk_wskdeploy-latest-linux-amd64.tgz
echo ">>> Installing Whisk Deploy…"
mkdir openwhisk
tar -zxvf ./openwhisk_wskdeploy-latest-linux-amd64.tgz wskdeploy
rm -rd ./openwhisk_wskdeploy-latest-linux-amd64.tgz

echo ">>> Checking installed version of Whisk Deploy…"
./wskdeploy version

echo ">>> Logging into IBM Cloud…"
ibmcloud login --apikey $DEPLOYER_API_KEY -o $ORG -s $SPACE -r eu-de
echo ">>> Replacing NAMESPACE In Manifest File…"
sed -i "s/@NAMESPACE@/$NAMESPACE/g" manifest.yaml
echo ">>> Contents Of Manifest File:"
cat manifest.yaml
echo ">>> Currently Deployed Packages:"
ibmcloud fn package list
echo ">>> Currently Deployed Actions:"
ibmcloud fn action list
echo ">>> Currently Deployed Triggers:"
ibmcloud fn trigger list
echo ">>> Currently Deployed Rules:"
ibmcloud fn rule list
echo ">>> Deploying Actions Using WhiskDeploy…"
./wskdeploy sync -m manifest.yaml
RESULT=$?
if [ $RESULT -eq 0 ]; then
  STATUS="pass"
else
  STATUS="fail"
fi
# Record deploy information
  ibmcloud doi publishdeployrecord --env $NAMESPACE \
    --buildnumber ${SOURCE_BUILD_NUMBER} --logicalappname ${FUNCTION_NAME} --status ${STATUS}
echo ">>> Successfully Deployed Actions Using WhiskDeploy."
