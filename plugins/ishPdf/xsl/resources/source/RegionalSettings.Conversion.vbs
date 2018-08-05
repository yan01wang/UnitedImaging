option explicit

'******************************************************************************************
'* This script is used to convert the RegionalSettings.Sources.xml into x XML files
'* The generate files must be moved to the folder "resources"
'******************************************************************************************
dim oXML
dim oXMLPart
dim oMasterXML
dim oNode
dim oComment
dim oSettingNode
dim oAttr
dim sLng
dim sLngDecription
dim sComment
dim sRegion
dim sXML
dim sFileName
dim sLngCode 
dim lPos
dim sLngCodes
dim sLngDescriptions
dim asLngDescriptions
dim asLngCodes
dim vLngCode
dim vLngDescr
dim i

dim sMasterRootNode
sMasterRootNode = "RegionalSettingsList"
dim sRegionalSettingNode
sRegionalSettingNode = "RegionalSettings"

set oXML = CreateObject("MSXML2.DOMDocument.6.0")
if not oXML.load("RegionalSettings.Sources.xml") then
	wscript.echo "Loading 'RegionalSettings.Sources.xml' failed: " & oXML.parseerror.reason & "(line=" & oXML.parseerror.line & ", pos=" & oXML.parseerror.linepos & ")"
