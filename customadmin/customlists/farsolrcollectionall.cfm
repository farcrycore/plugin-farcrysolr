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
<admin:header title="solr Collections" />

<ft:objectadmin 
	typename="farSolrCollection"
	permissionset="news"
	title="solr Collections: All Hosts"
	columnList="title,collectiontypename,hostname,builttodate,lIndexProperties,benablesearch,collectiontype"
	sortableColumns="title,collectiontypename,hostname,builttodate"
	lFilterFields="title,hostname"
	sqlorderby="datetimelastupdated desc"
	plugin="farcrysolr"
	module="customlists/farsolrcollectionall.cfm"
	bFlowCol="false"
	bViewCol="false" />

<!--- setup footer --->
<admin:footer />