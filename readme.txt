************************************************************
DITA-OT 2.3

RELEASE NOTES SDL KNOWLEDGE CENTER INTEGRATION
Copyright © 2003-2017 SDL Group. All rights reserved.
************************************************************

	Downloaded from: http://www.dita-ot.org/
	For implementation details, see story https://jira.sdl.com/browse/TS-11325

	Downloaded:      dita-ot-2.3.zip
	Downloaded on:   10 Jun 2016

Standard DITA-OT 2.3 was downloaded and copied to "C:\TFS\RnDProjects\Trisoft\Dev\Server.App\Applications\Utilities\DITA-OT\InfoShare"


Changes made to standard dita-ot 2.3

1. Line added to \lib\configuration.properties: 
org.dita.pdf2.index.frame-markup = true

2. InfoShare plugin folders were copied from DITA-OT 1.8.5 InfoShare\plugins to DITA-OT\Infoshare\plugins: 
\plugins\ishApiRef
\plugins\ishHtmlHelp
\plugins\ishPdf
\plugins\ishWebHelp
\plugins\ishXPP
\plugins\webworks

3. References were added in \plugins\org.dita.xhtml\xsl\dita2html-base.xsl 
<!-- SDL KNOWLEDGE CENTER import added -->
	<xsl:import href="xslhtml/infoshare.dita2htmlImpl.xsl"></xsl:import>
	<xsl:import href="../../ishWebHelp/xsl/xslhtml/infoshare.dita2htm.diff.xsl"/>
	<xsl:import href="../../ishApiRef/xsl/infoshare.dita2htm.elems.apiref.xsl"/>

4. Some changes were done in \plugins\org.dita.base\build_init.xml: 
"use-init" blocks were renamed to "build-init"
'HTMLHelpCompiler' and 'pdfFormatter' properties were included by adding the whole sections:
<target name="build-init.envhhcdir">
<target name="build-init.hhcdir" unless="env.HHCDIR">
<target name="build-init.pdfFormatter">

5. Added "build-init.envhhcdir", "build-init.hhcdir" and "build-init.pdfFormatter" to 'depends' attribute in <target name="build-init">  

6. Copied all <language>_<country>.xml files to <language>.xml files in the following folders (Currently only the zh_CN.xml files were copied to zh.xml): 
\plugins\org.dita.pdf2\cfg\common\index\zh_CN.xml copied to zh.xml
\plugins\org.dita.pdf2\cfg\common\vars\zh_CN.xml copied to zh.xml
\plugins\org.dita.pdf2\cfg\fo\i18n\zh_CN.xml copied to zh.xml

7. Fixed "customization.dir" in \plugins\org.dita.pdf2\build_template.xml 

8. \plugins\org.dita.pdf2\build.xml - this file will be generated from build_template.xml. The generated one was checked-in in TFS. 

9. Line was added to \plugins\org.dita.xhtml\xsl\dita2html-base_template.xsl:  
<xsl:import href="xslhtml/infoshare.dita2htmlImpl.xsl"/> 

10. \plugins\org.dita.xhtml\xsl\dita2html-base.xsl - will be generated from dita2html-base_template.xsl - The generated one was checked-in in TFS. 

11. File was added "\plugins\org.dita.xhtml\xsl\xslhtml\infoshare.dita2htmlImpl.xsl"  
Adds templates to do specific stuff with the "object" element to support SDL Media Manager integration

12. Css files were changed: 
\plugins\org.dita.xhtml\resource\commonltr.css
Added blocks for extra
"body" styling
a.visited
pre.codeblock {background-color: #EFEFEF;}
Changed
.topictitle1 {font-size: 22px;line-height: 33px;}
.sectiontitle { font-size: 18px; line-height: 27px; font-weight: normal;}
\plugins\org.dita.xhtml\resource\commonrtl.css
the same but change "right" to "left" and "left" to "right" (look into TFS changesets for better view)

13. Files were added	 
\plugins\SupportedSoftware.xml
Path to fop home was updated from "org.dita.pdf2\fop" to "org.dita.pdf2.fop\fop"
\plugins\Trisoft-CommonTargets.xml
\readme.txt - contains all the changes we did to a standart dita-ot

14. Added InfoShare files - copied them from old version
\config.cmd 
\startcmd.bat - original file from dita-ot 2.3 was left - nothing changed 
\config.custom.cmd 
\dita-ot.cmd 
\dita-ot-build.cmd 
\dita-ot-ishhtmlhelp.cmd 
\dita-ot-ishpdf.cmd  
\dita-ot-ishwebhelp.cmd 
\dita-ot-ishxpp.cmd 
\dita-ot-pdf2.cmd 
\dita-ot-webworks.cmd 

15. Messages.xml changed 

16. Files were changed:
\build-template.xml (build.xml is generated automatically) 
\catalog-dita.xml - will be generated from catalog-dita_template.xml - The generated one was checked-in in TFS. 
\catalog-dita_template.xml (redirect to InfoShare catalogs/dtds via nextCatalog statement + additional dita:extension lines as present in standard DITA-OT 1.8.5))  SDL content was copied from 1.8.5 file version
\integrator.xml (default="strict" changed to default="lax" for backward compatibility as this was the default with 1.5.4) 

17. \build.xml - Will be generated from build.template.xml - The generated one was checked-in in TFS. 
 Note that: Install tool parameters used in:
\config.cmd
\catalog-dita.xml
\catalog-dita_template.xml
\webworks\

18. Depends attributes:
In \plugins\ishHtmlHelp\integrator.xml in target "dita2ishhtmlhelp"
Replace depends attribute "dita.topics.html, dita.inner.topics.html, dita.outer.topics.html" with "xhtml.topics"
In \plugins\ishWebHelp\integrator.xml in depends attribute of target "dita2ishwebhelp"
Remove "gen-list, copy-files, debug-filter, move-meta-entries, conref, mappull, maplink, move-links, topicpull"
Replace "copy-css, dita.topics.xhtml, dita.inner.topics.xhtml, dita.outer.topics.xhtml" with "xhtml.topics, copy-css"
In \plugins\ishXpp\integrator.xml
Remove "gen-list, copy-files, debug-filter, move-meta-entries, conref, mappull, maplink, move-links, topicpull" from depends attribute of target "dita2ishxpp"

19. Check that all the target's depends attributes in all custom "integrator.xml" plugin files have "copy-css" in the end of the value, but not in the middle of it

20. Replace "SET ANT_HOME=%PS_DITAOT%\tools\ant" with "SET ANT_HOME=%PS_DITAOT%" in \config.cmd