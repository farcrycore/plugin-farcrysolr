<cfquery name="qConfigs" datasource="#application.dsn#">
SELECT * FROM farsolrCollection
ORDER BY title
</cfquery>

<cfoutput>
<h2>solr Service</h2>
<p><a href="http://daemonite.local/farcry/admin/customadmin.cfm?module=customlists/servicetest.cfm&plugin=farcrysolr">Reset All</a></p>

<h2>Collection Config</h2>
<cfloop query="qConfigs">
<h3>#qconfigs.collectionname#</h3>
<ul>
	<li><a href="#cgi.SCRIPT_NAME#?#cgi.query_string#&solraction=create&configid=#qconfigs.objectid#">Create #qConfigs.title#</a></li>
	<li><a href="#cgi.SCRIPT_NAME#?#cgi.query_string#&solraction=delete&configid=#qconfigs.objectid#">Delete #qConfigs.title#</a></li>
	<li><a href="#cgi.SCRIPT_NAME#?#cgi.query_string#&solraction=optimize&configid=#qconfigs.objectid#">Optimize #qConfigs.title#</a></li>
	<li><a href="#cgi.SCRIPT_NAME#?#cgi.query_string#&solraction=update&configid=#qconfigs.objectid#">Update #qConfigs.title#</a></li>
	<li><a href="#cgi.SCRIPT_NAME#?#cgi.query_string#&solraction=search&configid=#qconfigs.objectid#">Search #qConfigs.title#</a></li>
</ul>
</cfloop>
</cfoutput>

<cfparam name="url.solraction" default="none" type="string" />
<cfparam name="url.configid" default="#createUUID()#" type="uuid" />
<cfset osolr=createobject("component", "farcry.plugins.farcrysolr.packages.custom.solrService").init(path="C:\coldfusionsolr\collections") />
<cfset stConfig=createobject("component", "farcry.plugins.farcrysolr.packages.types.farsolrCollection").getData(objectid=url.configid) />

<cfswitch expression="#url.solraction#">
	
	<cfcase value="create">
		<cfset stresult=osolr.createCollection(collection=stconfig.collectionname) />
		<cfdump var="#stResult#" />
	</cfcase>

	<cfcase value="delete">
		<cfset stresult=osolr.deleteCollection(collection=stconfig.collectionname) />
		<cfdump var="#stResult#" />
	</cfcase>	

	<cfcase value="optimize">
		<cfset stresult=osolr.optimizeCollection(collection=stconfig.collectionname) />
		<cfdump var="#stResult#" />
	</cfcase>

	<cfcase value="update">
		<cfset stresult=osolr.update(config=stconfig) />
		<cfdump var="#stResult#" />
	</cfcase>

	<cfcase value="search">
		<cfoutput><h2>Search Results</h2></cfoutput>
		<cfsearch collection="#stconfig.collectionname#" criteria="*" name="qResults" status="stinfo" />
		<cfdump var="#qResults#">
		<cfdump var="#stInfo#">
	</cfcase>
	
</cfswitch>

