<cfsavecontent variable="tmpHTML">
	<link type="text/css" rel="stylesheet" href="includes/css/style.css" />
	<link type="text/css" rel="stylesheet" href="includes/floatbox/floatbox.css" />
	<script type="text/javascript" src="includes/floatbox/floatbox.js"></script>
	<script type="text/javascript">
		function hideMessageBox() {
			var d = document.getElementById("app_messagebox");
			d.style.display = "none";
		}		
	</script>
	<style type="text/css">
		#app_messagebox {
			top:5px;
		}
		.formField {
			width:250px !important;
		}
	</style>
</cfsavecontent>
<cfhtmlhead text="#tmpHTML#">

<br /><br /><br />

<p align="center">
	<a href="##" onclick="fb.end()">Click Here</a> to close this window
</p>