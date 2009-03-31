<cfparam name="request.requestState.stTags" default="#structNew()#">
<cfset stTags = request.requestState.stTags>

<cfoutput>
<div class="cp_sectionBox" 
	style="margin-top:0px;width:210px;padding:0px;height:420px;margin-right:0px;margin-left:0px;border-top:0px;">
	<div style="margin:5px;">
		<cfloop collection="#stTags#" item="tag">
			<div style="border-bottom:1px solid ##ebebeb;">
				<div style="float:right;">
					<a href="javascript:addContentTag('#jsstringformat(tag)#');"><img src="images/add.png" align="absmiddle" border="0" alt="Add To Page" title="Add To Page"></a>
					<a href="javascript:viewContentTagInfo('#jsstringformat(tag)#')"><img src="images/information.png" align="absmiddle" border="0" alt="Info" title="Info"></a>
				</div>
				<div style="width:130px;overflow:hidden;">
					<a href="javascript:viewContentTagInfo('#jsstringformat(tag)#')" 
						class="cpListLink" 
						style="font-weight:normal;" 
						>#tag#</a>
				</div>
			</div>
			<div style="clear:both;">		
		</cfloop>
	</div>
</div>
</cfoutput>
		