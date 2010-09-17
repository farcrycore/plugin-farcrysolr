<cfcomponent displayname="Solr Config Utility" hint="Configuration bean for solr plugin." output="false">
	
	<!--- documentation metadata; not referred to programatically --->
	<cfproperty name="aCollections" displayname="Collections" hint="Array of active collections." type="array" />
	<cfproperty name="lCollections" displayname="Collections" hint="List of active collections." type="string" />

	<!--- pseudo constructor --->
	<cfset variables.aCollections=arrayNew(1) />
	<cfset variables.lCollections="" />
	<cfset variables.hostname=createObject("java", "java.net.InetAddress").localhost.getHostName() />

	<cffunction name="init" access="public" output="false" returntype="solrConfig">
		<cfset setCollectionArray() />
		<cfset setCollectionList() />
		<cfreturn this />
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
		
		<cfset var qCollections = queryNew("init") />
		
		<cfif len(arguments.lCollections)>
			<cfset variables.lCollections = arguments.lCollections />
		<cfelse>
			<cfset qCollections = getCollections() />
			<cfset variables.lCollections = valuelist(qCollections.collectionname) />
		</cfif>		
		
		<cfreturn />
	</cffunction>

	<cffunction name="getCollections" access="private" output="true" returntype="query">
		<cfset var qCollections=queryNew("configid, title, collectionname")>
		
		<cfquery datasource="#application.dsn#" name="qCollections">
		SELECT objectid AS configid, title, collectionname
		FROM farSolrCollection
		WHERE bEnableSearch = 1
		AND lower(hostname) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(variables.hostname)#" />
		<!--- AND collectionname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#application.ApplicationName#/_%" /> escape '/' --->
		AND collectionname LIKE '#application.ApplicationName#_%'
		ORDER BY title
		</cfquery>
		
		<cfreturn qCollections />
	</cffunction>
	
</cfcomponent>