<!--- @@displayname: Update solr Collections --->
<cfsetting enablecfoutputonly="true">

<cfquery datasource="#application.dsn#" name="qCollections">
	select	*
	from	farsolrCollection
	where	hostname = '#lcase(application.sysinfo.machinename)#'
</cfquery>

<cfset osolr=application.stplugins.farcrysolr.oSolrService />
<cfloop query="qCollections">
	<cfset stConfig=application.fapi.getContentType("farsolrCollection").getData(objectid=qCollections.objectid[currentrow]) />
	<cfset stresult=osolr.update(config=stconfig) />
	<cfoutput>
		#stResult.message#<br/>
	</cfoutput>
</cfloop>

<cfsetting enablecfoutputonly="false">