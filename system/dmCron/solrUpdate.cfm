<!--- @@displayname: Update solr Collections --->
<cfsetting enablecfoutputonly="true">

<cfquery datasource="#application.dsn#" name="qCollections">
	select	*
	from	farsolrCollection
	where	hostname = '#lcase(application.sysinfo.machinename)#'
</cfquery>

<cfset osolr=createobject("component", "farcry.plugins.farcrysolr.packages.custom.solrService").init() />
<cfloop query="qCollections">
	<cfset stConfig=createobject("component", "farcry.plugins.farcrysolr.packages.types.farsolrCollection").getData(objectid=qCollections.objectid[currentrow]) />
	<cfset stresult=osolr.update(config=stconfig) />
	<cfoutput>
		#stResult.message#<br/>
	</cfoutput>
</cfloop>

<cfsetting enablecfoutputonly="false">