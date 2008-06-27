<cfsetting showdebugoutput="false">
<cfparam name="request.requestState.stModule" default="">

<cfset thisModule = request.requestState.stModule>

<cfset aFontFamilies = arrayNew(1)>
<cfset aFontFamilies[1] = "Arial, Helvetica, sans-serif">
<cfset aFontFamilies[2] = """Times New Roman"", Times, serif">
<cfset aFontFamilies[3] = """Courier New"", Courier, monospace">
<cfset aFontFamilies[4] = "Georgia, ""Times New Roman"", Times, serif">
<cfset aFontFamilies[5] = "Verdana, Arial, Helvetica, sans-serif">
<cfset aFontFamilies[6] = "Geneva, Arial, Helvetica, sans-serif">

<cfset aBorderStyles = listToArray("none,hidden,dotted,dashed,solid,double,groove,ridge,inset,outset,inherit")>


<cfparam name="thisModule.ID" default="">
<cfparam name="thisModule.container" default="true">

<style type="text/css">
	.secTitle {
		font-size:11px;
		background-color:#ebebeb;
		line-height:18px;
		border-bottom:1px solid silver;
		border-top:1px solid #333;
		padding:2px;
		padding-left:6px;
	}
</style>

<cfoutput>
	<div style="border-bottom:1px solid black;background-color:##ccc;text-align:left;line-height:22px;">
		<a href="?event=ehPage.dspEditModuleProperties&moduleID=#thisModule.id#"><img src="images/edit-page-yellow.gif" align="absmiddle" border="0" style="margin-left:3px;"></a>
		<a href="?event=ehPage.dspEditModuleProperties&moduleID=#thisModule.id#" style="font-weight:normal;">Edit</a>&nbsp;&nbsp;

		<a href="##" onclick="doDeleteModule('#thisModule.ID#');"><img src="images/waste_small.gif" align="absmiddle" border="0"></a>
		<a href="##" onclick="doDeleteModule('#thisModule.ID#');" style="font-weight:normal;">Delete</a>&nbsp;&nbsp;
		
		<a href="##" onclick="doEvent('ehPage.dspModuleCSS','moduleProperties',{moduleID:'#jsstringformat(thisModule.ID)#'})"><img src="images/color_wheel.png" align="absmiddle" border="0"></a>
		<a href="##" onclick="doEvent('ehPage.dspModuleCSS','moduleProperties',{moduleID:'#jsstringformat(thisModule.ID)#'})"><strong>Style</strong></a>
	</div>

	<div class="secTitle"><a href="##" onclick="togglePanel('cssEditTitle')">Container Title</a></div>
	<div id="cssEditTitle" style="margin:10px;display:none;">
		<b>Font:</b>
		<select name="font-family" style="width:120px;">
			<cfloop from="1" to="#arrayLen(aFontFamilies)#" index="i">
				<option value="#aFontFamilies[i]#">#aFontFamilies[i]#</option>
			</cfloop>
		</select><br><br>

		<b>Font Size:</b> 
		<input type="font-size" style="width:15px;"> px &nbsp; <br><br>
		
		<b>Border:</b>
		<input type="border-width" style="width:10px;"> px &nbsp;
		<select name="font-style" style="width:50px;">
			<cfloop from="1" to="#arrayLen(aBorderStyles)#" index="i">
				<option value="#aBorderStyles[i]#">#aBorderStyles[i]#</option>
			</cfloop>
		</select><br><br>
		
		<b>Background Color:</b>
		<br><br>
	</div>
	

	<div class="secTitle"><a href="##" onclick="togglePanel('cssEditContent')">Content</a></div>
	<div id="cssEditContent" style="margin:10px;display:none;">
		
		<b>Font:</b>
		<select name="font-family" style="width:120px;">
			<cfloop from="1" to="#arrayLen(aFontFamilies)#" index="i">
				<option value="#aFontFamilies[i]#">#aFontFamilies[i]#</option>
			</cfloop>
		</select><br><br>

		<b>Font Size:</b> 
		<input type="font-size" style="width:15px;"> px &nbsp; <br><br>
		
		<b>Border:</b>
		<input type="border-width" style="width:10px;"> px &nbsp;
		<select name="font-style" style="width:50px;">
			<cfloop from="1" to="#arrayLen(aBorderStyles)#" index="i">
				<option value="#aBorderStyles[i]#">#aBorderStyles[i]#</option>
			</cfloop>
		</select><br><br>
		
		<b>Background Color:</b>
		<br><br>

		<b>Margin:</b>
		<input type="margin" style="width:15px;"> px &nbsp;
		
	</div>

</cfoutput>
