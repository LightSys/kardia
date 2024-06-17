                         *** Kardia Project ReadMe ***

=== ABOUT ===

Kardia is an open-source non-profit administrative software system utilizing
a browser-based GUI.  It presently features mailing list management, general
ledger, payroll, gift receipting, and checking.


=== LICENSE ===

Copyright (C) 2001-2024 LightSys Technology Services and Kardia Contributors.

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

    - MySQL/MariaDB (installed by default on most Linux distributions; also
      available for Mac and Windows and other platforms).

    - Sybase ASE (a developer edition for Linux is free of charge; the 
      free express edition for Linux no longer exists).


=== INSTALLATION ===

Place these files in the /apps/kardia directory in your Centrallix Object-
System.  For example, this readme.txt file might reside at:

    /var/centrallix-os/apps/kardia/readme.txt

Build the database structure by using the files in sql/newfiles.  See the
README file in that directory.

Then point your browser at your Centrallix installation.  For example,

    http://localhost:800/apps/kardia/

We recommend using the Kardia virtual appliance (virtual machine) for most
users, instead of doing a manual installation.

