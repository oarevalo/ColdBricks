<!--- configure bean for dataprovider --->
<cfset oConfigBean = createObject("component","ColdBricks.components.model.db.dataProviderConfigBean").init()>
<cfset oConfigBean.setDataRoot("/ColdBricks/data")>
<cfset oConfigBean.setDSN("iradarweb")>
<cfset oConfigBean.setDBType("mssql")>

<!--- get data provider --->
<cfset oXMLDataProvider = createObject("component","ColdBricks.components.model.db.xmlDataProvider").init(oConfigBean)>
<cfset oDBDataProvider = createObject("component","ColdBricks.components.model.db.dbDataProvider").init(oConfigBean)>
<cfset oDataProvider = oXMLDataProvider>

<!--- get dao --->
<cfset oDAO = createObject("component","ColdBricks.components.model.db.siteDAO").init(oDataProvider)>


<!--- work on dao --->
<cfset qry = oDAO.getAll()>
<cfdump var="#qry#">


<cfset qry = oDAO.get("518E85E3-1676-3724-50100614703FFAF3")>
<cfdump var="#qry#"> 

<!--- 
<cfset oDAO.save(path="/Xilya", siteName="Xilya Personal Workspaces")>
<cfset oDAO.delete("510C6004-1676-3724-502B83F3F6413497")>
<cfset oDAO.save(id="510D8FF9-1676-3724-50075BC161C7C9A5", path="/XilyaWeb", siteName="Xilya Personal Workspaces")>

<cfset qry = oDAO.getAll()>
<cfdump var="#qry#"> 
--->
