
## Description

Installs/Configures [Atlassian Bamboo](https://www.atlassian.com/software/Bamboo/)

## Requirements

### Platforms

* Ubuntu 12.04, 12.10, 13.04

### Databases

* MySQL


### Cookbooks

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
* [backup](https://github.com/ramonskie/backup) (if using backup)

## Attributes

These attributes are under the `node['bamboo']` namespace.

Attribute | Description | Type | Default
----------|-------------|------|--------
checksum | SHA256 checksum for Bamboo install | String | auto-detected (see attributes/default.rb)
home_path | home data directory for Bamboo user | String | /home/bamboo
install_path | location to install Bamboo | String | /opt/bamboo
download_url | URL for Bamboo install | String | auto-detected (see attributes/default.rb)
user | user to run Bamboo | String | bamboo
version | Bamboo version to install | String | 5.3


### Bamboo Database Attributes

These attributes are under the `node['bamboo']['database']` namespace.

Attribute | Description | Type | Default
----------|-------------|------|--------
host | FQDN or "localhost" (localhost automatically installs `['database']['type']` server) | String | localhost
name | Bamboo database name | String | Bamboo
password | Bamboo database user password | String | changeit
port | Bamboo database port | Fixnum | 3306
type | Bamboo database type - "mysql" | String | mysql
user | Bamboo database user | String | Bamboo

### Bamboo JVM Attributes

These attributes are under the `node['bamboo']['jvm']` namespace.

Attribute | Description | Type | Default
----------|-------------|------|--------
minimum_memory | JVM minimum memory | String | 512m
maximum_memory | JVM maximum memory | String | 2048m
maximum_permgen | JVM maximum PermGen memory | String | 256m
support_args | additional JAVA_OPTS recommended by Atlassian support for Bamboo JVM during startup | String | ""

### Bamboo Tomcat Attributes

These attributes are under the `node['bamboo']['tomcat']` namespace.

Any `node['Bamboo']['tomcat']['key*']` attributes are overridden by `Bamboo/Bamboo` encrypted data bag (Hosted Chef) or data bag (Chef Solo), if it exists

Attribute | Description | Type | Default
----------|-------------|------|--------
keyAlias | Tomcat SSL keystore alias | String | tomcat
keystoreFile | Tomcat SSL keystore file - will automatically generate self-signed keystore file if left as default | String | `#{node['Bamboo']['home_path']}/.keystore`
keystorePass | Tomcat SSL keystore passphrase | String | changeit
port | Tomcat HTTP port | Fixnum | 8085
ssl_port | Tomcat HTTPS port | Fixnum | 8443

### Bamboo Graylog Attributes

These attributes are under the `node['bamboo']['graylog']` namespace.

Attribute | Description | Type | Default
----------|-------------|------|--------
enabled | Enable graylog True/Falseyes/no | String | True
facility | The facility name in graylog | string | bamboo
host | Hostname of the graylog server | string | graylog.yourdomian.com
origin | origin of the host | string | auto-detected (see attributes/default.rb)

### Bamboo Backup Attributes

These attributes are under the `node['bamboo']['backup']` namespace.

Attribute | Description | Type | Default
----------|-------------|------|--------
enabled | Enable graylog True/Falseyes/no | String | True
s3_access_key_id | Your acces key for S3 | String | changeit
s3_secret_access_key | Your secret key for S3  | String | changeit
s3_bucket | your bucket in S3 | String | bamboo


## Recipes

* recipe "bamboo::default", "Installs the bamboo server with optional backup in place and logging to graylog."
* recipe "bamboo::server", "Only installs the bamboo server."
* recipe "bamboo::agent", "Installs a bamboo agent."

## Usage


### Bamboo Server Default Installation

* Add `recipe[bamboo]` to your node's run list.


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

* @ramonskie
