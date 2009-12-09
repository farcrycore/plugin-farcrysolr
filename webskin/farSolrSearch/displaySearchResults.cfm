<cfsetting enablecfoutputonly="true">
<!--- @@Copyright: Daemon Pty Limited 1995-2007, http://www.daemon.com.au --->
<!--- @@License: Released Under the "Common Public License 1.0", http://www.opensource.org/licenses/cpl.php --->
<!--- @@displayname: Displays results found --->
<!--- @@description:   --->
<!--- @@author: Matthew Bryant (mbryant@daemon.com.au) --->


<!------------------ 
FARCRY IMPORT FILES
 ------------------>
<cfimport taglib="/farcry/core/tags/formtools" prefix="ft" />
<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />


<cfparam name="stParam.qResults" default="#queryNew('blah')#" />
<cfparam name="stParam.searchCriteria" default="" />

<!------------------ 
START WEBSKIN
 ------------------>

<!--- display search results --->
<ft:pagination 
	paginationID="#stobj.objectid#"
	qRecordSet="#stParam.qResults#"
	pageLinks="5"
	recordsPerPage="25" 
	Top="true" 
	Bottom="true"
	submissionType="form"
	renderType="inline"
	bShowPageDropdown="false"
	>

	
	<!--- Loop through the page to get all the results --->
	<ft:paginateLoop r_stObject="st" bTypeAdmin="false">		

		<skin:view 
			typename="#st.custom1#" 
			objectid="#st.objectid#" 
			webskin="displaySearchResult"
			searchCriteria="#stParam.searchCriteria#"
			rank="#st.rank#"	
			score="#st.score#"		
			title="#st.title#"	
			key="#st.key#"
			summary="#st.summary#"		
			 >

	</ft:paginateLoop>
</ft:pagination>
			
<cfsetting enablecfoutputonly="false">