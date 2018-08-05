XML Plug-in, version 1.4.1
==========================

============================================================================
Copyright © 2007 by XyEnterprise Inc. All rights reserved.

 XyEnterprise is a registered trademark of XyEnterprise Inc.

XYENTERPRISE INC. HAS CONTRIBUTED THE SOFTWARE "AS IS," WITH
ABSOLUTELY NO WARRANTIES WHATSOEVER, WHETHER EXPRESS OR IMPLIED, AND
XYENTERPRISE INC. DISCLAIMS ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING
BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE AND WARRANTY OF NON-INFRINGEMENT. XYENTERPRISE INC. SHALL NOT
BE LIABLE FOR INDIRECT, INCIDENTAL, SPECIAL, COVER, PUNITIVE, EXEMPLARY,
RELIANCE, OR CONSEQUENTIAL DAMAGES (INCLUDING BUT NOT LIMITED TO LOSS OF
ANTICIPATED PROFIT), ARISING FROM ANY CAUSE UNDER OR RELATED TO OR ARISING
OUT OF THE USE OF OR INABILITY TO USE THE SOFTWARE, EVEN IF XYENTERPRISE INC.
HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.

XyEnterprise Inc. and its licensors shall not be liable for any
damages suffered by any person as a result of using and/or modifying the
Software or its derivatives.

These terms and conditions supersede the terms and conditions in any
licensing agreement to the extent that such terms and conditions conflict
with those set forth herein.
============================================================================

Description:
------------

This plug-in (version 1.4.1) adds a new transformation type, "validdita", to the DITA Open Toolkit.
It takes as input a ditamap file and from the referenced topics creates a merged 
XML file that is valid against the ditabase DTD ("-//OASIS//DTD DITA Composite//EN").

It can be run with the following command in the DITA Open Toolkit installation directory:

Prompt>C:/ant/bin/ant -Dtranstype=validdita -Dargs.input=doc\articles\DITA-articles.ditamap

to produce the XML file "out\DITA-articles.xml"

Specialization:
---------------

Whenever specialization is implemented the constituent topic files are not, or may not be, 
valid DITA files according to the OASIS standard. 
In order for the end result to be always valid, a generalization to the standard DTD was made 
part of the process.

For example, from the mark-up:

   <APIname class="- topic/title reference/title APIdesc/APIname ">

the generalized mark-up:

   <title class="- topic/title reference/title APIdesc/APIname ">

is generated.
 
The end result is valid DITA in which the specialization information is still available through 
the value of the class attribute. 

In some cases it may be necessary to keep data that was filtered out to make the result valid DITA.
A wellformed version of the merged file can be obtained by adding the following switch to the command line:

-Dwellformed=true

Installation:
-------------

Unzip the file xml_plugin-1.4, and place the contents in the DITA installation 
"demo" sub directory, so that the following structure is created:

  Directory of C:\ditaot\demo

12-Jun-08  17:17    <DIR>          validdita

 Directory of C:\ditaot\demo\validdita

29-Jul-08  10:46             3,989 integrator.xml
29-Jul-08  10:55             1,516 plugin.xml
29-Jul-08  10:57             3,624 README.txt
12-Jun-08  16:14    <DIR>          xsl

 Directory of C:\ditaot\demo\validdita\xsl

29-Jul-08  10:54             3,772 ditabase.xsl
10-Aug-07  17:01             1,095 generalize.xsl
29-Jul-08  10:54             2,887 structuralize.xsl

In the DITA Open Toolkit installation directory, run the command:

ant -f integrator.xml

