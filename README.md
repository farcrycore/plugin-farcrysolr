# Plugin: FarCry SOLR

> **DEPRECATED: Use FarCry SOLR Pro Instead**
> The FarCry SOLR Pro plugin http://jeffcoughlin.github.com/farcrysolrpro/ is now available under the Apache open source license and offers a wonderful range of search options that greatly exceed this plugin's capability. Well worth a look if you are looking for an awesome search solution and have the ability to set up a separate SOLR service on your server.

FarCry Solr plugin provides configuration and management services for the embedded ColdFusion implementation of Solr search service. FarCry Solr allows you to set up a specific collection for each content type, defining exactly which properties should be searchable. In addition, there are features to allow multiple servers in a cluster manage their own collections, replicating/synchronising the verity configurations. Sample search code is provided, although many users will want to develop their own search interfaces. The plugin also provides logging and reporting of search activity.

**FarCry SOLR requires a minimum of FarCry v6.x to function.**

## Installation

### 5,0,x or 6,0,x Installation

Update the plugin list in your project's `./www/farcryConstructor.cfm` file.

``` coldfusion
<!--- FARCRY SPECIFIC --->
<cfset THIS.locales = "en_AU,en_US" />
<cfset THIS.dsn = "fullasagoog" /> 
<cfset THIS.dbType = "mssql" /> 
<cfset THIS.dbOwner = "dbo." /> 
<cfset THIS.plugins = "farcryblog,farcrysolr,farcrydoc" /> 
```

## Configuration
You'll find the administration screens under: `ADMIN > SOLR Plugin`

### Solr Default Configuration

If you don't specify a collection path and lhosts you will get the following defaults:

- default CF collection path
- lhosts; createObject("java", "java.net.InetAddress").localhost.getHostName()

Once you have installed the FarCry Solr plugin, the collection storage path can be managed in the webtop. Under the Admin tab select the `General Admin -> Configuration -> Edit Config -> Solr Search -> Storage Path`.

The solr collection configuration can also be managed from the webtop. Under the Admin tab, use the drop down list (defaults to "General Admin") and select the newly added option called "Solr Search Services." If you do not see Solr Search Services, try refreshing your application scope using the Admin drop down selection called "Developer Utilities."

A new scheduled task template is installed with the FarCry Solr plugin called "Update solr Collections (farcrysolr plugin)." Add a new scheduled task and select the new template from the drop down list.

## How To Use
A nice feature of Solr plugin is the ability to override what content gets indexed. This is achieved by writing a custom function within the content type that starts with `contentToIndex`

For example, a custom function to allow the ability to restrict content to only show published content (to allow forward publishing)

For example, within an extended `./myproject/packages/types/dmNews.cfc`

``` coldfusion
<cffunction name="contentToIndex" returntype="query" description="Gets news content to index">
  <cfset qContentToIndex = application.fapi.getContentObjects(typename="dmNews",lProperties="objectid",publishDate_lte=now(),expiryDate_gt=now()) /> 
  <cfreturn qContentToIndex>
</cffunction>
```

You can actually add multiple functions to the same content type which will then allow you to choose the function you want when you create the verity collection. Simply prefix them with `contentToIndex*`

For example, `contentToIndexTest` and `contentToIndexMyCategory`.

### How To Use

The `contentToIndex` function can be overridden in your custom type or type extension. If you just want a single custom contentToIndex function, then call it contentToIndex. This is the default value that is stored in `farSolrCollection.contentToIndexFunction`. If you add a single custom function using a different name (say `contentToIndexTest`) then your function will be ignored. The collection edit interface only lets you choose from custom `contentToIndex*` functions if there are more than one (see `webskin/farSolrCollection/edit.cfm` line 99). Adding a second custom `contentToIndex` function (say `contentToIndexProd`) will allow you to select which custom function is used when an update is done.

Your custom `contentToIndex` function also needs the `displayname` attribute to be set. It may be the same value as the name attribute. The value in the `displayname` attribute is used for the drop down list display (see `packages/types/farSolrCollection.cfc` around line 102).
