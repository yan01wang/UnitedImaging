/* =============================================================================
	SDL Knowledge Center Content Manager Web Help Script v1.0
	
	Copyright and trademark information relating to this product release

	Copyright © 2003-2017 SDL Group.

	SDL Group means SDL PLC. and its subsidiaries and affiliates. All intellectual 
	property rights contained herein are the sole and exclusive rights of SDL Group. 
	All references to SDL or SDL Group  shall mean SDL PLC. and its subsidiaries 
	and affiliates details of which can be obtained upon written request.


	All rights reserved. Unless explicitly stated otherwise, all intellectual 
	property rights including those in copyright in the content of this website 
	and documentation are owned by or controlled for these purposes by SDL Group. 
	Except as otherwise expressly permitted hereunder or in accordance with 
	copyright legislation, the content of this site, and/or the documentation 
	may not be copied, reproduced, republished, downloaded, posted, broadcast or 
	transmitted in any way without the express written permission of SDL.


	SDL Knowledge Center Content Manager is a registered trademark of SDL Group. 
	All other trademarks are the property of their respective owners. The names 
	of other companies and products mentioned herein may be the trademarks of 
	their respective owners. Unless stated to the contrary, no association with 
	any other company or product is intended or should be inferred.


	This product may include open source or similar third-party software, details 
	of which can be found by clicking the following link: Acknowledgments
 

	Although SDL Group  takes all reasonable measures to provide accurate and 
	comprehensive information about the product, this information is provided 
	as-is and all warranties, conditions or other terms concerning the documentation 
	whether express or implied by statute, common law or otherwise (including 
	those relating to satisfactory quality and fitness for purposes) are excluded 
	to the extent permitted by law.

	To the maximum extent permitted by law, SDL Group shall not be liable in 
	contract, tort (including negligence or breach of statutory duty) or otherwise 
	for any loss, injury, claim liability or damage of any kind or arising out of, 
	or in connection with, the use or performance of the Software Documentation 
	even if such losses and/or damages were foreseen, foreseeable or known, 
	for: (a) loss of, damage to or corruption of data, (b) economic loss, 
	(c) loss of actual or anticipated profits, (d) loss of business revenue, 
	(e) loss of anticipated savings, (f) loss of business, (g) loss of opportunity, 
	(h) loss of goodwill, or (i) any indirect, special, incidental or consequential 
	loss or damage howsoever caused.

	All Third Party Software is licensed "as is." Licensor makes no warranties, 
	express, implied, statutory or otherwise with respect to the Third Party 
	Software, and expressly disclaims all implied warranties of non-infringement, 
	merchantability and fitness for a particular purpose. In no event will 
	Licensor be liable for any damages, including loss of data, lost profits, 
	cost of cover or other special, incidental, consequential, direct, actual, 
	general or indirect damages arising from the use of the Third Party Software 
	or accompanying materials, however caused and on any theory of liability. 
	This limitation will apply even if Licensor has been advised of the possibility 
	of such damage. The parties acknowledge that this is a reasonable allocation 
	of risk.

	Information in this documentation, including any URL and other Internet Web 
	site references, is subject to change without notice. Without limiting the 
	rights under copyright, no part of this may be reproduced, stored in or 
	introduced into a retrieval system, or transmitted in any form or by any 
	means (electronic, mechanical, photocopying, recording, or otherwise), or for 
	any purpose, without the express written permission of SDL Group.
	
	Tested on windows with        IE6, IE7, FF2, FF3, Opera 9.62
	Tested on Linux (ubuntu) with FF3

	You may only use this script library on web help content 
	generated using SDL Knowledge Center Content Manager
   ========================================================================== */

