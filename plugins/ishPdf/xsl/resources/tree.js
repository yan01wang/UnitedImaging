/////////////////////////////////////////////////////////////////////
// Variables
/////////////////////////////////////////////////////////////////////
var collapsedIcon 		    = "plus.gif";
var expandedIcon  		    = "minus.gif";
var linkIcon      		    = "dot.gif";
var SelLinkIcon      	    = "dot.gif";

var sSelectColor  		    = "#f1b739";

var mouseOverColor 		    = "#f1b739";
var mouseOverUnderline 	  = false;

var bgcolor				        = "#FFFFFF";
var tablebgcolor		      = "#FFFFFF";

var font				          = "verdana,arial,sans-serif";
var fontSize			        = "10";
var fontColor             = "black"

/////////////////////////////////////////////////////////////////////
// Determine browser
/////////////////////////////////////////////////////////////////////
var isNav, isIE;
if (parseInt(navigator.appVersion) >= 4)
{
	if (navigator.appName == "Netscape")
	{
		isNav = true;
	}
	else
	{
		isIE = true;
	}
}

/////////////////////////////////////////////////////////////////////
// Construct stylesheet based on variables
/////////////////////////////////////////////////////////////////////
document.write("<STYLE>");
if (mouseOverUnderline==true)
{
	document.write("A:hover:unknown {COLOR: "+mouseOverColor+"; TEXT-DECORATION: underline}");
	document.write("A:hover:known {COLOR: "+mouseOverColor+"; TEXT-DECORATION: underline}");
}
else
{
	document.write("A:hover:unknown {COLOR: "+mouseOverColor+"; TEXT-DECORATION: none}");
	document.write("A:hover:known {COLOR: "+mouseOverColor+"; TEXT-DECORATION: none}");
}
document.write("A.Highlight {COLOR: white; BACKGROUND-COLOR: '#3333CC'}");
document.write(".sidemenuH {COLOR: #000000; FONT-FAMILY: "+font+"; FONT-SIZE: "+fontSize+"px; FONT-WEIGHT: normal; TEXT-DECORATION: none}");
document.write(".sidemenuHOn {BACKGROUND: "+tablebgcolor+"; COLOR: "+fontColor+"; FONT-FAMILY: "+font+"; FONT-SIZE: "+fontSize+"px; FONT-WEIGHT: normal; TEXT-DECORATION: none}");
document.write(".menuH {COLOR: "+tablebgcolor+"; FONT-FAMILY: "+font+"; FONT-SIZE: "+fontSize+"px; FONT-WEIGHT: normal; TEXT-DECORATION: none}");
document.write(".menuHOn {BACKGROUND: "+tablebgcolor+"; COLOR: "+fontColor+"; FONT-FAMILY: "+font+"; FONT-SIZE: "+fontSize+"px; FONT-WEIGHT: normal; TEXT-DECORATION: none}");
document.write(".categcell {BACKGROUND: "+tablebgcolor+"}");
document.write(".menucell {BACKGROUND: "+tablebgcolor+"}");
document.write("BODY {FONT-FAMILY: "+font+"; FONT-SIZE: "+fontSize+"px}");
document.write("TABLE {BACKGROUND: "+tablebgcolor+"; FONT-FAMILY: "+font+"; FONT-SIZE: "+fontSize+"px}");
document.write("TH {BACKGROUND: "+tablebgcolor+"; FONT-FAMILY: "+font+"; FONT-SIZE: "+fontSize+"px}");
document.write("TD {BACKGROUND: "+tablebgcolor+"; FONT-FAMILY: "+font+"; FONT-SIZE: "+fontSize+"px}");
document.write(".TabOff {BACKGROUND: white; FONT-FAMILY: "+font+"; FONT-SIZE: "+fontSize+"px}");
document.write("</STYLE>");

var NoNodes       = 0;
var SelectedNode;
var Ids           = new Array();
var Lbls          = new Array();
var Parents       = new Array();
var Targets       = new Array();
var Level         = new Array();
var Visible       = new Array();

var CurrentIndex  = -1;

var States        = new Array();
var DocImageNbr   = new Array();

var FolderImages  = new Array();

FolderImages[0] = new Image();
FolderImages[0].src = collapsedIcon;
FolderImages[1] = new Image();
FolderImages[1].src = expandedIcon;
FolderImages[2] = new Image();
FolderImages[2].src = linkIcon;

var selFolderImages = new Array();

selFolderImages[0] = new Image();
selFolderImages[0].src = collapsedIcon;
selFolderImages[1] = new Image();
selFolderImages[1].src = expandedIcon;
selFolderImages[2] = new Image();
selFolderImages[2].src = linkIcon;

function IsLink(Index)
{
	var Id = Ids[Index];
	return (Id.substr(0,4) == "LINK");
}

