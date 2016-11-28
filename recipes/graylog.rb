#
# Cookbook Name:: bamboo
# Recipe:: graylog
# Author:: Stephan Oudmaijer
#
# Copyright 2013
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
cookbook_file "#{node[:bamboo][:home_dir]}/atlassian-bamboo/WEB-INF/lib/gelfj-1.1.12.jar" do
  source 'gelfj-1.1.12.jar'
  owner node[:bamboo][:user]
  group node[:bamboo][:group]
  mode '0775'
end

cookbook_file "#{node[:bamboo][:home_dir]}/atlassian-bamboo/WEB-INF/lib/json-simple-1.1.jar" do
  source 'json-simple-1.1.jar'
  owner node[:bamboo][:user]
  group node[:bamboo][:group]
  mode '0775'
end

# configure log4j for graylog
replace "#{node[:bamboo][:home_dir]}/atlassian-bamboo/WEB-INF/classes/log4j.properties" do
    replace "log4j.rootLogger=INFO, console, filelog"
    with    "log4j.rootLogger=INFO, console, filelog, graylog"
end

append_line "#{node[:bamboo][:home_dir]}/atlassian-bamboo/WEB-INF/classes/log4j.properties" do
    line "log4j.appender.graylog=org.graylog2.log.GelfAppender"
end

append_line "#{node[:bamboo][:home_dir]}/atlassian-bamboo/WEB-INF/classes/log4j.properties" do
    line "log4j.appender.graylog.graylogHost=#{node[:bamboo][:graylog][:host]}"
end

append_line "#{node[:bamboo][:home_dir]}/atlassian-bamboo/WEB-INF/classes/log4j.properties" do
    line "log4j.appender.graylog.originHost=#{node[:bamboo][:graylog][:origin]}"
end

append_line "#{node[:bamboo][:home_dir]}/atlassian-bamboo/WEB-INF/classes/log4j.properties" do
    line "log4j.appender.graylog.facility=#{node[:bamboo][:graylog][:facility]}"
end

append_line "#{node[:bamboo][:home_dir]}/atlassian-bamboo/WEB-INF/classes/log4j.properties" do
    line "log4j.appender.graylog.Threshold=INFO"
end

append_line "#{node[:bamboo][:home_dir]}/atlassian-bamboo/WEB-INF/classes/log4j.properties" do
    line "log4j.appender.graylog.layout=org.apache.log4j.PatternLayout"
end

append_line "#{node[:bamboo][:home_dir]}/atlassian-bamboo/WEB-INF/classes/log4j.properties" do
    line "log4j.appender.graylog.layout.ConversionPattern=%d %p [%t] [%c{1}] %m%n"
end
