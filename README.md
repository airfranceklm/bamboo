# Bamboo status [![Build Status](https://travis-ci.org/ramonskie/bamboo.png?branch=master)](https://travis-ci.org/ramonskie/bamboo)

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
* recipe "bamboo::agent", "Installs a bamboo agent."

## Requirements

### Platforms

* Ubuntu 12.04, 12.10, 13.04

### Databases

* MySQL

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

These attributes are under the `node[:bamboo]` namespace.

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

These attributes are under the `node[:bamboo][:agent]` namespace. Agents attributes can be different than the server attributes.

Attribute | Description | Type | Default
----------|-------------|------|--------
home_dir | Bamboo install directory | String | /opt/bamboo
data_dir | Bamboo data directory | String | /var/bamboo
user | user to run Bamboo | String | bamboo
group | group for user bamboo | String | bamboo
user_home | home dir for user bamboo | String | /home/bamboo
disable_agent_auto_capability_detection | sets the flag on the agent | String | true
additional_path | will be added to the $PATH of the agent process | String |

### Bamboo Database Attributes

These attributes are under the `node[:bamboo][:database]` namespace.

Attribute | Description | Type | Default
----------|-------------|------|--------
type | Bamboo database type | String | mysql (no other database supported atm)
host | FQDN or "localhost" (localhost automatically installs `['database']['type']` server) | String | localhost
name | Bamboo database name | String | Bamboo
password | Bamboo database user password | String | changeit
port | Bamboo database port | Fixnum | 3306
type | Bamboo database type - "mysql" | String | mysql
user | Bamboo database user | String | Bamboo

### Bamboo JVM Attributes

These attributes are under the `node[:bamboo][:jvm]` namespace.

Attribute | Description | Type | Default
----------|-------------|------|--------
minimum_memory | JVM minimum memory | String | 512m
maximum_memory | JVM maximum memory | String | 2048m
maximum_permgen | JVM maximum PermGen memory | String | 256m
support_args | additional JAVA_OPTS recommended by Atlassian support for Bamboo JVM during startup | String | ""

### Bamboo Graylog Attributes

These attributes are under the `node[:bamboo][:graylog]` namespace.

Attribute | Description | Type | Default
----------|-------------|------|--------
enabled | Enable graylog True/Falseyes/no | String | false
facility | The facility name in graylog | string | bamboo
host | Hostname of the graylog server | string | graylog.yourdomain.com
origin | origin of the host | string | auto-detected (see attributes/default.rb)

### Bamboo Graylog Attributes

These attributes are under the `node[:bamboo][:graylog]` namespace.

Attribute | Description | Type | Default
----------|-------------|------|--------
error_docs| Provide custom error docs | Array | e503 - empty


### Bamboo Backup Attributes

These attributes are under the `node[:bamboo][:backup]` namespace.

Attribute | Description | Type | Default
----------|-------------|------|--------
enabled | Enable backup to s3 True/False yes/no | String | false
s3_host | your bucket in S3 | String | s3.amazonaws.com
s3_scheme | your bucket in S3 | String | http
s3_port | your bucket in S3 | String | 80
s3_access_key_id | Your acces key for S3 | String | changeit
s3_secret_access_key | Your secret key for S3  | String | changeit
s3_bucket | your bucket in S3 | String | bamboo

### Code Deployment From Bamboo

## Testing and Development

Here's how you can quickly get testing or developing against the cookbook thanks to [Vagrant](http://vagrantup.com/) and [Berkshelf](http://berkshelf.com/).

    git clone git://github.com/ramonskie/chef-bamboo.git
    cd chef-bamboo
    vagrant plugin install vagrant-berkshelf
    vagrant plugin install vagrant-cachier
    vagrant plugin install vagrant-omnibus
    vagrant up

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
