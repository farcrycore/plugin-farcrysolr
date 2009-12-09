<!--- 
|| LEGAL ||
$Copyright: Daemon Pty Limited 1995-2007, http://www.daemon.com.au $
$License: Released Under the "Common Public License 1.0", http://www.opensource.org/licenses/cpl.php$

|| DESCRIPTION || 
$Description: farsolrCollection Type 
Configuration object for solr Search Collections
$

|| DEVELOPER ||
$Developer: Geoff Bowers (modius@daemon.com.au) $
--->
<cfcomponent extends="farcry.core.packages.types.types" displayname="solr Collection" hint="Configuration object for solr free text search collection." bSchedule="false" bFriendly="false" bSystem="true">
<!------------------------------------------------------------------------
type properties
------------------------------------------------------------------------->	
<cfproperty ftseq="1" ftfieldset="Collection Details" name="title" type="string" hint="Collection title." required="no" default="" ftlabel="Title" ftvalidation="required" />
<cfproperty ftseq="2" ftfieldset="Collection Details" name="collectiontype" type="string" hint="Collection type." required="no" default="" fttype="list" ftrendertype="dropdown" ftlist="custom:Standard,file:File Library,cat:Category Filtered" ftlabel="Collection Type" />
<cfproperty ftseq="3" ftfieldset="Collection Details" name="collectiontypename" type="string" hint="Collection content type." required="no" default="" fttype="list" ftrendertype="dropdown" ftlistdata="getContentTypes" ftlabel="Content Type" />
<cfproperty ftseq="4" ftfieldset="Collection Details" name="collectionname" type="string" hint="solr/ColdFusion collection name." required="no" default="" ftlabel="Collection Name" ftdisplayonly="true" />
<cfproperty ftseq="5" ftfieldset="Collection Details" name="collectionpath" type="string" hint="Absolute path to the collection stem on the host." required="no" default="" ftlabel="Collection Path" ftdisplayonly="true" />
<cfproperty ftseq="6" ftfieldset="Collection Details" name="hostname" type="string" hint="Host the collection physically resides on." required="no" default="" ftlabel="Hostname" ftdisplayonly="true" />

<cfproperty ftseq="21" ftfieldset="Searchable Properties" name="indexTitle" type="string" hint="Field used to populate result title." required="no" default="" fttype="list" ftlistdata="getIndexTitles" ftlabel="Result Title" />
<cfproperty ftseq="22" ftfieldset="Searchable Properties" name="lIndexProperties" type="longchar" hint="List of property fields to be indexed in BODY. Restricted to string and longchar fields." required="no" default="" fttype="list" ftrendertype="checkbox" ftSelectMultiple="true" ftlistdata="getIndexStrings" ftlabel="Indexed Properties" />

<cfproperty ftseq="41" ftfieldset="Advanced Options" name="custom3" type="string" hint="Custom3 field hijack for a single date property; for example, publishdate." required="no" default="" fttype="list" ftlistdata="getIndexDates" ftlabel="Date Filter" />
<cfproperty ftseq="42" ftfieldset="Advanced Options" name="custom4" type="string" hint="Custom4 field hijack for a single string/longchar property; for example, lauthors." required="no" default="" fttype="list" ftlistdata="getIndexMisc" ftlabel="Miscellaneous Filter" />
<cfproperty ftseq="43" ftfieldset="Advanced Options" name="fileproperty" type="string" hint="Associated file collection will be based on this filepath property if activated." required="no" default="" fttype="list" ftlistdata="getIndexFilePaths" ftlabel="File Collection" />
<cfproperty ftseq="44" ftfieldset="Advanced Options" name="catCollection" type="string" hint="Category filter for collection." required="no" default="" fttype="category" ftalias="root" ftlabel="Category Filter" />
<cfproperty ftseq="45" ftfieldset="Advanced Options" name="contentToIndexFunction" type="string" hint="Name of the function used to return the objects to be indexed by this collection" required="no" default="contentToIndex" fttype="list" ftListData="getContentToIndexFunctionList" ftlabel="Content to Index Function" />

