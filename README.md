# Bamboo status [![Build Status](https://travis-ci.org/afklm/bamboo.png?branch=master)](https://travis-ci.org/afklm/bamboo)

## Description

Installs/Configures [Atlassian Bamboo](https://www.atlassian.com/software/Bamboo/)

## Usage

### Bamboo Server Installation

* Add `recipe[bamboo]` to your node's run list.

### Bamboo Agent Installation

* Add `recipe[bamboo::agent]` to your node's run list.

## Recipes

* recipe "bamboo::default", "Installs the bamboo server with optional backup in place and logging to graylog."
* recipe "bamboo::server", "Only installs the bamboo server."
* recipe "bamboo::database", "Only installs the bamboo database."
* recipe "bamboo::agent", "Installs a bamboo agent."

## Requirements

### Platforms

* CentOS 6.x
* Mac OS X 10.10
* Ubuntu >= 14.04

### Databases

* MySQL
* Postgres

### Cookbook dependencies

Required [Opscode Cookbooks](https://github.com/opscode-cookbooks/)

* [apache2](https://github.com/opscode-cookbooks/apache2) (if using Apache 2 proxy)
* [ark](https://github.com/opscode-cookbooks/ark)
* [database](https://github.com/opscode-cookbooks/database)
* [git](https://github.com/opscode-cookbooks/git)
* [java](https://github.com/opscode-cookbooks/java)
* [mysql](https://github.com/opscode-cookbooks/mysql)
* [cron](http://github.com/opscode-cookbooks/cron)

Third-Party Cookbooks

* [mysql_connector](https://github.com/bflad/chef-mysql_connector) (if using MySQL database)
* [backup](https://github.com/damm/backup) (if using backup)

## Bamboo attributes

These attributes are under the `node['bamboo']` namespace.

Attribute | Description | Type | Default
----------|-------------|------|--------
url | Url for your bamboo installation | String | http://localhost
home_dir | Bamboo install directory | String | /opt/bamboo
data_dir | Bamboo data directory | String | /var/bamboo
user | user to run Bamboo | String | bamboo
group | group for user bamboo | String | bamboo
user_home | home dir for user bamboo | String | /home/bamboo
version | Bamboo version to install | String | 5.3
download_url | URL for Bamboo install | String | auto-detected (see attributes/default.rb)
checksum | SHA256 checksum for Bamboo install | String | auto-detected (see attributes/default.rb)

## Bamboo agent attributes

These attributes are under the `node['bamboo']['agent']` namespace. Agents attributes can be different than the server attributes.

Attribute | Description | Type | Default
----------|-------------|------|--------
home_dir | Bamboo install directory | String | /opt/bamboo
data_dir | Bamboo data directory | String | /var/bamboo
user | user to run Bamboo | String | bamboo
group | group for user bamboo | String | bamboo
user_home | home dir for user bamboo | String | /home/bamboo
ping_timeout | timeout until wrapper restarts unresponsive JVM | Integer | 30
disable_agent_auto_capability_detection | sets the flag on the agent | String | true
additional_path | will be added to the $PATH of the agent process | String |

These attributes are under the `node['bamboo']['agent']['monit']` namespace.

Attribute | Description | Type | Default
----------|-------------|------|--------
template_cookbook | cookbook loc of monitrc template | String | bamboo
template_source | template file name for monitrc | String | procfile.monitrc.erb


These attributes are under the `node['bamboo']['agent']['wrapper']` namespace.

Attribute | Description | Type | Default
----------|-------------|------|--------
java_additionals | additional java args | Array |


### Bamboo Apache2 Attributes
Apache2 is used default as reverse proxy
These attributes are under the `node['bamboo']['apache']` namespace.

Attribute | Description | Type | Default
----------|-------------|------|--------
access_log | acces log location | String | ''
error_log | error log location | String | ''
port | port | Integer | 80
template_cookbook | from which cookbook to take the template | String | bamboo
virtual_host_name | vhost  | String | ''
virtual_host_alias | vhost alias | String | ''
error_docs | custom error docs | String | ''

#### Bamboo Apache2 SSL
These attributes are under the `node['bamboo']['apache']['ssl']` namespace.
access_log | ssl access log | String | ''
error_log | ssl access log | String | ''
chain_file | chain file  | String | ''
port | port  | Integer | 443
certificate_file | cert file to use | String | localhost.crt for rhel, ssl-cert-snakeoil.pem for ubuntu
key_file | key file to use | String | localhost.key for rhel, ssl-cert-snakeoil.key for ubuntu

### Bamboo Database Attributes

These attributes are under the `node['bamboo']['database']` namespace.

Attribute | Description | Type | Default
----------|-------------|------|--------
type | Bamboo database type | String | mysql (no other database supported atm)
host | FQDN or "127.0.0.1" (localhost automatically installs `['database']['type']` server) | String | localhost
name | Bamboo database name | String | Bamboo
password | Bamboo database user password | String | changeit
port | Bamboo database port | Fixnum | 3306 for MySQL, 5432 for PostgreSQL
type | Bamboo database type eg postgresql or mysql | String | postgresql
user | Bamboo database user | String | Bamboo

### Bamboo JVM Attributes

These attributes are under the `node['bamboo']['jvm']` namespace.

Attribute | Description | Type | Default
----------|-------------|------|--------
minimum_memory | JVM minimum memory | String | 512m
maximum_memory | JVM maximum memory | String | 2G
support_args | additional JAVA_OPTS recommended by Atlassian support for Bamboo JVM during startup | String | ""

### Bamboo Crowd Attributes

These attributes are under the `node['bamboo']['crowd']` namespace.
For initial setup first run without crowd enabled, run the setup process and activate crowd via the webui

Attribute | Description | Type | Default
----------|-------------|------|--------
enabled | enables crowd sso | Boolean | false

### Bamboo Error Docs Attributes
Attribute | Description | Type | Default
----------|-------------|------|--------
error_docs| Provide custom error docs | Array | e503 - empty


### Bamboo Backup Attributes

These attributes are under the `node['bamboo']['backup']` namespace.

Attribute | Description | Type | Default
----------|-------------|------|--------
enabled | Enable backup to s3 True/False yes/no | String | false
ceph | Enable if you use ceph True/False yes/no | String | false
s3_host | your bucket in S3 | String | s3.amazonaws.com
s3_scheme | your bucket in S3 | String | http
s3_port | your bucket in S3 | String | 80
s3_access_key_id | Your acces key for S3 | String | changeit
s3_secret_access_key | Your secret key for S3  | String | changeit
s3_bucket | your bucket in S3 | String | bamboo

### Code Deployment From Bamboo

## Testing and Development

Here's how you can quickly get testing or developing against the cookbook thanks to [Test-Kitchen](http://kitchen.ci) and [Berkshelf](http://berkshelf.com/).

    git clone git://github.com/ramonskie/bamboo.git
    cd bamboo
    see [TESTING.md](TESTING.md)



The running Bamboo server is accessible from the host machine:

You can then SSH into the running VM using the `vagrant ssh` command.

The VM can easily be stopped and deleted with the `vagrant destroy` command. Please see the official [Vagrant documentation](http://docs.vagrantup.com/v2/cli/index.html) for a more in depth explanation of available commands.

### Test Kitchen

Please see documentation in: [TESTING.md](TESTING.md)

## Contributing

Please use standard Github issues/pull requests and if possible, in combination with testing on the Vagrant boxes.

## License and Contributors

Please see license information in: [LICENSE](LICENSE)

* ramonskie (ramonmakkelie@gmail.com)
* soudmaijer (soudmaijer@gmail.com)
* mvdkleijn (martijn.niji@gmail.com)
