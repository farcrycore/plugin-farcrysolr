<!--- 
|| LEGAL ||
$Copyright: Daemon Pty Limited 1995-2007, http://www.daemon.com.au $
$License: Released Under the "Common Public License 1.0", http://www.opensource.org/licenses/cpl.php$

|| DESCRIPTION || 
$Description: farsolrLog Type 
Log of solr searches.
$

|| DEVELOPER ||
$Developer: Geoff Bowers (modius@daemon.com.au) $
--->
<cfcomponent extends="farcry.core.packages.types.types" displayname="solr Search Log" hint="Log of solr searches." bSchedule="false" bFriendly="false" bSystem="true" output="false">
<!------------------------------------------------------------------------
type properties
------------------------------------------------------------------------->	
<cfproperty ftseq="1" ftfieldset="Collection Log" name="criteria" type="string" hint="Search criteria." required="no" default="" ftlabel="Criteria" blabel="true" />
<cfproperty ftseq="2" ftfieldset="Collection Log" name="lcollections" type="string" hint="Collection list searched." required="no" default="" ftlabel="Collection List" />
<cfproperty ftseq="3" ftfieldset="Collection Log" name="referrer" type="string" hint="Referring URL." required="no" default="" ftlabel="Referrer" />
<cfproperty ftseq="4" ftfieldset="Collection Log" name="remoteip" type="string" hint="Remote IP address of user." required="no" default="" ftlabel="Remote IP" />
<cfproperty ftseq="5" ftfieldset="Collection Log" name="results" type="integer" hint="Number of results returned." required="yes" default="0" ftlabel="Results" />
<cfproperty ftseq="6" ftfieldset="Collection Log" name="hostname" type="string" hint="Host the collection physically resides on." required="no" default="" ftlabel="Hostname" ftdisplayonly="true" />
<cfproperty ftseq="7" ftfieldset="Collection Log" name="searched" type="integer" hint="Number of records searched." required="no" default="" ftlabel="Searched" ftdisplayonly="true" />
<cfproperty ftseq="8" ftfieldset="Collection Log" name="suggestedquery" type="string" hint="solr suggested query string." required="no" default="" ftlabel="Suggested Query" ftdisplayonly="true" />
<cfproperty ftseq="9" ftfieldset="Collection Log" name="time" type="integer" hint="Time in miliseconds to return results." required="no" default="" ftlabel="Time" ftdisplayonly="true" />



</cfcomponent>