function Search(s)
{
	var resultsFound = false;
  try
  {
		this.status = searchinglabel;
//		alert("s = |" + s + "|");
	}
	catch(err)
  {
	  var txt;
	  txt="There was an error on this page.\n\n";
	  txt+="Error description: " + err.description + "\n\n";
	  txt+="Click OK to continue.\n\n";
	  alert(txt);
  }

	if (!s)
  	 return false;
  	 
	searchCriteria = distectSearchCriteria(s);
	var resultArrIndexPos = new Array();
	var ORoperator = false; // by default all criteria have AND's inbetween. OR operator (,) must be entered by user.
	
	for (var criteriaCounter = 0; criteriaCounter < searchCriteria.length; criteriaCounter++) {
//		alert("Search for disected criteria: " + searchCriteria[criteriaCounter]);
		var foundDocumentIndexPos = new Array();		
		if (searchCriteria[criteriaCounter] == "|") 
		{	ORoperator = true; }
		else
		{
//			ORoperator = false;
			for (var i = 0; i < SearchInfo.length; i++) {
				if (SearchInfo[i].toLowerCase().indexOf(searchCriteria[criteriaCounter].toLowerCase(),0)>-1)
	      {
					foundDocumentIndexPos.push(i);	      	
	      }      
			}
		}
		if (ORoperator)
		{
			// combine (skip already available references) both (fondDocumentIndexPos / resultArrIndexPos) arrays
			
		}
		else
		{
			// build new union array containing elements existing in both (fondDocumentIndexPos / resultArrIndexPos) arrays
			resultArrIndexPos = combineArrays(foundDocumentIndexPos, resultArrIndexPos, ORoperator, criteriaCounter)
		}
			
	}
	
	//Build result list in browser screen.
	showSearchResults(s, resultArrIndexPos, searchCriteria);

	return true;
}

