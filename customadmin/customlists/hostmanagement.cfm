<cfimport taglib="/farcry/core/tags/admin" prefix="admin" />
<cfimport taglib="/farcry/core/tags/formtools" prefix="ft" />

<!----------------------------------------
ENVIRONMENT
----------------------------------------->
<cfparam name="form.action" default="none" type="string" />

<!----------------------------------------
ACTION
----------------------------------------->
<cfswitch expression="#form.action#">
	<cfcase value="Synchronise Collection Configs">
		<cfoutput><h3>Synchronise Collection Configs</h3></cfoutput>
		
		<cfquery datasource="#application.dsn#" name="qAllConfigs">
		SELECT objectid, hostname, collectionname
		FROM farsolrCollection
		</cfquery>
		
		<!--- <cfdump var="#qAllConfigs#" label="qAllConfigs" /> --->
		
		<cfquery dbtype="query" name="qHostConfigs">
		SELECT objectid
		FROM qAllConfigs
		WHERE lower(hostname) = '#lcase(form.host)#'
		</cfquery>
		
		<!--- <cfdump var="#qHostConfigs#" label="qHostConfigs" /> --->
		
		<cfif NOT qHostConfigs.recordcount>
			<cfoutput><p>This host has no collection configs to synchronise.</p></cfoutput>
		</cfif>
		
		<cfset ofvc=createObject("component", "farcry.plugins.farcrysolr.packages.types.farsolrCollection") />
		
		<cfloop query="qHostConfigs">
	
			<cfset stconfig=ofvc.getData(objectid=qHostConfigs.objectid) />
			
			<cfquery dbtype="query" name="qUpdateConfigs">
			SELECT objectid
			FROM qAllConfigs
			WHERE lower(collectionname) = '#lcase(stconfig.collectionname)#'
			AND lower(hostname) <> '#lcase(stconfig.hostname)#'
			</cfquery>
			
			<!--- <cfdump var="#qUpdateConfigs#" label="qUpdateConfigs: configs to be updated" /> --->
			
			<!--- Update host collection configs with the same CollectionName --->
			<cfloop query="qUpdateConfigs">
				<cfif stConfig.objectid neq qUpdateConfigs.objectid>
					<!--- get the current host config that will be updated --->
					<cfset stHostConfig=ofvc.getData(objectid=qUpdateConfigs.objectid) />
					<!--- set the update stproperties structure to equal the selected synch host --->
					<cfset stUpdate=duplicate(stConfig) />
					<!--- set immutable properties from hosts original config --->
					<cfset stUpdate.objectid=stHostConfig.objectid />
					<cfset stUpdate.hostname=stHostConfig.hostname />
					<cfset stUpdate.collectionpath=stHostConfig.collectionpath />
					<cfset stResult=ofvc.setData(stproperties=stUpdate) />
					<!--- <cfdump var="#stUpdate#" label="#stHostConfig.hostname#" /> --->
					<cfdump var="#stResult#" label="#stHostConfig.hostname#" />
				</cfif>
			</cfloop>

			<!--- add missing configs --->
			<cfloop list="#application.stplugins.farcrysolr.lhosts#" index="j">
				<!--- check to see if config for host exists; ignore selected host --->
				<cfif j neq stConfig.hostname>
					<cfquery dbtype="query" name="qCreateConfig">
					SELECT objectid
					FROM qAllConfigs
					WHERE lower(collectionname) = '#lcase(stconfig.collectionname)#'
					AND lower(hostname) <> '#lcase(form.host)#'
					AND lower(hostname) = '#lcase(j)#'
					</cfquery>
					
					<!--- <cfdump var="#qCreateConfig#" label="qCreateConfig: #j#" /> --->
					
					<!--- if not, create config for host --->
					<cfif NOT qCreateConfig.recordcount>
						<cfset stUpdate=duplicate(stConfig) />
						<!--- set immutable properties --->
						<cfset stUpdate.objectid=createUUID() />
						<cfset stUpdate.builttodate=createODBCDateTime("1970-01-01") />
						<cfset stUpdate.hostname=j />
						<cfset stUpdate.collectionpath="" />
						<cfset stUpdate.datetimecreated=now() />
						<cfset stUpdate.datetimelastupdated=now() />
						<cfset stResult=ofvc.createData(stproperties=stUpdate) />
						<!--- <cfdump var="#stUpdate#" label="#j#" /> --->
						<cfdump var="#stResult#" label="#j#" />
					</cfif>
				</cfif>
			</cfloop>
					
		</cfloop>
		
	</cfcase>
	
</cfswitch>

<!----------------------------------------
VIEW
----------------------------------------->
<!--- set up page header --->
<admin:header title="Host Management" />

<!--- Synchronise Host Configs --->
<!--- only show admin if more than one registered host; else help text --->
<cfif listlen(application.stplugins.farcrysolr.lhosts) gt 1>

	<cfform format="flash" name="synchostform" height="150">
		<cfformgroup type="panel" label="Synchronise Hosts">
			<!--- nested tree model orphans --->
			<cfformitem type="html"><p>Select a host from the list.  All other hosts will have their collection configuration changed 
	to match the selected host. <b>There is no undo.</b></p></cfformitem>
	
			<cfformgroup type="horizontal">
				<cfselect name="host" size="1">
					<cfloop list="#application.stplugins.farcrysolr.lhosts#" index="i">
						<cfif application.sysinfo.machineName eq i>
							<cfoutput><option value="#i#" selected>#i#</option></cfoutput>
						<cfelse>
							<cfoutput><option value="#i#">#i#</option></cfoutput>
						</cfif>
					</cfloop>
				</cfselect>
				<cfinput type="submit" name="action" value="Synchronise Collection Configs" />
			</cfformgroup>
		</cfformgroup>
	</cfform>

<!--- help text if only one registered host --->
<cfelse>

	<cfoutput>
	<h2>Host Management Not Applicable</h2>
	
	<p>There is only one registered host for solr management: <strong>#application.stplugins.farcrysolr.lhosts#</strong></p>
	
	<p>If you need to register additional hosts to be managed by this application you will 
		need to add the following list variable to ./projects/projectname/config/_serverSpecificVarsAfterInit.cfm</p>
		<ul>
			<li>&lt;cfset application.stplugins.farcrysolr.lhosts="hostname1,hostname2,hostname3" /&gt;</li>
		</ul>
	<p>Where "hostname" is the actual machine name of the relevant server.</p>
	</cfoutput>

</cfif>

<!--- setup footer --->
<admin:footer />
