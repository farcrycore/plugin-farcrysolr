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


<cfparam name="stParam.suggestLink" default="" />

<!------------------ 
START WEBSKIN
 ------------------>	
<cfif len(stParam.suggestLink)>
	<cfoutput><p>Did you mean #stParam.suggestLink#?</p></cfoutput>
</cfif>

<cfsetting enablecfoutputonly="false">