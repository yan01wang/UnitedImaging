@ECHO OFF
CALL config.cmd
@ECHO OFF
CALL config.custom.cmd
@ECHO OFF

PUSHD %PS_DITAOT%

REM %8 contains the runintegrator value
CALL dita-ot-build.cmd %8

ECHO ********************************************************************************
ECHO GENERATING REQUESTED OUTPUT USING DITA OPEN TOOLKIT
ECHO ********************************************************************************

REM "%JAVA_HOME%\bin\java" -jar lib/dost.jar /id:"%1" /tempdir:"%1/temp" /i:"%1/%2" /outdir:"%3" /draft:"%5" /filter:"%1\context.ditaval" /copycss:yes /transtype:"%4" /cleantemp:"%6" /validate:"%7"

REM -Ddita.input.valfile=%1\context.ditaval
"ant" -Dtranstype=%4 -Dargs.input=%1/%2 -Doutput.dir=%3 -Ddita.temp.dir=%1/temp -Dargs.draft=%5 -Dclean.temp=%6 -Dvalidate=%7 -Dargs.logdir=%3 -logfile %3/%2_%4.log


ECHO ********************************************************************************
POPD
ECHO ON
EXIT