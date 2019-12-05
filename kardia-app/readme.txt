                         *** Kardia Project ReadMe ***

=== ABOUT ===

Kardia is an open-source non-profit administrative software system utilizing
a browser-based GUI.  It presently features mailing list management, general
ledger, payroll, gift receipting, and checking.


=== LICENSE ===

Copyright (C) 2001-2019 LightSys Technology Services and Kardia Contributors.

This program is Free Software; this software is made available under the GNU
General Publlic License, version 2.  A copy is included in this distribution
in the file "COPYING".  You may also use this software under any later
version of the GNU GPL published by the Free Software Foundation.

Geonames postal code gazetteer (within kardia-app/data/gazetteer) is licensed
under a Creative Commons Attribution 3.0 License.


=== DOWNLOAD ===

You may download this software at:

    https://github.com/LightSys/kardia


=== DEPENDENCIES ===

This Kardia project is written to operate within the Centrallix framework.
Centrallix is available at: http://www.centrallix.net/

Please note that as this software is under development, it may contain
dependencies on bugfixes or features in Centrallix that are not officially
released yet.  Those features should be available in the GIT repository
for Centrallix; you'll need to check out the source and build from source.

You will need a database backend to use Kardia.  At present, there are two
choices available:

    - MySQL (installed by default on most Linux distributions; also
      available for Mac and Windows and other platforms).

    - Sybase ASE (the Express Edition for Linux is free of charge).


=== INSTALLATION ===

Place these files in the /apps/kardia directory in your Centrallix Object-
System.  For example, this readme.txt file might reside at:

    /var/centrallix-os/apps/kardia/readme.txt

Build the database structure by using the files in sql/newfiles.  See the
README file in that directory.

Then point your browser at your Centrallix installation.  For example,

    http://localhost:800/apps/kardia/


=== FURTHER INFORMATION ===

(from the original readme.txt file)

Here is the proposed SVN structure (as we continue to build the respository).  Note: The term organization used below refers to your specific organization.

<svn root>
  <kardia>
        index.app
        modules
        modules/gl - all files (except T4.app and sandbox_* and dave/
directory and plusminus.png)
        modules/payroll - all files
        modules/rcpt - all files
        modules/base - all files (except j_* and FPTableMaintenance.app)
        modules/disb - all files
        modules/local - only the directory
        tpl
        tpl/<organization>-kardia.tpl  (though we probably need to generalize the
name, maybe have it configured in Site.struct)
        tpl/newuser_default.tpl
        data
        data/Chat.csv (but make sure it is empty except header)
        data/Chat.spec
        data/EnterModes.csv
        data/EnterModes.spec
        data/Fonts.csv
        data/Fonts.spec
        data/FontSizes.csv
        data/FontSizes.spec
        data/Locale.csv
        data/Locale.spec
        data/Site.struct  (with <organization-specific>-stuff removed from it)
        data/TablePrefixes.csv
        data/TablePrefixes.spec
        data/TableRowHeights.csv
        data/TableRowHeights.spec
        data/Users.uxu
        data/Kardia_DB  (but change server = "SYBASE", database = "Kardia",
default_password = "password")
        images
        images/bg (all files except <organization>_logo.gif)
        images/menu
        images/icons
        help
        help/en_US (but no files or directories yet)
        sql (for now, just directory; I need to go through the .sql files
and
determine what goes in the repository and what doesn't and what needs to be
generalized and users or passwords removed and so forth)
    </kardia>
</svn root>

Other files, such as sql/<organization>data and data/<organization>data, are definitely off
limits as they contain data private to <organization>, even though there are some
scripts in there that need to get converted into a form usable by means
other
than command line.



