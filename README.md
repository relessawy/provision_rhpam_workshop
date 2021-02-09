# provision_rhpam_workshop
Script to provision RH PAM workshop to OpenShift

# Prerequisites

The script uses yq command-line YAML processor which can be downloaded from this  [repo](https://github.com/mikefarah/yq)

Note you need to install version 3 of yq

# Running the script

- Note that the script expects you to be logged into OCP

- The scripts expects three input paramters
  - User From: The first user to be provisioned
  - User To: The last user to be provisioned
  - Provision Guides: Set this parameter to Y if you want the module guides to be provisioned
  
# Example

When you run the script with this following inputs

provision_rhpam.sh 1 30 Y

The script will provision users 1 to 30 and also provision the module guides in the project rhpam-workshop-guides. Following is a sample output

Provisioning for users 1 to 30
Provisioning project rhpam-user1
Now using project "rhpam-user1" on server "<cluster name>”.
Creating operator group in project rhpam-user1
operatorgroup.operators.coreos.com/businessautomation-operator created
subscribing to operator in project rhpam-user1
subscription.operators.coreos.com/businessautomation-operator created
going to sleep for 1 min until operator is installed
operator will now installing rhpam in rhpam-user1
kieapp.app.kiegroup.org/rhpam created
finished rhpam-user1

request to provision guides is set to Y
provisioning instructions for module in project rhpam-workshop-guides