function IsLeaf(Index)
{
  for (i = Index + 1; i <= NoNodes; i++)
	{
	  // when indent of node is equal or greater than
		// original node indent you know it is not a child
		if (Level[i] <= Level[Index] || i == NoNodes)  
		  return true;
    return false;
  }
}


function ColorCurrent(Index)
{
	if (isIE)
	{
		if (CurrentIndex >= 0)
				eval("Node" + CurrentIndex).style.color = "";
		if (Index >= 0)
				eval("Node" + Index).style.color = sSelectColor;
	}
	else
	{
		if (CurrentIndex >= 0)
		{
			if (DocImageNbr[CurrentIndex] >= 0)
			{
				var ImageIndex = (IsLink(CurrentIndex)) ? 2 : States[CurrentIndex];
				document.images[DocImageNbr[CurrentIndex] + 2].src = FolderImages[ImageIndex].src;
			}
		}
		if (Index >= 0)
		{
			if (DocImageNbr[Index] >= 0)
			{
				var ImageIndex = (IsLink(Index)) ? 2 : States[Index];
				document.images[DocImageNbr[Index] + 2].src = selFolderImages[ImageIndex].src;
			}
		}
	}

	CurrentIndex = Index;
}

function ShowInTree(Target)
{
	var Index = 0;
	var i = 0;
	
	// Get index
	for (i = 0; i < NoNodes; i++)
	{
		if (Targets[i] == Target)
			break;
	}
	
	// Check if Id is known
	if (i == NoNodes)
		return;
		
	Index = i;

	// Check if already visible
	if (Visible[Index] == 1)
	{
		// Changecolor
		ColorCurrent(Index);
		top.SetCurrentIndex(Index);
		return;
	}

	// Construct closed parent array
	var ParentIndexArray = new Array();
	var Parent = Parents[Index];
	var ParentIndex = GetIndex(Parent);
	
	i = 0;
	while ((ParentIndex >= 0) && (States[ParentIndex] == 0) )
	{
		ParentIndexArray[i] = ParentIndex;
		i++;
		Parent = Parents[ParentIndex];
		ParentIndex = GetIndex(Parent);
	}

	// Store current : Netscape will redraw and use current
	top.SetCurrentIndex(Index);
	
	// Simulate click on each closed parent
	for (i = ParentIndexArray.length; i >=0;  i--)
	{
		NodeClick(ParentIndexArray[i], true, (i == 0));
	}
	
	// Changecolor
	ColorCurrent(Index);
}

function GetIndex(Id)
{
	var i = 0;
	
	for (i = 0; i < NoNodes; i++)
	{
		if (Ids[i] == Id)
			break;
	}
	
	return ((i == NoNodes) ? -1 : i);
}

function NodeClick(Index, bIcon, bRedraw)
{
	var Id = Ids[Index];
	var state = States[Index];
	var newState = (state == 0) ? 1 : 0;
	var newChildVisible = (newState == 0) ? 0 : 1;
	var lastDescendant = -1;
	var i = 0;
	var j = 0;
  
	//if (Index)
	//  SelectedNode = Index;
	
	if (bIcon == true || Id.indexOf("LINK") == -1)
	{
		// Clicked on Icon find last descendant
		for (i = Index + 1; i < NoNodes; i++)
		{
			// when indent of node is equal or greater than
			// original node indent you know it is not a child
			if (Level[i] <= Level[Index])  
				break;
			lastDescendant = i;
		}
		
		if (lastDescendant >= 0)
		{
			// change visibility of decendants
			for (j = Index + 1; j <= lastDescendant; j++)
			{
				if ((newState == 0) || (Parents[j] == Id))
				{
					Visible[j] = newChildVisible;
					States[j] = 0;
					if (isIE)
					{
						if (IsLeaf(j) == false)
							document.images[j].src = FolderImages[0].src;
						
						eval("Tab" + j).style.display = (newChildVisible == 1) ? "inline" : "none";
					}
				}
			}
		
			// change state
			States[Index] = newState;
		
			// change gif
			if (isIE && (IsLink(Index) == false))
				document.images[Index].src = FolderImages[newState].src;
		}
		
		// Redraw for netscape
		if (isNav && bRedraw)
			document.location.reload();
	}
	// Clicked on Node
  if (Index >= 0)
	{
	  var sTarget = Targets[Index];
		parent.frmContent.location = sTarget;
	}
}