<cfproperty ftseq="61" ftfieldset="Operational" name="builttodate" type="date" hint="The date the collection was last built to.  Can be manually overridden to force collection to update from the specified point, based on typename datetimelastupdated." required="yes" default="{ts '1970-01-01 00:00:00'}" fttype="datetime" ftlabel="Built To date" />
<cfproperty ftseq="62" ftfieldset="Operational" name="bEnableSearch" type="boolean" hint="Enable search; by default new collections start as disabled." required="no" default="" ftlabel="Enable Search?" />

<!------------------------------------------------------------------------
object methods 

edit()
 - select typename; once selected hostname/typename/collectionname set in stone
 - edit other fields

solr maintenance methods (maybe move to solrservice.cfc)
---------------------------
createCollection(); only if hostname matches current host
deleteCollection(); only if hostname matches current host
optimiseColection(); only if hostname matches current host
optimiseAllCollections()
getCollectionList()
getCollection()

update requirements
---------------------------
beforeSave(); update hostname
afterSave(); synch with other host collections
------------------------------------------------------------------------->
<cffunction name="delete" access="public" hint="Delete associated collection and content item." returntype="struct" output="false">
	<cfargument name="objectid" required="yes" type="UUID" hint="Object ID of the object being deleted">
	<cfargument name="user" type="string" required="true" hint="Username for object creator" default="">
	<cfargument name="auditNote" type="string" required="true" hint="Note for audit trail" default="">
	<cfargument name="bDeleteCollection" type="boolean" required="false" default="true" />
	
	<cfset var stobj=getData(objectid=arguments.objectid) />
	<cfset var stReturn=structNew() />
	<cfset var osolr=createobject("component", "farcry.plugins.farcrysolr.packages.custom.solrService").init() />
	
	<cfset stReturn=super.delete(objectid=stobj.objectid, auditNote="Deleted configuration and associated collection for #stobj.collectionname#.")>
	
	<cfif stReturn.bSuccess AND arguments.bDeleteCollection>
		<cfset stReturn=osolr.deleteCollection(collection=stobj.collectionname) />
	</cfif>
	
	<cfset resetActiveCollections() />
	
	<cfreturn stReturn>
</cffunction>


<cffunction name="getContentToIndexFunctionList" access="public" hint="Returns a list of functions that are available to provide queries of objects for search services to index" returntype="string" output="false">
	<cfargument name="objectid" required="yes" type="UUID" hint="Object ID of the object being deleted">

	<cfset var stobj=getData(objectid=arguments.objectid) />
	<cfset var result = "" />
	<cfset var o = "" />
	<cfset var f = "" />
	
	
	<cfif len(stobj.collectiontypename)>
		<cfset o = createObject("component", application.stcoapi["#stobj.collectiontypename#"].packagePath) />
		<!--- ADD DEFAULT FIRST GETTING THE DISPLAY NAME --->
		<cfif structKeyExists(o, "contentToIndex")>
			<cfif structKeyExists(o['contentToIndex'].metadata, "displayName")>
				<cfset result = listAppend(result, "contentToIndex:#o['contentToIndex'].metadata.displayName#") />
			<cfelse>
				<cfset result = listAppend(result, "#application.stCoapi[stobj.collectiontypename].displayName#") />
			</cfif>
		</cfif>
		<!--- ADD OTHER OPTIONS --->
		<cfloop collection="#o#" item="f">
			<cfif left(f,14) EQ "contentToIndex" AND f NEQ "contentToIndex">
				<cfset result = listAppend(result, "#f#:#o[f].metadata.displayName#") />
			</cfif>
		</cfloop>
	</cfif>
	
	<cfreturn result>
</cffunction>

<cffunction name="resetActiveCollections" access="public" output="false" returntype="void" hint="Reset the active collection list for this host.">
	<!--- reset active collections --->
	<!--- todo: need to alert other members of lhosts to reset collections --->
	<cfset application.stplugins.farcrysolr.osolrConfig.setCollectionArray()>
	<cfset application.stplugins.farcrysolr.osolrConfig.setCollectionList()>
	<cfreturn />
