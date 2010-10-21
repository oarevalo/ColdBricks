resourceEditor = {

	open: function(resID,resType,pkg,resLibIndex) {
				var href = "index.cfm"
					+ "?event=resource.ehResource.dspMain" 
					+ "&resourceID=" + resID + "&resourceType=" + resType + "&package=" + pkg + "&resLibIndex=" + resLibIndex;
				fb.loadAnchor(href,"width:600 height:480 loadPageOnClose:self");
			},

	main: function(resID,resType,pkg,resLibIndex) {
				var href = "index.cfm"
					+ "?event=resource.ehResource.dspMain" 
					+ "&resourceID=" + resID + "&resourceType=" + resType + "&package=" + pkg + "&resLibIndex=" + resLibIndex;
				document.location=href
			},

	save: function(frm) {
			var strErrors = "";
		
			if(frm.id.value=='') strErrors = strErrors + "\n - Resource ID cannot be empty.";
			if(frm.package.value=='' && frm.package_new.value=='') strErrors = strErrors + "\n - Package name cannot be empty.";
		
			if(strErrors!="") {
				alert("Please correct the following:\n" + strErrors);
				return;		
			}
		
			frm.submit();
		},

	deleteRes: function(resID,resType,pkg,resLibIndex) {
			if(confirm("Delete resource '" + resID + "' ?")) {
				var href = "index.cfm"
					+ "?event=resource.ehResource.doDelete" 
					+ "&resourceID=" + resID + "&resourceType=" + resType + "&package=" + pkg + "&resLibIndex=" + resLibIndex;
				document.location=href
			}
		},

	uploadFile: function(frm) {
			frm.event.value = "resource.ehResource.doUploadFile";
			frm.submit();
		},

	deleteFile: function(resID,resType,pkg,resLibIndex) {
			if(confirm("Delete target for resource '" + resID + "' ?")) {
				var href = "index.cfm"
					+ "?event=resource.ehResource.doDeleteFile" 
					+ "&resourceID=" + resID + "&resourceType=" + resType + "&package=" + pkg + "&resLibIndex=" + resLibIndex;
				document.location=href
			}
		},

	editFileRichText: function(resID,resType,pkg,resLibIndex) {
			var href = "index.cfm"
				+ "?event=resource.ehResource.dspEditor" 
				+ "&resourceID=" + resID + "&resourceType=" + resType + "&package=" + pkg + "&resLibIndex=" + resLibIndex+ "&type=richtext";
			document.location=href
		},

	editFilePlain: function(resID,resType,pkg,resLibIndex) {
			var href = "index.cfm"
				+ "?event=resource.ehResource.dspEditor" 
				+ "&resourceID=" + resID + "&resourceType=" + resType + "&package=" + pkg + "&resLibIndex=" + resLibIndex+ "&type=plain";
			document.location=href
		},

	saveFile: function(frm) {
			// check that there is a file name
			if(frm.fileName.value == '') {
				var ext = (frm.type.value=="richtext") ? "htm" : "txt";
				frm.fileName.value = prompt("Enter a name for this file",frm.resourceID.value + "." + ext)
			}
			if(frm.fileName.value == '') {
				alert("Filename cannot be empty");
				return;
			}
			frm.submit();
		},


	togglePackage: function(selVal) {
			if(selVal=='') 
				document.getElementById('newPkgDiv').style.display='block' 
			else 
				document.getElementById('newPkgDiv').style.display='none'
		},
	showUploadFile: function() {
			document.getElementById('uploadDiv').style.display='block' 
		},
	hideUploadFile: function() {
			document.getElementById('uploadDiv').style.display='none' 
		}
}




