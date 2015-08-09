#
# Cookbook Name:: bamboo
# Resource:: agent_capability
#

actions :add, :remove
default_action :add

attribute :name, kind_of: String, name_attribute: true
attribute :value, kind_of: String, required: true
