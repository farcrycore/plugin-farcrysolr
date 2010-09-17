<cfsetting enablecfoutputonly="true" />
<!--- @@Copyright: Daemon Pty Limited 2002-2009, http://www.daemon.com.au --->
<!--- @@License:
    This file is part of FarCry.

    FarCry is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    FarCry is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with FarCry.  If not, see <http://www.gnu.org/licenses/>.
--->

<!------------------------------------------------------------------------
 THIS FILE ONLY GETS RUN ON THE INITIALISATION OF THE PROJECT
 - note runs AFTER ./project/config/_serverSpecifcVars.cfm
 ------------------------------------------------------------------------>
<cfset pluginLoaded=true />

<!--- set up plugin config --->
<cfif NOT structkeyExists(application.stplugins, "farcrysolr")>
	<cfset application.stplugins.farcrysolr = structNew() />
</cfif>

<!--- set up solr service --->
<cfif NOT structkeyExists(application.stplugins.farcrysolr, "oSolrConfig")>
	<cftry>
		<cfset application.stplugins.farcrysolr.oSolrConfig=createobject("component", "farcry.plugins.farcrysolr.packages.custom.solrConfig").init() />
		<cfcatch type="any">
			<!--- warn that plugin is not installed.. but don't blow up --->
			<cftrace type="warning" text="Problem initialising farcrysolr plugin. Confirm types have been deployed." />
			<cfset application.coapi.COAPIUTILITIES.unloadPlugin("farcrysolr") />
			<cfset pluginLoaded=false />
		</cfcatch>
	</cftry>
</cfif>

<!--- continue only if plugin config correct --->
<cfif pluginLoaded>
	
	<!--- set supported hosts --->
	<cfif NOT structkeyExists(application.stplugins.farcrysolr, "lhosts")>
		<!--- set default host --->
		<cfset application.stplugins.farcrysolr.lhosts = createObject("java", "java.net.InetAddress").localhost.getHostName() />
	</cfif>
	
</cfif>
<cfsetting enablecfoutputonly="false" />