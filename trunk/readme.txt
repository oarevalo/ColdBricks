/**************************************************************/	
/* ColdBricks  (v1.1.x)										  */
/* http://www.coldbricks.com
/**************************************************************/	

/*
	Copyright 2007-2008 - Oscar Arevalo (http://www.oscararevalo.com)

    This file is part of ColdBricks.

    ColdBricks is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    ColdBricks is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Lesser General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with ColdBricks.  If not, see <http://www.gnu.org/licenses/>.

*/ 

-----------------------------------------------------------------------
Contents:
-----------------------------------------------------------------------
1. About ColdBricks
2. Release Notes
3. System Requirements
4. Installing ColdBricks
5. Configuration Options
6. Acknowledgements / Thanks / Credits
7. Bugs / suggestions


-----------------------------------------------------------------------
1. About ColdBricks
-----------------------------------------------------------------------
ColdBricks is a web-based application for the ColdFusion platform 
that allows users to quickly generate and manage highly dynamic and modularized 
websites and portals.

Technically speaking, ColdBricks is a management tool for managing sites 
and portals created using the HomePortals framework. 


-----------------------------------------------------------------------
2. Release Notes
-----------------------------------------------------------------------
Version 1.1
- Updated to work with HomePortals version 3.1
- Updated internal application framework to version 1.3 of the core framework
- Moved to a modular architecture. All features are now deployed as standalone modules on the modules directory
- Added support for external modules located outside the application directory

Version 1.0
- This is the first public release of ColdBricks. Have fun, send feedback!


-----------------------------------------------------------------------
3. System Requirements
-----------------------------------------------------------------------
Since the sites created and managed by ColdBricks rely on the HomePortals engine to function, 
ColdBricks itself has a very small footprint in your server (around 15mb including the data directory).
Additional requirements:
- Adobe ColdFusion server (version 8 and up), Railo 3 and up
- HomePortals Framework (version 3) - optionally included in the ColdBricks distribution package
- ColdBricks can be deployed on any of the ColdFusion supported platforms. 



-----------------------------------------------------------------------
4. Installing ColdBricks
-----------------------------------------------------------------------
The default installation process for ColdBricks is fairly simple. Just unzip the package contents
into the webroot of the server and access it using your browser by going to:

	http://<your_server>/ColdBricks

The default username and password are both 'admin'. PLEASE CHANGE YOUR PASSWORD 
AS SOON AS YOU LOGIN INTO COLDBRICKS!!!!

On its first run, ColdBricks will create its data directory. By default, it will create a 
directory named ColdBricksData right under the webroot. To modify the location of this 
directory see the next section '5. Configuration Options'. Make sure that the ColdBricks
application has enough permissions to write to this directory.

NOTE: It is possible to install ColdBricks on its own webroot (i.e. Apache Virtual Server),
however you must then define a ColdFusion mapping named ColdBricks pointing to the location
of the ColdBricks application. In addition, ColdBricks requires access to the HomePortals
framework, this means that the /Home directory must be accessible from the location where 
ColdBricks is installed, both by linking directly to it and by referencing it via ColdFusion. 



-----------------------------------------------------------------------
5. Configuration Options
-----------------------------------------------------------------------
The ColdBricks/config/config.xml file contains some entries that can be modified to adapt
to specific environments. The most important ones are:

[[ dataRoot ]]  
This is the location of directory where ColdBricks will store its
data files. If the directory doesn't exist, then it will be created.
You can use an ColdFusion mapping for this. 
Default value is /ColdBricksData

[[ siteTemplatesRoot ]] 
This is the location where ColdBricks will look for SiteTemplates. You can add your own
site templates here.
Default value is /ColdBricks/siteTemplates

[[ deleteAfterArchiveDownload ]] 
Set this flag to false for archive files to remain in the archives 
directory (<data_root>/archives) after a site download
Default value is true

[[ showHomePortalsAsSite ]]
Set this flag to true to have Coldbricks display the main HomePortals directory
as a site to be managed with coldbricks. Default is false

**** IMPORTANT ****
For any change on the config.xml file to take effect, you must logout of the application
and click on the 'Reset ColdBricks' link at the bottom of the login form. This will force
a reload of the application settings.



-----------------------------------------------------------------------
6. Acknowledgements / Thanks / Credits
-----------------------------------------------------------------------
ColdBricks uses the following open source components:
* Silk icon set from FamFamFam.com (http://www.famfamfam.com/lab/icons/silk/)
* TinyMCE editor from Moxiecode Systems AB (http://tinymce.moxiecode.com/)
* HomePortals 3 Framework (http://www.homeportals.net)


-----------------------------------------------------------------------
7. Bugs / suggestions
-----------------------------------------------------------------------
If you find any bug in the application or have any suggestions that you wish
to share with us, you can get in touch with us by email at info@coldbricks.com 


