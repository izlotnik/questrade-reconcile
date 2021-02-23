The QuestradeReconcile macro is python code that uses the Questrade application programming interface (API) to fetch account, position, balance, equity, and 30 day activity into a LibreOffice spreadsheet file.

This script is meant to be run infrequently to help provide a dashboard view when, for example, re-balancing a portfolio. It is not meant to track real time market conditions.

![Figure 1: Run the QuestradeReconcile Python Macro](Documentation/RunQuestradeMacro.png?raw=True "Figure 1: Run the QuestradeReconcile Python Macro")

This project was last tested on February 12th, 2021 and continues  to be fully functional.

[PDF Documentation](Documentation/QuestradeMacroDocumentation.pdf?raw=True)

This repository is not meant to offer a turnkey application but instead is a useful reference. Nobody ought to allow any application, including this one, access to the Questrade API without first being able to completely understand and audit the code.

[Wiki Roadmap](https://github.com/kerouac01850/questrade-reconcile/wiki)

**Prerequistes**

<ul>
   <li>[LibreOffice for spreadsheet functionality](https://www.libreoffice.org/download/download/)</li>
   <li>[7Zip for development](https://www.7-zip.org/download.html)</li>
</ul>

**Notes**

LibreOffice must be installed to make use of the included Sample spreadsheet. Python and Basic macros are installed into the spreadsheet file by default.  It represents a really good starting point for a fully customized portfolio tracking application. The spreadsheet file is a standard ODS archive generated by LibreOffice.

LibreOffice has a built-in editor for Basic but not for Python macros. The following is necessary when making Python changes to the spreadsheet file.

<pre>
C:\questrade-reconcile>"C:\Program Files\7-Zip\7z.exe" l Sample.ods

7-Zip 18.05 (x64) : Copyright (c) 1999-2018 Igor Pavlov : 2018-04-30

Scanning the drive for archives:
1 file, 40197 bytes (40 KiB)

Listing archive: Sample.ods

--
Path = Sample.ods
Type = zip
Physical Size = 40197

   Date      Time    Attr         Size   Compressed  Name
------------------- ----- ------------ ------------  ------------------------
2021-02-22 22:21:08 .....          338          211  Basic\script-lc.xml
2021-02-22 22:21:08 .....         8750         1613  Basic\Standard\QuestradeDashboard.xml
2021-02-22 22:21:08 .....          359          220  Basic\Standard\script-lb.xml
2021-02-22 22:21:08 D....            0            0  Configurations2\accelerator
2021-02-22 22:21:08 D....            0            0  Configurations2\floater
2021-02-22 22:21:08 D....            0            0  Configurations2\images\Bitmaps
2021-02-22 22:21:08 .....        33332         4307  Configurations2\menubar\menubar.xml
2021-02-22 22:21:08 D....            0            0  Configurations2\popupmenu
2021-02-22 22:21:08 D....            0            0  Configurations2\progressbar
2021-02-22 22:21:08 D....            0            0  Configurations2\statusbar
2021-02-22 22:21:08 D....            0            0  Configurations2\toolbar
2021-02-22 22:21:08 D....            0            0  Configurations2\toolpanel
2021-02-22 22:21:08 .....        32581         3813  content.xml
2021-02-22 22:21:08 .....          899          261  manifest.rdf
2021-02-22 22:21:08 .....         4191          509  META-INF\manifest.xml
2021-02-22 22:21:08 .....          879          441  meta.xml
2021-02-22 22:21:08 .....           46           46  mimetype
2021-02-22 22:21:08 .....         2651          975  Scripts\python\pythonpath\connection\connection.py
2021-02-22 22:21:08 .....           36           36  Scripts\python\pythonpath\connection\__init__.py
2021-02-22 22:21:08 .....         2908          819  Scripts\python\pythonpath\questrade_api\auth.py
2021-02-22 22:21:08 .....         4615         1360  Scripts\python\pythonpath\questrade_api\enumerations.py
2021-02-22 22:21:08 .....          756          302  Scripts\python\pythonpath\questrade_api\questrade.cfg
2021-02-22 22:21:08 .....         6549         1477  Scripts\python\pythonpath\questrade_api\questrade.py
2021-02-22 22:21:08 .....           74           50  Scripts\python\pythonpath\questrade_api\__init__.py
2021-02-22 22:21:08 .....         1742          829  Scripts\python\pythonpath\spreadsheet\account.py
2021-02-22 22:21:08 .....         2991         1185  Scripts\python\pythonpath\spreadsheet\activity.py
2021-02-22 22:21:08 .....         2617         1083  Scripts\python\pythonpath\spreadsheet\balance.py
2021-02-22 22:21:08 .....         3783         1283  Scripts\python\pythonpath\spreadsheet\configuration.py
2021-02-22 22:21:08 .....         4409         1498  Scripts\python\pythonpath\spreadsheet\equity.py
2021-02-22 22:21:08 .....         2711         1149  Scripts\python\pythonpath\spreadsheet\position.py
2021-02-22 22:21:08 .....        10085         3245  Scripts\python\pythonpath\spreadsheet\spreadsheet.py
2021-02-22 22:21:08 .....          239          116  Scripts\python\pythonpath\spreadsheet\__init__.py
2021-02-22 18:46:45 ....A         5084         1753  Scripts\python\QuestradeReconcile.py
2021-02-22 22:21:08 .....        20972         1925  settings.xml
2021-02-22 22:21:08 .....        55733         4185  styles.xml
------------------- ----- ------------ ------------  ------------------------
2021-02-22 22:21:08             209330        34691  27 files, 8 folders
</pre>

To extract and make changes to the QuestradeReconcile.py file embedded within the Sample.ods file use 7zip or any other archive program:

<pre>
C:\questrade-reconcile>"C:\Program Files\7-Zip\7z.exe" x -aoa Sample.ods Scripts\python\QuestradeReconcile.py

7-Zip 18.05 (x64) : Copyright (c) 1999-2018 Igor Pavlov : 2018-04-30

Scanning the drive for archives:
1 file, 40197 bytes (40 KiB)

Extracting archive: Sample.ods
--
Path = Sample.ods
Type = zip
Physical Size = 40197

Everything is Ok

Size:       5084
Compressed: 40197

C:\questrade-reconcile>dir Scripts\python\QuestradeReconcile.py
 Volume in drive C is Workspace
 Volume Serial Number is 8A6C-096F

 Directory of C:\questrade-reconcile\Scripts\python

02/22/2021  06:46 PM             5,084 QuestradeReconcile.py
               1 File(s)          5,084 bytes
               0 Dir(s)  114,185,687,040 bytes free
</pre>

To overwrite the existing Scripts\python\QuestradeReconcile.py file in the Sample.ods file with your changes using 7zip:

<pre>
C:\questrade-reconcile>"C:\Program Files\7-Zip\7z.exe" u -uy2 Sample.ods Scripts\python\QuestradeReconcile.py

7-Zip 18.05 (x64) : Copyright (c) 1999-2018 Igor Pavlov : 2018-04-30

Open archive: Sample.ods
--
Path = Sample.ods
Type = zip
Physical Size = 40197

Scanning the drive:
1 file, 5084 bytes (5 KiB)

Updating archive: Sample.ods

Keep old data in archive: 8 folders, 26 files, 204246 bytes (200 KiB)
Add new data to archive: 1 file, 5084 bytes (5 KiB)


Files read from disk: 1
Archive size: 40197 bytes (40 KiB)
Everything is Ok
</pre>

QuestradeReconcile is free software: you can redistribute and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

QuestradeReconcile is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details. You should have received a copy of the GNU General Public License along with this program.  If not, see https://www.gnu.org/licenses/.