else
	set oMasterXML = CreateObject("MSXML2.DOMDocument.6.0")
	oMasterXML.preserveWhiteSpace = True
	oMasterXML.loadXML("<" & sMasterRootNode & "/>")
		
	sLngCodes = ""
	
	'Generate a file for each line in RegionalSettings.Sources.xml
	for each oSettingNode in oXML.selectnodes("//" & sRegionalSettingNode)
		sLng = ""
		set oAttr = oSettingNode.Attributes.GetNamedItem("xml:lang")
		if not oAttr is nothing then
			sLng = oAttr.text
		end if
		set oAttr = Nothing
	
		wscript.echo "RegionalSettings of language '" & sLng & "'"
		if len(sLng) > 0 then
			set oNode = oSettingNode.selectsinglenode("setting[@name='CountryDescription']")
			if not oNode is nothing then
				sRegion = oNode.text
			end if	
			set oNode = Nothing
		
			set oNode = oSettingNode.selectsinglenode("setting[@name='LanguageDescription']")
			if not oNode is nothing then
				sLngDecription = oNode.text
			end if			
			set oNode = Nothing
		
			lPos = InStr(sLng,"-")
			if lPos > 0 then
				sLngCode = Mid(sLng, 1, lPos-1)
			else
				sLngCode = sLng
			end if
			wscript.echo "--> LanguageCode = '" & sLngCode & "'"
			if len(sLngCodes) = 0 then
				sLngCodes = sLngCode 
				sLngDescriptions = sLngDecription 
			elseif InStr("|" & sLngCodes & "|",sLngCode)=0 then
				sLngCodes = sLngCodes & "|" & sLngCode 
				sLngDescriptions =  sLngDescriptions & "|" & sLngDecription 
			end if
			sComment = sLngDecription & " (" & sRegion & ")"

			sXML = "<?xml version='1.0' encoding='UTF-8'?>"
			sXML = sXML & oSettingNode.xml
			sFileName = getFileName(sLng)
			
			set oXMLPart = CreateObject("MSXML2.DOMDocument.6.0")
			oXMLPart.preserveWhiteSpace = True
			oXMLPart.loadXML(sXML)
			
			set oComment = oXMLPart.createComment(sComment)
			oXMLPart.documentElement.InsertBefore oComment, oXMLPart.documentElement.firstChild 
			oXMLPart.save sFileName
			
			wscript.echo "--> RegionalSettings saved with filename '" & sFileName & "'"
			set oXMLPart= Nothing
			set oComment= Nothing
			
			createMasterNode oMasterXML, slng, slng, sComment 
			createMasterNode oMasterXML, lcase(slng), slng, sComment 
			if instr(slng, "-") > 0 then
			   createMasterNode oMasterXML, replace(slng, "-", "."), slng, sComment 
			   createMasterNode oMasterXML, replace(lcase(slng), "-", "."), slng, sComment 
			   createMasterNode oMasterXML, replace(slng, "-", "_"), slng, sComment 
			   createMasterNode oMasterXML, replace(lcase(slng), "-", "_"), slng, sComment 
			end if
		end if
	next
	
	asLngCodes =Split(sLngCodes, "|")
	asLngDescriptions = split(sLngDescriptions, "|")
	for i = 0 to ubound(asLngCodes)
		vLngCode= asLngCodes(i)
		vLngDescr = asLngDescriptions(i)
		
		sLng = ""

		set oNode =  oMasterXML.selectNodes("//" & sRegionalSettingNode & "[@xml:lang='" & vLngCode & "-" & ucase(vLngCode) & "']")
		if oNode.length = 0 then
			set oNode =  oMasterXML.selectNodes("//" &  sRegionalSettingNode & "[contains(@xml:lang, '" & vLngCode & "')]")
			if oNode.length = 1 then
				sLng = oNode.item(0).attributes.getnameditem("xml:lang").text
			else
				select case vLngCode
					case "ca"
						sLng = "ca-ES"
					case "en"
						sLng = "en-GB"
					case "da"
						sLng = "da-DK"
					case "sq"
						sLng = "sq-AL"
					case "sm"
						sLng = "sm-WS"
					case "sr"
						sLng = "sr-RS"
					case "ms"
						sLng = "ms-MY"
					case "zh"
						sLng = "zh-CN"
					case "sv"
						sLng = "sv-SE"
					case "el"
						sLng = "el-GR"
					case "ar"
						sLng = "ar-EG"
					case "ko"
						sLng = "ko-KR"
				end select
				
				if len(sLng)=0 and oNode.length >0 then
					'Use the first occurrence of the language
					sLng = oNode.item(0).attributes.getnameditem("xml:lang").text
				end if
			end if
		else
			sLng= vLngCode & "-" & ucase(vLngCode)
		end if
		set oNode = Nothing

		if len(sLng) = 0 then
			wscript.echo "Warning: No conversion for the language code '" & vLngCode & "' defined."
		else			
			createMasterNode oMasterXML, vLngCode, sLng, vLngDescr
		end if
	next

	'Add some extra conversions
	appendCommentNode oMasterXML, "Commonly used, but no standard conversions"
	
	createMasterNode oMasterXML,"ae","en-US","American English"
	createMasterNode oMasterXML,"cf","cf-CA", "Canadian French"
	createMasterNode oMasterXML,"in","id-ID", "Indonesian"
	createMasterNode oMasterXML,"iw","he-IL","Hebrew"
	createMasterNode oMasterXML,"pb","pt-BR", "Brazilian Portugese"
	createMasterNode oMasterXML, "sc","sv-SE", "Scandinavian"
	createMasterNode oMasterXML, "xl","es-MX","Latin American Spanish"
	createMasterNode oMasterXML, "zs","zh-CN", "Chinese simplified"
	createMasterNode oMasterXML,"zt","zh-TW","Chinese traditional Taiwan"
	
	oMasterXML.save "RegionalSettings.xml"
	wscript.echo "Master file saved with filename 'RegionalSettings.xml'"
end if

set oMasterXML = Nothing
set oNode = Nothing
set oSettingNode = Nothing
set oXML = Nothing
set oAttr = Nothing
set oXMLPart = Nothing

function createMasterNode(poDoc, psXMLLang, psLngCode, psComment)
	dim oNode 

	'Create the master node
	set oNode = poDoc.CreateElement(sRegionalSettingNode)
	oNode.setAttribute "xml:lang", psXMLLang
	oNode.setAttribute "filename", getFileName(psLngCode)
	poDoc.documentelement.appendchild oNode
	
	'Set comment
	appendCommentNode poDoc, psComment
	
	set oNode = Nothing
end function

function appendCommentNode(poDoc, psComment)
	dim oComment
	
	if len(psComment) > 0 then
		set oComment = poDoc.createComment(" " & psComment & " ")
		poDoc.documentelement.appendchild oComment
	end if
	set oComment = Nothing	
end function

function getFileName(psLng)
	getFileName = "RegionalSettings." & psLng & ".xml"
end function