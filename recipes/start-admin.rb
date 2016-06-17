#
# Cookbook Name:: oracle-weblogic-lifecycle
# Recipe:: start-admin
#
# Copyright (c) 2016 Shinya Yanagihara, All Rights Reserved.

# log  "####{cookbook_name}::#{recipe_name} #{Time.now.inspect}: Starting execution phase"
puts "####{cookbook_name}::#{recipe_name} #{Time.now.inspect}: Starting compile phase"

#############################
# Crete WLST Script file for starting AdminServer
template "#{node['weblogic-domain-lifecycle']['response_file_dir']}/start_#{node['weblogic-domain-lifecycle']['domain_name']}_AdminServer.py" do
  source "start-AdminServer.py.erb"
  owner node['weblogic-domain-lifecycle']['owner']
  group node['weblogic-domain-lifecycle']['group']
  mode '0755'
end

#############################
# Run wlst and Start a WLS AdminServer
execute "wlst.sh start_#{node['weblogic-domain-lifecycle']['domain_name']}_AdminServer.py" do
  environment "CONFIG_JVM_ARGS" => "-Djava.security.egd=file:/dev/./urandom"
  command <<-EOH
    . #{node['weblogic-domain-lifecycle']['wls_home']}/server/bin/setWLSEnv.sh
    #{node['weblogic-domain-lifecycle']['oracle_common']}/common/bin/wlst.sh #{node['weblogic-domain-lifecycle']['response_file_dir']}/start_#{node['weblogic-domain-lifecycle']['domain_name']}_AdminServer.py
  EOH
  user node['weblogic-domain-lifecycle']['user']
  group node['weblogic-domain-lifecycle']['group']
  action :run
  creates "#{node['weblogic-domain-lifecycle']['domain_base']}/#{node['weblogic-domain-lifecycle']['domain_name']}/default_server.lok"
end

# log  "####{cookbook_name}::#{recipe_name} #{Time.now.inspect}: Finished execution phase"
puts "####{cookbook_name}::#{recipe_name} #{Time.now.inspect}: Finished compile phase"
