<cfsetting enablecfoutputonly="true" />

<!--- required libs --->
<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />


<!--- Attributes that should be passed in by the search page --->
<cfparam name="stParam.searchCriteria" default="" />
<cfparam name="stParam.rank" default="" />	
<cfparam name="stParam.score" default="" />	
<cfparam name="stParam.title" default="" />	
<cfparam name="stParam.key" default="" />	
<cfparam name="stParam.summary" default="" />				 



<!--- determine whether to use teaser or solr summary --->
<cfif structKeyExists(stObj,"teaser") AND len(trim(stObj.teaser))>
	<cfset summary = trim(stObj.teaser) />
<cfelse>
	<cfset summary = trim(stParam.summary) />
</cfif>

<!--- Initialize the Search Service --->
<cfset oSearchService=application.stplugins.farcrysolr.oSolrService />

<!--- FORMAT THE SUMMARY --->
<cfset summary = oSearchService.stripHTML(summary) />
<cfset summary = oSearchService.highlightSummary(searchCriteria="#stParam.searchCriteria#", summary="#summary#") />

<cfoutput>
<div class="search-result">
	<div class="search-title">
		<skin:buildlink objectid="#stObj.objectID#">
			<cfif len(stParam.title)>#stParam.title#<cfelse>#stObj.label#</cfif>
		</skin:buildlink>
	</div>
	<div class="search-date">
		#dateFormat(stObj.dateTimeLastUpdated, "d mmmm yyyy")#
	</div>
	<div class="search-summary">
		#summary#
		<cfif right(summary,3) EQ "...">
			<skin:buildlink objectid="#stObj.objectID#">more</skin:buildlink>
		</cfif>
	</div>
	<div class="search-footer">
		#application.stCoapi[stobj.typeName].displayName# |
		<skin:buildlink objectid="#stObj.objectID#">Go to page</skin:buildlink>
	</div>
</div>
</cfoutput>

<cfsetting enablecfoutputonly="false" />