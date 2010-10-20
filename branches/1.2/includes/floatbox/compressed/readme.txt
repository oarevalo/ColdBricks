
The compressed folder contains both plain-text and gzipped compressed versions of the floatbox files.
The plain-text versions are compressed using the YUI compressor.
You can use these just by dropping floatbox.js, framebox.js and floatbox.css into the main floatbox folder,
thereby over-writing the existing uncompressed versions.

To serve the gzipped compressed versions of the floatbox files on an apache server:
-- Copy .htaccess to the root folder of your site,
or, copy it to the folder containing the floatbox js and css files,
or, edit its contents into your existing .htaccess file.
-- Copy the 3 *.gz floatbox files to the same folder that holds the uncompressed floatbox files, usually /floatbox/.
(Leave the existing uncompressed floatbox files (or the plain-text YUI compressed versions) in place alongside the gzip compressed ones.)
-- Test
-- Test some more
