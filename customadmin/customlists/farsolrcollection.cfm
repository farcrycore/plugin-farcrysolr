<cfimport taglib="/farcry/core/tags/admin" prefix="admin" />
<cfimport taglib="/farcry/core/tags/formtools" prefix="ft" />

<!----------------------------------------
ENVIRONMENT
----------------------------------------->
<cfscript>
	// apply custom cell renderers
	aCustomColumns = arrayNew(1);
	sttmp = structNew();
	sttmp.webskin = "cellCollectionUpdate.cfm"; // located in the webskin of the type the controller is listing on
	sttmp.title = "Update"; 
	sttmp.sortable = false; //optional
	arrayAppend(aCustomColumns, sttmp);
	sttmp = structNew();
	sttmp.webskin = "cellCollectionMaintenance.cfm"; // located in the webskin of the type the controller is listing on
	sttmp.title = "Maintenance"; 
	sttmp.sortable = false; //optional
	// sttmp.property = ""; //mandatory is sortable=true
	arrayAppend(aCustomColumns, sttmp);
</cfscript>

<!----------------------------------------
ACTION
----------------------------------------->
<ft:processForm action="create">
	<cfset osolr=createobject("component", "farcry.plugins.farcrysolr.packages.custom.solrService").init() />
	<cfset stConfig=createobject("component", "farcry.plugins.farcrysolr.packages.types.farsolrCollection").getData(objectid=form.selectedobjectid) />
	<cfset stresult=osolr.createCollection(collection=stconfig.collectionname) />
	<cfdump var="#stResult.message#" />
</ft:processForm>

<ft:processForm action="deleteCollection" >
	<cfset oConfig=createobject("component", "farcry.plugins.farcrysolr.packages.types.farsolrCollection") />
	<cfloop list="#form.selectedobjectid#" index="id">
		<cfset stresult=oConfig.delete(objectid=id) />
		<cfdump var="#stResult.message#" />
	</cfloop>
</ft:processForm>

<ft:processForm action="optimize" >
	<cfset osolr=createobject("component", "farcry.plugins.farcrysolr.packages.custom.solrService").init() />
	<cfset stConfig=createobject("component", "farcry.plugins.farcrysolr.packages.types.farsolrCollection").getData(objectid=form.selectedobjectid) />
	<cfset stresult=osolr.optimizeCollection(collection=stconfig.collectionname) />
	<cfdump var="#stResult.message#" />
</ft:processForm>

<ft:processForm action="update" >
	<cfset osolr=createobject("component", "farcry.plugins.farcrysolr.packages.custom.solrService").init() />
	<cfset stConfig=createobject("component", "farcry.plugins.farcrysolr.packages.types.farsolrCollection").getData(objectid=form.selectedobjectid) />
	<cfset stresult=osolr.update(config=stconfig) />
	<cfdump var="#stResult.message#" />
</ft:processForm>

<ft:processForm action="purge" >
	<cfset osolr=createobject("component", "farcry.plugins.farcrysolr.packages.custom.solrService").init() />
	<cfset stConfig=createobject("component", "farcry.plugins.farcrysolr.packages.types.farsolrCollection").getData(objectid=form.selectedobjectid) />
	<cfset stresult=osolr.purge(collection=stconfig.collectionname) />
	<cfdump var="#stResult.message#" />
</ft:processForm>

<!----------------------------------------
VIEW
----------------------------------------->
<!--- set up page header --->
<admin:header title="solr Collections" />

<ft:objectadmin 
	typename="farsolrCollection"
	permissionset="news"
	title="solr Collections"
	columnList="title,collectionName,hostname,builttodate,lIndexProperties,benablesearch,collectiontype"
	aCustomColumns="#aCustomColumns#"
	sortableColumns="title,collectiontypename,builttodate"
	lFilterFields="title"
	sqlorderby="datetimelastupdated desc"
	sqlwhere="hostname = '#lcase(application.sysinfo.machinename)#'"
	plugin="farcrysolr"
	module="customlists/farsolrcollection.cfm"
	bFlowCol="false"
	bViewCol="false"
	<!--- lCustomActions="duplicate:Duplicate,remove:Remove Me" ---> />

<!--- setup footer --->
<admin:footer />