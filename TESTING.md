## test kitchen

### install test kitchen

gem install test-kitchen

### local

run command "kitchen converge"


### cloud openstack

we need to use the .kitchen.cloud.yml

run command "export KITCHEN_YAML=.kitchen.cloud.yml"

and you also need to set the following enviroment variables if you want to use openstack
export OPENSTACK_USERNAME=YOUR USERNAME
export OPENSTACK_API_KEY=YOUR API KEY
export OPENSTACK_AUTH_URL="YOUR AUTH URL"
export KEY_NAME=YOUR SSH KEYNAME IN OPSTACK
export PRIVATE_KEY_PATH="YOUR SSH KEY LOCATION"
