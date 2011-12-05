<cfimport taglib="/farcry/core/tags/admin" prefix="admin" />
<cfimport taglib="/farcry/core/tags/formtools" prefix="ft" />
<cfimport taglib="/farcry/core/tags/webskin" prefix="skin">
<cfimport taglib="/farcry/plugins/farcrysolr/tags/" prefix="solr" /> 

<!--- set up page header --->
<admin:header title="Test Search" />

<cfoutput><h1>Search</h1></cfoutput>
<skin:view typename="farsolrSearch" key="searchForm" webskin="displaySearch"  />

<!--- setup footer --->
<admin:footer />