function CollapseAll()
{
	var i = 0;
	var bChanged = false;
	
	for (i = 0; i < NoNodes; i++)
	{
		if (Level[i] > 0)
		{
			if (Visible[i] == 1)
			{
				Visible[i] = 0;
				States[i] = 0;
				
				if(isIE)
					eval("Tab" + i).style.display = "none";
					
				bChanged = true;
			}
		}
		else
		{
			if (States[i] == 1)
			{
				States[i] = 0;
				if (isIE && (IsLink(i) == false))
					document.images[i + 2].src = FolderImages[0].src;
					
				bChanged = true;
			}
			
		}
	}
	
	if (isNav && bChanged)
		document.location.reload();
}
function ExpandAll()
{
	var i = 0;
	var bChanged = false;
	
	for (i = 0; i < NoNodes; i++)
	{
		if ((Visible[i] == 0) || (States[i] == 0))
		{
			Visible[i] = 1;
			States[i] = 1;
			
			if(isIE)
			{
				eval("Tab" + i).style.display = "inline";
				if (IsLink(i) == false)
					document.images[i + 2].src = FolderImages[1].src;
			}
					
			bChanged = true;
		}
	}
	
	if (isNav && bChanged)
		document.location.reload();
}

function InitView()
{
	var Index = top.GetCurrentIndex();

	// Only performe once when parent (=Application reloads)
	
	if (parent.bApplicationReload)
	{
		Index = (Index == -1) ? 0 : Index;
		NodeClick(Index, false, false);
		
		parent.bApplicationReload = false;
	}
	else
	{
		ColorCurrent(Index);
	}
}

function AddNode(Id,label,parent,link)
{
	Ids[NoNodes]     = Id;
	Lbls[NoNodes]    = label;
	Targets[NoNodes] = link;
	Parents[NoNodes] = (parent == -1) ? "ROOT": parent;
	var level = (GetIndex(parent) != -1) ? Level[GetIndex(parent)] : -1;
	Level[NoNodes] = (parent == -1) ? 0 : level+1; 
	Visible[NoNodes] = (parent == -1) ? 1 : 0;

	NoNodes++;
}

function MakeTree()
{
	var i;
	var j;
	var sInd;
	var sNode;
	var ImageCount = 0;
	
	document.writeln("<TABLE BORDER='0' CELLSPACING='0' CELLPADDING='0' WIDTH='400'");
	document.writeln("<TR><TD>&nbsp;</TD></TR>");
	document.writeln("<TR><TD>");
	
	sNode = "";
	for (i = 0; i < NoNodes; i++)
	{	
		if (isNav && (Visible[i] == 0))
		{
			// Do not show for navigator when invisible
			States[i] = 0;
			DocImageNbr[i] = -1;
		}
		else
		{
			DocImageNbr[i] = ImageCount++;
			
			if (isIE)
				sNode = sNode + "<DIV ID='Tab" + i + "' STYLE = 'display: " + ((Visible[i] == 1) ? "inline" : "none" ) + "'>";
				
			sNode = sNode + "<TABLE BORDER='0' CELLSPACING='0' CELLPADDING='0'>";
			sNode = sNode + "<TR><TD ALIGN='LEFT' NOWRAP CLASS='menucell'>";
		
			sInd = "&nbsp;";
			for (j = 0; j < Level[i]; j++)
			{
				sInd = sInd + "&nbsp;&nbsp;&nbsp;&nbsp;";
			}
			sNode = sNode + sInd;
			if (IsLeaf(i) == true)
			{
				sNode = sNode + "<IMG SRC='"+linkIcon+"' BORDER='0' />&nbsp;";
			}
			else
			{
				sNode = sNode + "<A CLASS='sidemenuHOn' HREF='JAVASCRIPT:NodeClick(" + i + ", true, true);'>";
				if ( (i < NoNodes - 1) && (Parents[i+1] == Ids[i]) && (Visible[i+1] == 1) ) 
				{
					States[i] = 1;
					sNode = sNode + "<IMG SRC='" + expandedIcon + "' BORDER='0' />&nbsp;</A>";
				}
				else
				{
					States[i] = 0;
					sNode = sNode + "<IMG SRC='" + collapsedIcon + "' BORDER='0' />&nbsp;</A>";
				}
			}
		
			sNode = sNode + "</TD><TD VALIGN='TOP' NOWRAP>";
		
			sNode = sNode + "<A CLASS='sidemenuHOn' HREF='JAVASCRIPT:NodeClick(" + i + ", true, true);' ID='Node" + i + "'>";
			sNode = sNode + unescape(Lbls[i]);
			sNode = sNode + "</A>";
		
			sNode = sNode + "</TD></TR>";
			sNode = sNode + "</TABLE>";
		  
			if (isIE)
				sNode = sNode + "</DIV>";
		
			if (i % 50 == 0)
			{
				document.writeln(sNode);
				sNode = "";
			}
		}
	}
	document.writeln(sNode);
	
	document.writeln("</TD></TR>");
	document.writeln("</TABLE>");

	// Highlight current node
	//eval("Node" + SelectedNode).className = "HighLight";
	
	document.close();
}

MakeTree();