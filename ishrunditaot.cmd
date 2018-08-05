@ECHO OFF
ECHO *********************************
ECHO ISHRUNDITAOT.CMD
ECHO *********************************

@ECHO OFF
REM ishrunditaot.cmd is called from the IshRunDITAOT publishpostprocess plugin
REM %1=MapFileLocation
REM %2=OutputFolder
REM %3=TempFolder
REM %4=LogFileLocation
REM %5=DITAOTTransType (e.g. ishditadelivery)
REM %6=DraftComments (yes/no)
REM %7=Compare (yes/no)
REM %8=CombinedLanguages (yes/no)
REM %9=PublishPostProcessContextFileLocation

ECHO;
ECHO;

@ECHO OFF
CALL config.cmd
@ECHO OFF
CALL config.custom.cmd
@ECHO OFF

ECHO; 
ECHO;

IF %7==yes (
	REM If "Compare=yes" set validate to "no" as the input files for DITA-OT contains the comparison result and may not be valid DITA anymore
	ECHO Running command "ant -Dtranstype=%5 -Dargs.input=%1 -Doutput.dir=%2 -Ddita.temp.dir=%3 -Dargs.draft=%6 -Dclean.temp=no -Dvalidate=no -logfile %4"
	"ant" -Dtranstype=%5 -Dargs.input=%1 -Doutput.dir=%2 -Ddita.temp.dir=%3 -Dargs.draft=%6 -Dclean.temp=no -Dvalidate=no -logfile %4
) ELSE (
	REM If "Compare<>yes" set validate to "yes" as the input files for DITA-OT should contain valid DITA xml
	ECHO Running command "ant -Dtranstype=%5 -Dargs.input=%1 -Doutput.dir=%2 -Ddita.temp.dir=%3 -Dargs.draft=%6 -Dclean.temp=no -Dvalidate=yes -logfile %4"
	"ant" -Dtranstype=%5 -Dargs.input=%1 -Doutput.dir=%2 -Ddita.temp.dir=%3 -Dargs.draft=%6 -Dclean.temp=no -Dvalidate=yes -logfile %4
)
ECHO *********************************
ECHO ON
EXIT