</cffunction>
	
<!------------------------------------------------------------------------
formtool methods
------------------------------------------------------------------------->	
<cffunction name="ftdisplaylIndexProperties" access="public" output="false" returntype="string" hint="This will return a string of formatted HTML text to display.">
	<cfargument name="typename" required="true" type="string" hint="The name of the type that this field is part of.">
	<cfargument name="stObject" required="true" type="struct" hint="The object of the record that this field is part of.">
	<cfargument name="stMetadata" required="true" type="struct" hint="This is the metadata that is either setup as part of the type.cfc or overridden when calling ft:object by using the stMetadata argument.">
	<cfargument name="fieldname" required="true" type="string" hint="This is the name that will be used for the form field. It includes the prefix that will be used by ft:processform.">

	<cfset var html = "" />
	<cfset var i = 0 />
	
	<cfparam name="arguments.stMetadata.ftList" default="" />
	
	<!--- make upper case and put in a space for better display --->
	<cfsavecontent variable="html">
	<cfloop list="#arguments.stmetadata.value#" index="i">
		<cfif i eq listLast(arguments.stmetadata.value)>
			<cfoutput>#uCase(i)#</cfoutput>
		<cfelse>
			<cfoutput>#uCase(i)#, </cfoutput>
		</cfif>
	</cfloop>
	</cfsavecontent>
	
	<cfreturn html>
</cffunction>


<!------------------------------------------------------------------------
library methods
------------------------------------------------------------------------->	
<cffunction name="getContentTypes" access="public" hint="Get list of all searchable content types." output="false" returntype="string">
	<cfset var listdata = "" />
	<cfset var qListData = queryNew("typename,displayname") />
	
	<cfloop collection="#application.types#" item="type">
		<cfset queryAddRow(qListData) />
		<cfset querySetCell(qListData, "typename", type) />
		<cfset querySetCell(qListData, "displayname", "#application.stcoapi[type].displayname# (#type#)") />
	</cfloop>
	
	<cfquery dbtype="query" name="qListData">
	SELECT * FROM qListData
	ORDER BY typename
	</cfquery>
	
	
	<cfloop query="qListData">
		<cfset listdata = listAppend(listdata, "#qlistdata.typename#:#qlistdata.displayname#") />
	</cfloop>
	
	<cfreturn listData />
</cffunction>

<cffunction name="getIndexStrings" access="public" hint="Get list of all indexable string properties for a specific content type." output="false" returntype="string">
	<cfargument name="objectid" required="true" type="uuid" />
	
	<cfset var stobj = getData(arguments.objectid) />
	<cfset var listdata = "" />
	<cfset var qListData = getIndexProperties(stobj.collectiontypename) />
	
	<!--- filter for appropriate data types --->
	<cfquery dbtype="query" name="qListData">
	SELECT property, fttype
	FROM qListData
	WHERE datatype IN ('string','nstring','longchar')
	</cfquery>
	
	<cfloop query="qListData">
		<cfset listdata = listAppend(listdata, "#qlistdata.property#:#qlistdata.property# (#qlistdata.fttype#)") />
	</cfloop>
	
	<cfreturn listData />
</cffunction>

<cffunction name="getIndexTitles" access="public" hint="Get list of all indexable string properties (without longchar) for a specific content type." output="false" returntype="string">
	<cfargument name="objectid" required="true" type="uuid" />
	
	<cfset var stobj = getData(arguments.objectid) />
	<cfset var listdata = "" />
	<cfset var qListData = getIndexProperties(stobj.collectiontypename) />
	
	<!--- filter for appropriate data types --->
	<cfquery dbtype="query" name="qListData">
	SELECT property, fttype
	FROM qListData
	WHERE datatype IN ('string','nstring')
	</cfquery>
	
	<cfloop query="qListData">
		<cfset listdata = listAppend(listdata, "#qlistdata.property#:#qlistdata.property# (#qlistdata.fttype#)") />
	</cfloop>
	
	<cfreturn listData />
