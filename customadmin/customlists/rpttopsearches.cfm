<cfimport taglib="/farcry/core/tags/admin" prefix="admin" />
<cfimport taglib="/farcry/core/tags/formtools" prefix="ft" />

<!----------------------------------------
ENVIRONMENT
----------------------------------------->
<cfparam name="form.daterangefrom" default="#createDate(year(now()), month(now())-1, day(now()))#" type="date" />

<!----------------------------------------
ACTION
----------------------------------------->
<cfquery datasource="#application.dsn#" name="qTopSearches" maxrows="25">
	SELECT criteria, count(distinct objectid) as topsearches, lcollections
	FROM #application.dbowner#farsolrLog
	WHERE datetimecreated > <cfqueryparam cfsqltype="cf_sql_date" value="#form.daterangefrom#" />
	GROUP By criteria, lcollections
	ORDER BY topsearches DESC
</cfquery>


<!----------------------------------------
VIEW
----------------------------------------->
<!--- set up page header --->
<admin:header title="Report: Top Searches" />

<cfoutput>
	<h2>Report: Top Searches</h2>
	<p>Not quite baked yet.</p>
</cfoutput>

<cfdump var="#qTopSearches#">

<!--- setup footer --->
<admin:footer />