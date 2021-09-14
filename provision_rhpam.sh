#!/bin/bash
START=$1
END=$2
PROVISION_GUIDES=$3
VERSION=$4

echo Provisioning for users $START to $END

for (( c=$START; c<=$END; c++ ))
  do
ProjectXX="rhpam-user";
ProjectXX="${ProjectXX}${c}";

echo Provisioning project $ProjectXX

oc new-project $ProjectXX

echo Creating operator group in project $ProjectXX

cp operator_group.yaml ./output/operator_group_$ProjectXX.yaml

if [ $VERSION == 4 ] 
then
  #Version 4 of YQ
  yq eval ".metadata.namespace=\"$ProjectXX\"" -i ./output/operator_group_$ProjectXX.yaml 
  yq eval ".spec.targetNamespaces += [\"$ProjectXX\"]" -i ./output/operator_group_$ProjectXX.yaml 
else
  yq w -i ./output/operator_group_$ProjectXX.yaml metadata.namespace $ProjectXX
  yq w -i ./output/operator_group_$ProjectXX.yaml spec.targetNamespaces[+] $ProjectXX
fi

oc create -f ./output/operator_group_$ProjectXX.yaml

echo subscribing to operator in project $ProjectXX

cp operator_subscribe.yaml ./output/operator_subscribe_$ProjectXX.yaml
if [ $VERSION == 4 ] 
then
  #Version 4 of YQ
  yq eval ".metadata.namespace=\"$ProjectXX\"" -i ./output/operator_subscribe_$ProjectXX.yaml 
else
  yq w -i ./output/operator_subscribe_$ProjectXX.yaml metadata.namespace $ProjectXX
fi

oc create -f ./output/operator_subscribe_$ProjectXX.yaml

echo going to sleep for 90 secs until operator is installed

sleep 90

echo operator will now install rhpam in $ProjectXX

oc create -f rhpam.yaml

echo finished $ProjectXX


done

echo request to provision guides is set to $PROVISION_GUIDES

if [ "$PROVISION_GUIDES" == "Y" ]
then

  sleep 30

  echo provisioning instructions for module 1 in project rhpam-workshop-guides

  oc new-project rhpam-workshop-guides

  oc new-app --name=m1-guide --docker-image=quay.io/osevg/workshopper:latest -e WORKSHOPS_URLS=https://raw.githubusercontent.com/relessawy/rhpam-rhdm-workshop-v1m1-guides/master/_rhpam-rhdm-workshop-module1.yml -e CONTENT_URL_PREFIX=https://raw.githubusercontent.com/relessawy/rhpam-rhdm-workshop-v1m1-guides/master/
  sleep 30
  oc expose svc/m1-guide

  oc new-app --name=m2-guide --docker-image=quay.io/osevg/workshopper:latest -e WORKSHOPS_URLS=https://raw.githubusercontent.com/relessawy/rhpam-rhdm-workshop-v1m2-guides/master/_rhpam-rhdm-workshop-module2.yml -e CONTENT_URL_PREFIX=https://raw.githubusercontent.com/relessawy/rhpam-rhdm-workshop-v1m2-guides/master/
  sleep 30
  oc expose svc/m2-guide
fi
