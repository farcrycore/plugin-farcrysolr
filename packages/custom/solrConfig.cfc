<cfcomponent displayname="solr Config" hint="Configuration bean for solr plugin." output="false">

	<cfproperty name="storagePath" displayname="Storage Path" hint="solr collection storage path; file path from drive." type="string" default="c:\coldfusionsolr\collections" />
	<cfproperty name="aCollections" displayname="Collections" hint="Array of active collections." type="array" />
	<cfproperty name="lCollections" displayname="Collections" hint="List of active collections." type="string" />

	<!--- pseudo constructor --->
	<cfset variables.storagePath="" />
	<cfset variables.aCollections=arrayNew(1) />
	<cfset variables.lCollections="" />
	<cfset variables.hostname=createObject("java", "java.net.InetAddress").localhost.getHostName() />

	<cffunction name="init" access="public" output="false" returntype="solrConfig">
		<cfset setCollectionArray() />
		<cfset setCollectionList() />
		<cfreturn this />
	</cffunction>

	<cffunction name="getStoragePath" access="public" output="false" returntype="string">
		<cfreturn variables.storagePath />
	</cffunction>

	<cffunction name="setStoragePath" access="public" output="false" returntype="void">
		<cfargument name="storagePath" type="string" required="true" />
		<cfset variables.storagePath = arguments.storagePath />
		<cfreturn />
	</cffunction>

	<cffunction name="getCollectionArray" access="public" output="false" returntype="array">
		<cfreturn variables.aCollections />
	</cffunction>

	<cffunction name="setCollectionArray" access="public" output="false" returntype="void">
		<cfset var qCollections=getCollections() />
		<cfset var st=structNew() />
		<cfset variables.aCollections = arrayNew(1) />
		
		<cfloop query="qCollections">
			<cfset st=structNew() />
			<cfset st.configid=qCollections.configid />
			<cfset st.title=qCollections.title />
			<cfset st.collectionname=qCollections.collectionname />
			<cfset arrayAppend(variables.aCollections, st) />
		</cfloop>
		<cfreturn />
	</cffunction>

	<cffunction name="getCollectionList" access="public" output="false" returntype="string">
		<cfreturn variables.lCollections />
	</cffunction>

	<cffunction name="setCollectionList" access="public" output="false" returntype="void">
		<cfargument name="lCollections" default="" required="false" hint="A list of collection names to manually set the collection list. If none sent, getCollections() will be used to populate the list.">
		
		<cfset var stVar = structNew() />
		
		<cfif len(arguments.lCollections)>
			<cfset variables.lCollections = arguments.lCollections />
		<cfelse>
			<cfset stVar.qCollections = getCollections() />
			<cfset variables.lCollections = valuelist(stVar.qCollections.collectionname) />
		</cfif>		
		
		<cfreturn />
	</cffunction>

	<cffunction name="getCollections" access="private" output="false" returntype="query">
		<cfset var qCollections=queryNew("configid, title, collectionname")>
		
		<cfquery datasource="#application.dsn#" name="qCollections">
		SELECT objectid AS configid, title, collectionname
		FROM farsolrCollection
		WHERE bEnableSearch = 1
		AND hostname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.hostname#" />
		AND collectionname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#application.ApplicationName#/_%" /> escape '/'
		ORDER BY title
		</cfquery>
		
		<cfreturn qCollections />
	</cffunction>
	
</cfcomponent>