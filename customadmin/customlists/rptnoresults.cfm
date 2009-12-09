<cfimport taglib="/farcry/core/tags/admin" prefix="admin" />
<cfimport taglib="/farcry/core/tags/formtools" prefix="ft" />

<!----------------------------------------
ENVIRONMENT
----------------------------------------->
<cfparam name="form.daterangefrom" default="#createDate(year(now()), month(now())-1, day(now()))#" type="date" />


<!----------------------------------------
ACTION
----------------------------------------->
<cfquery datasource="#application.dsn#" name="qNoResults" maxrows="1000">
	SELECT criteria, count(distinct objectid) as noresults
	FROM #application.dbowner#farsolrLog
	WHERE results = 0
		AND datetimecreated > <cfqueryparam cfsqltype="cf_sql_date" value="#form.daterangefrom#" />
	GROUP By criteria
	ORDER BY noresults DESC
</cfquery>


<!----------------------------------------
VIEW
----------------------------------------->
<!--- set up page header --->
<admin:header title="Report: Search With No Results" />

<cfoutput>
	<h2>Report: Search With No Results</h2>
	<p>Not quite baked yet.</p>
</cfoutput>

<cfdump var="#qNoResults#">

<!--- setup footer --->
<admin:footer />