</cffunction>

<cffunction name="getIndexDates" access="public" hint="Get list of all indexable date properties for a specific content type." output="false" returntype="string">
	<cfargument name="objectid" required="true" type="uuid" />
	
	<cfset var stobj = getData(arguments.objectid) />
	<cfset var listdata = ":None specified" />
	<cfset var qListData = getIndexProperties(stobj.collectiontypename) />
	
	<!--- filter for appropriate data types --->
	<cfquery dbtype="query" name="qListData">
	SELECT property
	FROM qListData
	WHERE datatype = 'date'
	</cfquery>
	
	<cfloop query="qListData">
		<cfset listdata = listAppend(listdata, "#qlistdata.property#:#qlistdata.property#") />
	</cfloop>
	
	<cfreturn listData />
</cffunction>

<cffunction name="getIndexMisc" access="public" hint="Get list of all indexable properties for a specific content type." output="false" returntype="string">
	<cfargument name="objectid" required="true" type="uuid" />
	
	<cfset var stobj = getData(arguments.objectid) />
	<cfset var listdata = ":None specified" />
	<cfset var qListData = getIndexProperties(stobj.collectiontypename) />
	
	<!--- filter for appropriate data types --->
	<cfquery dbtype="query" name="qListData">
	SELECT property
	FROM qListData
	</cfquery>
	
	<cfloop query="qListData">
		<cfset listdata = listAppend(listdata, "#qlistdata.property#:#qlistdata.property#") />
	</cfloop>
	
	<cfreturn listData />
</cffunction>

<cffunction name="getIndexFilePaths" access="public" hint="Get list of all indexable file path properties for a specific content type." output="false" returntype="string">
	<cfargument name="objectid" required="true" type="uuid" />
	
	<cfset var stobj = getData(arguments.objectid) />
	<cfset var listdata = ":None specified" />
	<cfset var qListData = getIndexProperties(stobj.collectiontypename) />
	
	<!--- filter for appropriate data types --->
	<cfquery dbtype="query" name="qListData">
	SELECT property
	FROM qListData
	WHERE fttype = 'file'
	</cfquery>
	
	<cfloop query="qListData">
		<cfset listdata = listAppend(listdata, "#qlistdata.property#:#qlistdata.property#") />
	</cfloop>
	
	<cfreturn listData />
</cffunction>



<cffunction name="getIndexProperties" access="private" hint="Get query of all indexable properties for a specific content type." output="false" returntype="query">
	<cfargument name="typename" required="true" type="string" />
	
	<cfset var qlistdata=queryNew("property,datatype,fttype") />
	<cfset var prop="" />
	
	<cfif NOT structkeyexists(application.stcoapi, arguments.typename)>
		<cfthrow type="Application" errorcode="plugins.farcrysolr.packages.types.farsolrCollection" message="Typename (#arguments.typename#) is invalid." detail="The typename must be available in the application in order to build a collection." />
	</cfif>
	
	<cfloop collection="#application.stcoapi[arguments.typename].stProps#" item="prop">
		<cfif ListFindNoCase("string,nstring,longchar,date", application.stcoapi[arguments.typename].stProps[prop].metadata.type)>
			<cfset queryAddRow(qListData) />
			<cfset querySetCell(qListData, "property", prop) />
			<cfset querySetCell(qListData, "datatype", application.stcoapi[arguments.typename].stProps[prop].metadata.type) />
			<cfset querySetCell(qListData, "fttype", application.stcoapi[arguments.typename].stProps[prop].metadata.fttype) />
		</cfif>
	</cfloop>
	
	<!--- filter out inappropriate system attributes --->
	<cfquery dbtype="query" name="qListData">
	SELECT property, datatype, fttype
	FROM qListData
	WHERE property NOT IN ('displayMethod','status','commentlog','ownedby','createdby','lockedBy','lastupdatedby')
	ORDER BY property
	</cfquery>
	
	<cfreturn qlistdata />
</cffunction>





</cfcomponent>