@ECHO OFF
CALL config.cmd
@ECHO OFF
CALL config.custom.cmd
@ECHO OFF

PUSHD %PS_DITAOT%

REM %8 contains the runintegrator value
CALL dita-ot-build.cmd %9

ECHO ********************************************************************************
ECHO GENERATING REQUESTED OUTPUT (PDF2) USING DITA OPEN TOOLKIT
ECHO ********************************************************************************

REM "%JAVA_HOME%\bin\java" -jar lib/dost.jar /id:"%1" /tempdir:"%1/temp" /i:"%1/%2" /outdir:"%3" /draft:"%5" /filter:"%1\context.ditaval" /copycss:yes /transtype:"%4" /cleantemp:"%6" /validate:"%7"

REM -Ddita.input.valfile=%1\context.ditaval

IF %8=="" (
echo NO CUSTOMIZATION DIR SPECIFIED
"ant" -Dtranstype=%4 -Dargs.input=%1/%2 -Doutput.dir=%3 -Ddita.temp.dir=%1/temp -Dargs.draft=%5 -Dclean.temp=%6 -Dvalidate=%7 -Dargs.logdir=%3 -logfile %3/%2_%4.log
) ELSE (
echo CUSTOMIZATION DIR [ %8 ] SPECIFIED
"ant" -Dtranstype=%4 -Dargs.input=%1/%2 -Doutput.dir=%3 -Ddita.temp.dir=%1/temp -Dargs.draft=%5 -Dclean.temp=%6 -Dvalidate=%7 -Dcustomization.dir=%8 -Dargs.logdir=%3 -logfile %3/%2_%4.log
)


ECHO ********************************************************************************
POPD
ECHO ON
EXIT