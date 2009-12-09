<cfimport taglib="/farcry/core/tags/admin" prefix="admin" />
<cfimport taglib="/farcry/core/tags/formtools" prefix="ft" />

<!----------------------------------------
ENVIRONMENT
----------------------------------------->
<cfparam name="form.action" default="none" type="string" />

<cfset qMissing=queryNew("objectid,collectionname,title,collectiontypename") />

<cfset osolr=createObject("component", "farcry.plugins.farcrysolr.packages.custom.solrService").init() />
<cfset qCollections=osolr.getCollections() />

<cfquery datasource="#application.dsn#" name="qHostConfigs">
SELECT objectid, collectionname, title, collectiontypename
FROM farsolrCollection
WHERE hostname = '#application.sysinfo.machinename#'
</cfquery>

<cfloop query="qHostConfigs">
	<cfquery dbtype="query" name="qMissingCheck">
	SELECT name
	FROM qCollections
	WHERE qCollections.name = '#qHostConfigs.collectionname#'
	</cfquery>
	
	<cfif NOT qMissingCheck.recordcount>
		<cfquery dbtype="query" name="qConfig">
		SELECT objectid, collectionname, title, collectiontypename
		FROM qHostConfigs
		WHERE collectionname = '#qMissingCheck.name#'
		</cfquery>
		
		<cfset queryAddRow(qMissing,1) />
		<cfset querySetCell(qMissing, "objectid", qHostConfigs.objectid) />
		<cfset querySetCell(qMissing, "collectionname", qHostConfigs.collectionname) />
		<cfset querySetCell(qMissing, "title", qHostConfigs.title) />
		<cfset querySetCell(qMissing, "collectiontypename", qHostConfigs.collectiontypename) />
	</cfif>
</cfloop>


<!----------------------------------------
ACTION
----------------------------------------->
<cfswitch expression="#form.action#">
	
	<cfcase value="Create solr Collections">

		<cfoutput><h3>Create solr Collections</h3></cfoutput>
		
		<cfset osolr=createobject("component", "farcry.plugins.farcrysolr.packages.custom.solrService").init() />
		<cfset ofvc=createObject("component", "farcry.plugins.farcrysolr.packages.types.farsolrCollection") />

		<cfloop query="qMissing">
			<cfset stConfig=ofvc.getData(objectid=qMissing.objectid) />
			<cfset solrResult=osolr.createCollection(collection=stConfig.collectionname) />
			<cfdump var="#solrResult#">
		</cfloop>
		<cfoutput>All Done.</cfoutput>
		<cfabort />

	</cfcase>
	
</cfswitch>

<!----------------------------------------
VIEW
----------------------------------------->
<!--- set up page header --->
<admin:header title="Host Management" />

<!--- Create Missing Collections --->
<cfform format="flash" name="createhostcollections">
	<cfformgroup type="panel" label="Create Missing Collections">
		<!--- nested tree model orphans --->
		<cfformitem type="html"><p>The following collections do not exist for this host. Create <b>ALL</b> missing 
		collections for this host by clicking the button provided.</p></cfformitem>
		
		<cfgrid query="qMissing" name="collections"  />
		
		<cfformgroup type="horizontal">
			<cfinput type="submit" name="action" value="Create solr Collections" />
		</cfformgroup>
	</cfformgroup>
</cfform>

<!--- setup footer --->
<admin:footer />



