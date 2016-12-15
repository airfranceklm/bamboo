# Bamboo Cookbook Changelog

This file is used to list changes made in each version of the bamboo cookbook.

## v2.0.0 (December 14, 2016)

BACKWARDS INCOMPATIBILITIES:
- Drop support of ubuntu < 14.04 LTS
- Only support https
- Only support jdk8 (Atlassian Bamboo requirement) removed permgem option
- Drop graylog support (if needed implement it via a wrapper cookbook)

IMPROVEMENTS:
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
