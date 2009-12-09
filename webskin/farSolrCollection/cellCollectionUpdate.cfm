<cfsetting enablecfoutputonly="true" />
<!----------------------------------------
ENVIRONMENT
----------------------------------------->
<cfparam name="url.module" type="string" />

<cfoutput>
<a href="##" onclick="selectObjectID('#stobj.objectid#');btnSubmit('#Request.farcryForm.Name#','update');" title="Update">Update</a>
</cfoutput>

<cfsetting enablecfoutputonly="false" />