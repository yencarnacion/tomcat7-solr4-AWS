Description
===========
Configures and deploys Solr 4.3.1 on tomcat 7

Requirements
============

Platform:

Ubuntu

Attributes
==========

node['solr']['port'] - The port used by Solr server (Tomcat 7 HTTP connector). Default: 8893.    
node['solr']['home'] - Directory that will hold Solr configuration and data storage. Default: /var/opt/solr     
node['solr']['data_dir'] - Directory to hold indexes data. Default: solr_home/data.     
node['solr']['core_name'] - Name of the running Solr core

Usage
=====

