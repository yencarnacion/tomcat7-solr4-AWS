#
# Cookbook Name:: tomcat7-solr4
# Recipe:: default
#
# Copyright 2013, Yamir Encarnación <yencarnacion@webninjapr.com>
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

case node[:platform]
when "debian", "ubuntu"
    package "tomcat7" do
        action :install
    end

	src_filename = "solr-#{node[:solr][:version]}.tgz"
	src_filepath = "#{Chef::Config['file_cache_path']}/#{src_filename}"
	#extract_path = "#{Chef::Config['file_cache_path']}/#{node[:solr][:checksum]}"
    extract_path = "#{Chef::Config['file_cache_path']}/extractDir"


	remote_file src_filepath do
	  source "#{node[:solr][:url]}/#{node[:solr][:version]}/#{src_filename}"
	  #checksum "#{node[:solr][:url]}/#{node[:solr][:version]}/#{src_filename}.sha1"
	  owner 'root'
	  group 'root'
	  mode 00644
	end

        # configuring tomcat
    template "#{node[:tomcat][:config_dir]}/Catalina/localhost/solr.xml" do
        source "tomcat_solr.xml.erb"
        owner "root"
        group "tomcat7"
        mode "0664"
    end

	 # creating solr home, bin, data, and solr core
	 directory "#{node[:solr][:home]}/bin" do
        owner "root"
        group "tomcat7"
        mode "775"
        action :create
        recursive true
    end

        # configuring solr
    template "#{node[:solr][:home]}/solr.xml" do
        source "solr.xml.erb"
        owner "root"
        group "root"
        mode "0664" 
    end

    directory "#{node[:solr][:home]}/#{node[:solr][:core_name]}" do
        owner "root"
        group "tomcat7"
        mode "0775"
        action :create
        recursive true
    end

    directory "#{node[:solr][:home]}/#{node[:solr][:core_name]}/conf" do
        owner "root"
        group "tomcat7"
        mode "0755"
        action :create
    end

    directory "#{node[:solr][:home]}/#{node[:solr][:core_name]}/conf/lang" do
        owner "root"
        group "tomcat7"
        mode "0755"
        action :create
    end

#    directory "#{node[:solr][:home]}/#{node[:solr][:core_name]}/data" do
#        owner "root"
#        group "tomcat7"
#        mode "0775"
#        action :create
#        recursive true
#    end

    template "#{node[:solr][:home]}/#{node[:solr][:core_name]}/conf/solrconfig.xml" do
        source "solrconfig.xml.erb"
        owner "root"
        group "root"
        mode "0644"
    end

	template "#{node[:solr][:home]}/#{node[:solr][:core_name]}/conf/schema.xml" do
        source "schema.xml.erb"
        owner "root"
        group "root"
        mode "0644"
    end

    cookbook_file "#{node[:solr][:home]}/#{node[:solr][:core_name]}/conf/elevate.xml" do
        source "elevate.xml"
        owner "root"
        group "root"
        mode "0644"
        #      notifies :restart, resources(:service => "tomcat7") 
    end

    cookbook_file "#{node[:solr][:home]}/#{node[:solr][:core_name]}/conf/stopwords.txt" do
        source "stopwords.txt"
        owner "root"
        group "root"
        mode "0644"
        #      notifies :restart, resources(:service => "tomcat7") 
    end

    cookbook_file "#{node[:solr][:home]}/#{node[:solr][:core_name]}/conf/synonyms.txt" do
        source "synonyms.txt"
        owner "root"
        group "root"
        mode "0644"
        #      notifies :restart, resources(:service => "tomcat7") 
    end

    cookbook_file "#{node[:solr][:home]}/#{node[:solr][:core_name]}/conf/lang/stopwords_es.txt" do
        source "stopwords_es.txt"
        owner "root"
        group "root"
        mode "0644"
        #      notifies :restart, resources(:service => "tomcat7") 
    end

    bash 'extract_module' do
      cwd ::File.dirname(src_filepath)
      code <<-EOH
        mkdir -p #{extract_path}
        tar xzf #{src_filename} -C #{extract_path}
        cp #{extract_path}/solr-#{node[:solr][:version]}/example/lib/ext/* /usr/share/tomcat7/lib
        cp #{extract_path}/solr-#{node[:solr][:version]}/example/resources$/log4j.properties /usr/share/tomcat7/lib
        cp #{extract_path}/solr-#{node[:solr][:version]}/example/webapps/solr.war #{node[:solr][:home]}/bin/solr.war
        EOH
      not_if { ::File.exists?(extract_path) }
    end

    template "#{node[:tomcat][:config_dir]}/server.xml" do
        source "server.xml.erb"
        owner "root"
        group "root"
        mode "0644"
    end

    service "tomcat7" do
      action :restart # see actions section below
    end
end
