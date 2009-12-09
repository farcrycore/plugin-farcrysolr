<cfsetting enablecfoutputonly="true" />
<!----------------------------------------
ENVIRONMENT
----------------------------------------->
<cfparam name="url.module" type="string" />

<cfoutput>
<a href="##" onclick="selectObjectID('#stobj.objectid#');btnSubmit('#Request.farcryForm.Name#','create');" title="Create Collection">C</a>
<a href="##" onclick="selectObjectID('#stobj.objectid#');btnSubmit('#Request.farcryForm.Name#','deleteCollection');" title="Delete Collection">D</a>
<a href="##" onclick="selectObjectID('#stobj.objectid#');btnSubmit('#Request.farcryForm.Name#','purge');" title="Purge Collection">P</a>
</cfoutput>

<cfsetting enablecfoutputonly="false" />