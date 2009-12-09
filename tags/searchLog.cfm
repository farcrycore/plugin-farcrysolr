<cfsetting enablecfoutputonly="true" />

<!--- required attributes --->
<cfparam name="attributes.status" type="struct" />
<cfparam name="attributes.lcollections" type="string" />
<cfparam name="attributes.criteria" type="string" />
<cfparam name="attributes.type" type="string" />

<!--- optional attributes --->
<cfparam name="attributes.previouscriteria" default="" type="string" />

<!--- only run once --->
<cfif thistag.ExecutionMode eq "end">
	<cfexit method="exittag" />
</cfif>

<!--- build log properties --->
<cfscript>
stprops=structNew();
stprops.lcollections=attributes.lcollections;
stprops.type=attributes.type;
stprops.criteria=attributes.criteria;
stprops.previouscriteria=attributes.previouscriteria;
stprops.hostname=lcase(application.sysinfo.machinename);
if (structkeyexists(attributes.status, "found"))
	stprops.results=attributes.status.found;
else
	stprops.results=0;
if (structkeyexists(attributes.status, "searched"))
	stprops.searched=attributes.status.searched;
else
	stprops.searched=0;
if (structkeyexists(attributes.status, "suggestedquery"))
	stprops.suggestedquery=attributes.status.suggestedquery;
else
	stprops.suggestedquery=0;
if (structkeyexists(attributes.status, "time"))
	stprops.time=attributes.status.time;
else
	stprops.time=0;
</cfscript>

<cfset osolrLog=createObject("component", "farcry.plugins.farcrysolr.packages.types.farsolrLog") />
<cfset osolrLog.createData(stproperties=stprops, bAudit=false) />

<cfsetting enablecfoutputonly="false" />
