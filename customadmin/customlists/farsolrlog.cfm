<cfimport taglib="/farcry/core/tags/admin" prefix="admin" />
<cfimport taglib="/farcry/core/tags/formtools" prefix="ft" />

<!----------------------------------------
ENVIRONMENT
----------------------------------------->


<!----------------------------------------
ACTION
----------------------------------------->



<!----------------------------------------
VIEW
----------------------------------------->
<!--- set up page header --->
<admin:header title="solr Search Log" />

<ft:objectadmin 
	typename="farsolrLog"
	permissionset="news"
	title="solr Search Log"
	columnList="criteria,lcollections,results,datetimecreated"
	sortableColumns="criteria,lcollections,results,datetimecreated"
	lFilterFields="criteria,lcollections"
	sqlorderby="datetimecreated desc"
	plugin="farcrysolr"
	module="customlists/farsolrcollection.cfm"
	bFlowCol="false"
	bViewCol="false" />

<!--- setup footer --->
<admin:footer />