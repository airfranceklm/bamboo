# Bamboo Cookbook Changelog

This file is used to list changes made in each version of the bamboo cookbook.

## v2.0.8 (July 10, 2017)

Improvements:
- Add versions 5.15.7, 6.0.0, 6.0.1, 6.0.2
- Pin chef omnibus
- Update .gitignore

## v2.0.7 (May 10, 2017)

Fixes:
- Error when data_dir does not exist
- Misc issues with Kitchen tests (please maintain them)

Improvements:
- Add version 5.15.3, 5.15.5
- Remove Kitchen tests for Unbuntu 12.04 since EOL is April 2017
- Use CentOS 6.8 for Kitchen tests

## v2.0.6 (January 13, 2017)

Improvements:
- Unlimited wrapper java additionals config via attributes
- Add version 5.14.4.1

## v2.0.5 (January 10, 2017)

Fixes:
- Make sure additional_path is in PATH for systemd and initd systems

## v2.0.4 (January 10, 2017)

Fixes:
- Make sure additional_path is in PATH via systemd unit file

## v2.0.3 (January 4, 2017)

Improvements:
- Make bamboo agent monitrc cookbook loc and template configurable via attributes

## v2.0.2 (December 20, 2016)

Fixes:
- Pin apache 3.2.1 due to issue 422 in 3.2.2

## v2.0.1 (December 20, 2016)

Fixes:
- Crowd can be configured within the ui, only sso enable disable as was before
- Fix pid file loc
- Update readme

## v2.0.0 (December 15, 2016)

BACKWARDS INCOMPATIBILITIES:
- Drop support of ubuntu < 14.04 LTS
- Only support https
- Only support jdk8 (Atlassian Bamboo requirement) removed permgem option
- Drop graylog support (if needed implement it via a wrapper cookbook)

Improvements:
- Support of systemd for Bamboo server and agent
- Update .gitignore
- Rubocop fixes
- Introducing helpers
- Use monit cookbook instead of package
- Full crowd sso configuration
- Fix ssl issue with openjdk on ubuntu 14.04 LTS
- Select mysql 5.6 as minimum (Atlassian Bamboo requirement)
- Introduce this Changelog
- Change attribute style
- Consistancy in templates
