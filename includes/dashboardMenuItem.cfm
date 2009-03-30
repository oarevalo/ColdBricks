<!--- DashBoardMenuItem

<cf_boxMenuItem href="-- url to load ---"
				help="-- long help text ---"
				imgSrc="-- image url --"
				alt="-- image alt text --"
				label="-- item label --">
 --->

<cfparam name="attributes.label" type="string"> 
<cfparam name="attributes.href" type="string">
<cfparam name="attributes.imgSrc" type="string">
<cfparam name="attributes.help" type="string" default="#attributes.label#">
<cfparam name="attributes.alt" type="string" default="#attributes.label#"> 
<cfparam name="attributes.isAllowed" type="boolean" default="true">
<cfparam name="attributes.labelStyle" type="string" default="">

<cfassociate baseTag="cf_dashboardMenu" dataCollection="itemTags">


