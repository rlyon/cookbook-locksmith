#
# Cookbook Name:: locksmith
# Recipe:: default
#
# Copyright 2012, Rob Lyon
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

include_recipe "yum-epel"

package "ruby-shadow" do
  action :install
end

node['locksmith']['users'].each do |username|
  if node['etc']['passwd'].include?(username)
    user_info = node['etc']['passwd'][username]
    user_keys = data_bag_item('locksmith', username)['keys']
    password_hash = data_bag_item('locksmith', username)['password'] || false

    user username do
      password password_hash
    end

    directory "#{user_info['dir']}/.ssh" do
      mode 0700
      owner user_info['uid']
      group user_info['gid']
    end

    template "#{user_info['dir']}/.ssh/authorized_keys" do
      source "authorized_keys.erb"
      mode 0400
      owner user_info['uid']
      group user_info['gid']
      variables({:keys => user_keys})
    end
  else
    log("[locksmith] User does not exist: #{username}") { level :warn }
  end
end