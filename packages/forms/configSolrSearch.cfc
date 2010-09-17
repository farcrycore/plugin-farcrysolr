<cfcomponent output="false" extends="farcry.core.packages.forms.forms" key="configSolrSearch" displayname="Solr Search" hint="Configures settings for the SOLR search plugin">
	
	<cfproperty ftSeq="10" ftfieldset="SOLR Search" name="pathStorage" type="nstring" ftType="string" ftLabel="Storage Path" ftHint="Path to store the SOLR collections" ftDefault="/Applications/ColdFusion9/collections" />
	
</cfcomponent>