function showSearchResults(searchString, resultArr, searchCriteria)
{
	var sSearchedText = '';
	var pageString='<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">\n';
	pageString+='<html>\n';
	pageString+='<head>\n';
	pageString+='	<title>' + searchtitlelabel + '</title>\n';
	pageString+='	<base target="_self">\n';
	pageString+='	<meta name="Generator" content="SDL Knowledge Center Content Manager" />\n';
	pageString+='	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />\n';
	pageString+='	<link rel="stylesheet" type="text/css" href="webhelplayout.css" />\n';
	pageString+='	<link rel="stylesheet" type="text/css" href="stylesheet.css" />\n';
	pageString+='	<script type="text/javascript" src="searchlabels.js" charset="UTF-8"></script>\n';
	pageString+='	<script type="text/javascript" src="search.js" charset="UTF-16"></script>\n';
	pageString+='	<script type="text/javascript" src="searchdata.js" charset="UTF-8"></script>\n';
	pageString+='</head>\n';
	pageString+='<body class="framelayout">\n';
	pageString+='	<h1 class="heading1">' + searchtitlelabel + '</h1>\n';
	pageString+='	<form action="#" onsubmit="Search(document.forms[\'SearchFrm\'].searchcriteria.value); return false;" name="SearchFrm" id="SearchFrm">\n';
	pageString+='		<span>' + entersearchcriterialabel + '</span><br />\n';
	pageString+='		<input type="text" width="145" name="searchcriteria" value=\'' + searchString.replace(/\'/g, "&#39;") + '\' />\n';
	pageString+='		<input type="submit" name="searchbutton" value="' + searchbuttonlabel + '" width="50">\n';
	pageString+='	</form>\n';
	pageString+='<div id="resultlist">\n';
	
	if (resultArr.length == 0) 
	{
		pageString+='<p>' + nodocumentsfoundlabel + '</p>\n';
	}
	else
	{
		pageString += '<p>' + followingdocumentsfoundlabel + '</p>\n';
		for (var resultCounter=0; resultCounter<resultArr.length;resultCounter++)
		{
			sSearchedText = SearchInfo[resultArr[resultCounter]];
			var firstmatchingpos = sSearchedText.length;
			pageString += '<p class="resultitem"><a href="' + SearchFiles[resultArr[resultCounter]] + '" target="contentwin">' + SearchTitles[resultArr[resultCounter]] + '</a><br/>\n';
			pageString += '<span>';
			for (var criteriaCounter = 0; criteriaCounter < searchCriteria.length; criteriaCounter++)
			{
				var indexpos = sSearchedText.toLowerCase().indexOf(searchCriteria[criteriaCounter].toLowerCase(),0);
				if (indexpos >-1)
				{
					if (indexpos < firstmatchingpos) {firstmatchingpos = indexpos};
					sSearchedText = highlightText(sSearchedText, searchCriteria[criteriaCounter], indexpos);
				}
			}			
			var sEndString = '...';					
			if (firstmatchingpos > 50)
			{
				if(sSearchedText.substr(firstmatchingpos-50,125).toLowerCase().lastIndexOf("<b>") > sSearchedText.substr(firstmatchingpos-50,125).toLowerCase().lastIndexOf("</b>")) {sEndString='</b>...';} 
//				alert('b pos: ' + sSearchedText.substr(firstmatchingpos-50,125).toLowerCase().lastIndexOf("<b>") + ' | /b pos ' + sSearchedText.substr(firstmatchingpos-50,125).toLowerCase().lastIndexOf("</b>") + ' | Endstring: ' + sEndString); 
			pageString +="..."+ sSearchedText.substr(firstmatchingpos-50,125)+sEndString+"\n";
			}
			else
			{
				if(sSearchedText.substr(0,125).toLowerCase().lastIndexOf("<b>") > sSearchedText.substr(0,125).toLowerCase().lastIndexOf("</b>")) {sEndString='</b>...';}
//				alert('b pos: ' + sSearchedText.substr(0,125).toLowerCase().lastIndexOf("<b>") + ' | /b pos ' + sSearchedText.substr(0,125).toLowerCase().lastIndexOf("</b>") + ' | Endstring: ' + sEndString); 				
				pageString += sSearchedText.substr(0,125)+sEndString+"\n";
			}
			
			pageString += '</span></p>\n';	
		}
		
		
	} /* else */

	pageString+='</div>\n';	
	pageString+="</body></html>";
	
	this.status="";
	this.document.open();
	this.document.write(pageString);
	this.document.close();
}

function highlightText(text, textToHighlight, pos)
{
	var hiText = text.substr(0,pos);
	hiText += text.substr(pos,textToHighlight.length).bold();
	
	var ipos = text.substr(pos + textToHighlight.length).toLowerCase().indexOf(textToHighlight.toLowerCase(),0);
	
	if (ipos >- 1)
	{
		hiText += highlightText(text.substr(pos + textToHighlight.length), textToHighlight, ipos);
	}
	else
	{
		hiText += text.substr(pos + textToHighlight.length);
	}
	
	return hiText;
}

function distectSearchCriteria(s)
{
	var SearchItems = new Array();

	var SpacePos = -1;
	var prevSpacePos = 0;
	var QuoteEndPos = -1;
	var criteria = "";
	var quotedstring = false;

	for (charpos = 0; charpos < s.length; charpos++)
	{
		var letter = s[charpos];
		if (letter == undefined) {letter = s.charAt(charpos);}
		
		if (quotedstring) {
			switch (letter) {
				case "\"":
					QuoteEndPos = charpos;
					if (QuoteEndPos>-1) 
					{
							criteria = " " + s.substring(QuoteStartPos,QuoteEndPos) + " ";
					}
					SearchItems.push(criteria);
					quotedstring = false;
					QuoteStartPos = 0;
					prevSpacePos = QuoteEndPos+2;
					break;			
				default:
					break;
			}
		}
		else {
			switch (letter) {
				case " ":
					SpacePos = charpos;
					if (SpacePos > prevSpacePos) {
						criteria = s.substring(prevSpacePos,SpacePos);
						SearchItems.push(criteria); //SearchItems.push(" " + criteria); in case words have to start with criteria
						prevSpacePos = SpacePos+1;
					}
					break;				
				case "\"":
					QuoteStartPos = charpos+1; 
					QuoteEndPos = -1; 
					quotedstring = true;
					break;			
				default:
					break;
			}
		}
	}
	if (quotedstring) {alert("When searching for exact matches, you need to supply an equal amount of start and end quotes"); return [];}
	if (prevSpacePos > -1 && prevSpacePos < charpos) {
		criteria = s.substring(prevSpacePos,charpos);
		SearchItems.push(criteria); //SearchItems.push(" " + criteria); in case words have to start with criteria
	}

//	alert("number of criteria: " + SearchItems.length);
		
	// TODO: Replace/Escape < > & by entity values.
//	for (var i = 0; i < SearchItems.length; i++) {
//		SearchItems[i].replace("<","&lt;");
//		SearchItems[i].replace(">","&gt;");
//		SearchItems[i].replace("&","&amp;");
//	}	

	return SearchItems;
}

function combineArrays(newArray, existingArray, combinelists, requestNumber)
{
	var combinedArray = new Array();

	// First request. So return newArray because this is always correct.
	if (requestNumber == 0)
	{
		return newArray;
	}
	
	// Not first array. Check if found document was also found with previous searchCriteria.
	if (requestNumber>0)
	{
		for (i=0; i<newArray.length; i++)
		{
			var exists = false
			for (j=0; j<existingArray.length; j++)
			{
				if (newArray[i] == existingArray[j])
				{
					exists = true;
					break;
				}
			}
			
				// AND operator between searchCriteria
				// if document already exists in existingArray, copy reference to new item.
				if (exists) {combinedArray.push(newArray[i]);}
		}
	}
	return combinedArray;
}

/* =============================== End Of File =============================== */   