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

function ChangeMenu(tabname)
{
	var locString = '';
/*	alert(tabname);*/
	
	switch (tabname.toLowerCase()) {
	   case 'content': 
	   	locString = 'toc.html';
	   	break;
	   case 'index': 
	   	locString = 'indexpage.html';
	   	break;
	   case 'search': 
	   	locString = 'search.html';
	   	break;
	   default: 
	   	locString = '';
	 }
/*	 alert(locString); */
   var win = open(locString,'navigationwin');	 
/*   if (!parent.showNavWin) parent.ToggleNavWin(); */
   
   document.getElementById('content').className= '';
   document.getElementById('index').className= '';
   document.getElementById('search').className= '';
   document.getElementById(tabname.toLowerCase()).className= 'current';
/* change end li elements className value */
   document.getElementById('content-end').className= 'end';
   document.getElementById('index-end').className= 'end';
   document.getElementById('search-end').className= 'end';
   document.getElementById(tabname.toLowerCase()+'-end').className= 'endcurrent';
   
}

function showPrevTopic()
{
	var currentlocation = window.parent.contentwin.location.toString();
	var strippedCurrentTopicName = currentlocation.substring(currentlocation.lastIndexOf("/")+1,currentlocation.length);

	var CurrentPos = locateCurrentTopic(strippedCurrentTopicName);
	if (CurrentPos > -1)
	{
	  if (CurrentPos>0)
		{
		  NewPos = CurrentPos-1;
	    var locString = '';	
		  locString = FileSequence[NewPos];
	    var win = open(locString,'contentwin');
	  }
	  else
		{
		  alert('This is the first topic of your content.');
    }

   }

}

function showNextTopic() 
{
	var currentlocation = window.parent.contentwin.location.toString();
	var strippedCurrentTopicName = currentlocation.substring(currentlocation.lastIndexOf("/")+1,currentlocation.length);

	var CurrentPos = locateCurrentTopic(strippedCurrentTopicName);
	
	if (CurrentPos > -1)
	{
	  if ((FileSequence.length-1)>CurrentPos)
		{
		  NewPos = CurrentPos+1;
	    var locString = '';	
		  locString = FileSequence[NewPos];
	    var win = open(locString,'contentwin');		  
	  }
	  else
		{
			alert('This is the last topic of your content.');
    }
   }
}

function locateCurrentTopic(curTopic)
{
	var locationFound = -1;
	for (var arrayCounter=0; arrayCounter<FileSequence.length; arrayCounter++)
	{
		if (FileSequence[arrayCounter] == curTopic)
		{
			locationFound = arrayCounter;
			break;
		}
	}
	return locationFound;
}

function printTopic()
{
	if (window.print) 
	{
		window.parent.contentwin.focus();
		window.parent.contentwin.print();
	}
}

function firstTopic()
{
	locString = FileSequence[0];

/*	parent.LoadFrame(); 

	if (parent.contextSensitiveURL != "" && parent.contextSensitiveURL != undefined) {locString = parent.contextSensitiveURL;} */
	
	var win = open(locString,'contentwin');		
}