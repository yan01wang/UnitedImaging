@ECHO OFF

IF %1=="yes" (
	ECHO ********************************************************************************
	ECHO REBUILD REQUESTED OF DITA OPEN TOOLKIT IN ORDER TO INCLUDED ALL DEFINED PLUGINS
	ECHO ********************************************************************************

	"ant" -f integrator.xml 
		
	ECHO ********************************************************************************	
) ELSE (
	ECHO REBUILD OF DITA OPEN TOOLKIT NOT NEEDED
)	

