#
# Cookbook Name:: discourse
# Recipe:: default
#
# Copyright (C) 2014 John Bellone (<jbellone@bloomberg.net>)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default['discourse']['artifact_location'] = "https://github.com/discourse/discourse/%{version}"
default['discourse']['artifact_version'] = '1.0.0'

default['discourse']['site_name'] = 'meta.discourse.org'
default['discourse']['site_root'] = "/srv/%{name}"
default['discourse']['site_environment'] = {}

default['discourse']['user'] = 'discourse'
default['discourse']['group'] = 'discourse'
