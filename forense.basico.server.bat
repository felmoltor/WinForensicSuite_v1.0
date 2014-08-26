@echo off

rem Script Forense (v.1.0)
rem Summary: This script gives you very basic information about a system, this is not a proper forensic investigation, neither BATCH is a proper scripting language. This is just a script to start with when someone need remote help with his computer.
rem Author: Felipe Molina, @felmoltor
rem Creation date: April 2014
rem Changelog:
rem 2014-08-26: Add systeminfo, route info, NetBIOS connections and driverquery commands

rem ============
rem == CONFIG ==
rem ============
rem FLAGS:
set BASICTOOLS=1
set EVTLOGDUMP=1
set DUMPMEMORY=1 
set CAPTURENETTRAFFIC=1
rem http://www.mcafee.com/es/downloads/free-tools/rootkitremover.aspx
set EXEROOTKITRKR=1
rem http://www2.gmer.net/catchme.exe
set EXEROOTKITCATCHME=1
rem http://www2.gmer.net/mbr/mbr.exe
set EXEROOTKITMBR=1
set EXEROOTKITGMER=1
rem set EXEROOTKITSPH=1 rem https://secure2.sophos.com/en-us/products/free-tools/virus-removal-tool/download.aspx

rem DIRECTORIES:
set RESULTDIR="audit.results"
set REGISTRYDIR=%RESULTDIR%/registry
set MEMDUMPDIR=%RESULTDIR%/memdump
rem Necesita tener instalado winpcap http://www.winpcap.org/install/default.htm
set NETDUMPDIR=%RESULTDIR%/networkdump
set EVTDUMPDIR=%RESULTDIR%/eventlog
set TOOLSDIR="Tools"

rem URLS
set UPLOADURL="https://ydray.com"

rem PROGRAM ARGUMENTS
rem psloglist: http://technet.microsoft.com/es-es/sysinternals/bb897544.aspx
set EVTNDAYS=14

rem ============
rem ==  MAIN  ==
rem ============

NET SESSION >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    echo #############################################
    echo #      USUARIO ADMINISTRADOR DETECTADO      #
    echo #############################################
) ELSE (
    echo #############################################
    echo #     USUARIO NO ADMINISTRADOR DETECTADO    #
    echo #############################################
    echo # Se necesitan privilegios de administrador #
    echo # para ejecutar este programa. Saliendo...  #
    echo ############################################# 
	pause
	exit 1
)

set PWD="%cd%"
if %PWD%=="C:\windows\system32" (
	echo No ejecutes este script con el raton. 
    echo Abre una consola y accede a la ruta donde este ejecutable esta localizado.
	exit 1
)

IF NOT EXIST %RESULTDIR% (
	echo Creando carpeta %RESULTDIR%
	mkdir %RESULTDIR%
)
IF NOT EXIST %REGISTRYDIR% (
	echo Creando carpeta %REGISTRYDIR%
	mkdir %REGISTRYDIR%
)
IF NOT EXIST %MEMDUMPDIR% (
	echo Creando carpeta %MEMDUMPDIR%
	mkdir %MEMDUMPDIR%
)
IF NOT EXIST %NETDUMPDIR% (
	echo Creando carpeta %NETDUMPDIR%
	mkdir %NETDUMPDIR%
)
IF NOT EXIST %EVTDUMPDIR% (
	echo Creando carpeta %EVTDUMPDIR%
	mkdir %EVTDUMPDIR%
)

IF %BASICTOOLS%==1 (
	echo Obteniendo systeminfo del servidor. Sea paciente...
	systeminfo > %RESULTDIR%/systeminfo.%COMPUTERNAME%.txt
	
	echo Obteniendo listado de interfaces del servidor...
	netsh int ip show config > %RESULTDIR%/interfaces.%COMPUTERNAME%.txt

	echo Obteniendo un listado de procesos ejecutandose actualmente...
	rem TODO: Copiar los ejecutables que arrancan los procesos a una carpeta para su posterior analisis.
	tasklist > %RESULTDIR%/tasklist.%COMPUTERNAME%.txt
	wmic process list full > %RESULTDIR%/process.list.%COMPUTERNAME%.txt

	echo Obteniendo el listado de servicios en ejecucion...
	sc query > %RESULTDIR%/servicios.%COMPUTERNAME%.txt
	tasklist /svc > %RESULTDIR%/procesos.y.servicios.%COMPUTERNAME%.txt
	
	echo Obteniendo el listado de conexiones NetBIOS...
	nbtstat -s > %RESULTDIR%/conexiones.NetBIOS.%COMPUTERNAME%.txt

	echo Obteniendo los programas/procesos que se inician al arrancar el servidor...
	reg query HKLM\Software\Microsoft\Windows\CurrentVersion\Run > %RESULTDIR%/startup.programs.%COMPUTERNAME%.txt
	reg query HKLM\Software\Microsoft\Windows\CurrentVersion\Runonce >> %RESULTDIR%/startup.programs.%COMPUTERNAME%.txt
	reg query HKLM\Software\Microsoft\Windows\CurrentVersion\RunonceEx >> %RESULTDIR%/startup.programs.%COMPUTERNAME%.txt 
	reg query HKLM\Software\Microsoft\Windows\CurrentVersion\Run >> %RESULTDIR%/startup.programs.%COMPUTERNAME%.txt 
	reg query HKLM\Software\Microsoft\Windows\CurrentVersion\Runonce >> %RESULTDIR%/startup.programs.%COMPUTERNAME%.txt 
	reg query HKLM\Software\Microsoft\Windows\CurrentVersion\RunonceEx >> %RESULTDIR%/startup.programs.%COMPUTERNAME%.txt 

	echo Obteniendo los drivers instalados y firmados en el equipo...
	driverquery /v > %RESULTDIR%/drivers.%COMPUTERNAME%.txt
	echo ========================================= >> %RESULTDIR%/drivers.%COMPUTERNAME%.txt
	echo ========= SIGNATURES INFORMATION ======== >> %RESULTDIR%/drivers.%COMPUTERNAME%.txt
	echo ========================================= >> %RESULTDIR%/drivers.%COMPUTERNAME%.txt
	driverquery /si >> %RESULTDIR%/drivers.%COMPUTERNAME%.txt
	
	echo Obteniendo las rutas de la tabla de enrutamiento...
	netstat -r -n > %RESULTDIR%/rutas.%COMPUTERNAME%.txt
	
	echo Obteniendo las conexiones actuales del servidor...
	netstat -naob > %RESULTDIR%/netstat.naob.%COMPUTERNAME%.txt 

	echo Obteniendo la configuración del firewall de Windows:
	netsh firewall show config > %RESULTDIR%/firewall.naob.%COMPUTERNAME%.txt

	echo Obteniendo listado de tareas programadas...
	rem TODO: Copiar los ejecutables que se arrancan al inicio a una carpeta para su posterior analisis.
	schtasks > %RESULTDIR%/tareas.%COMPUTERNAME%.txt
	wmic startup list full  > %RESULTDIR%/wmic.startup.txt

	echo Obteniendo listado de Usuarios y Administradores...
	rem TODO: Add more information of the users (locked, not locked, password expires, etc)
	net user > %RESULTDIR%/usuarios.%COMPUTERNAME%.txt
	net localgroup administrators > %RESULTDIR%/administrators.%COMPUTERNAME%.txt
	net localgroup administradores > %RESULTDIR%/administradores.%COMPUTERNAME%.txt

	echo Obteniendo programas instalados en el equipo...
	wmic /output:%RESULTDIR%/programas.instalados.%COMPUTERNAME%.csv product get /format:csv 

	echo Obteniendo nivel de parcheado del servidor...
	wmic /output:%RESULTDIR%/installed.updates.%COMPUTERNAME%.csv qfe get /format:csv

	echo Obteniendo registro de windows... 
	reg export "HKLM" "%REGISTRYDIR%/HKLM.%COMPUTERNAME%.reg" /y
	reg export "HKCU" "%REGISTRYDIR%/HKCU.%COMPUTERNAME%.reg" /y
	reg export "HKCC" "%REGISTRYDIR%/HKCC.%COMPUTERNAME%.reg" /y
	reg export "HKCR" "%REGISTRYDIR%/HKCR.%COMPUTERNAME%.reg" /y
	reg export "HKU" "%REGISTRYDIR%/HKU.%COMPUTERNAME%.reg" /y

	echo Listando directorios compartidos en el servidor...
	wmic share list brief > %RESULTDIR%/shares.%COMPUTERNAME%.txt

) ELSE (
	echo No se realizan las pruebas basicas con las herramientas de Windows
)

IF %EXEROOTKITRKR%==1 (
	echo Buscando rootkits con detector rkr (No se eliminaran '/scanonly')
	%TOOLSDIR%\rkr.exe /log %RESULTDIR% /scanonly
) ELSE (
	echo Saltamos paso de deteccion de rootkits con rkr
)

IF %EVTLOGDUMP%==1 (
	echo Volcando el log de eventos del sistema de los ultimos %EVTNDAYS% dias
	%TOOLSDIR%\psloglist.exe -d %EVTNDAYS% sys > %EVTDUMPDIR%/system.evt.txt
	echo Volcando el log de eventos de aplicacion de los ultimos %EVTNDAYS% dias
	%TOOLSDIR%\psloglist.exe -d %EVTNDAYS% app > %EVTDUMPDIR%/application.evt.txt
	echo Volcando el log de eventos de seguridad de los ultimos %EVTNDAYS% dias
	%TOOLSDIR%\psloglist.exe -d %EVTNDAYS% sec > %EVTDUMPDIR%/security.evt.txt
	echo Si quieres volcarlos en formato importable deberas hacerlo a mano invocando a eventvwr.msc
) ELSE (
	echo No se ejecuta el volcado de eventos del sistema
)

IF %EXEROOTKITGMER%==1 (
	echo Buscando rootkits con gmer
	echo Cuando termine el escaneo con gmer, guarda manualmente el fichero de resultados en %RESULTDIR%
	%TOOLSDIR%\g.exe
) ELSE (
	echo Saltamos paso de detección de rootkits con gmer
)

rem mbr.exe renamed
IF %EXEROOTKITMBR%==1 (
	echo Buscando rootkits en MBR con mbr.exe
	%TOOLSDIR%\m.exe -l ../%RESULTDIR%/mbr.log
) ELSE (
	echo Saltamos paso de detección de rootkits con mbr.exe
)

rem catchme.exe renamed
IF %EXEROOTKITCATCHME%==1 (
	echo Buscando rootkits en procesos, servicios y autostart entries con catchme.exe
	%TOOLSDIR%\cthme.exe -l ../%RESULTDIR%/catchme.log	
) ELSE (
	echo Saltamos paso de detección de rootkits con catchme.exe
)

rem dumpit.exe renamed
IF %DUMPMEMORY%==1 (
	echo Iniciando volcado de memoria con DumpIt...
	%TOOLSDIR%\dpit.exe
	echo Volcado finalizado. Moviendolo a directorio ../%MEMDUMPDIR%
	move /y *.raw ../%MEMDUMPDIR%
) ELSE (
	echo Saltamos paso de volcado de memoria con DumpIt
)

echo Comprimiendo la carpeta de resultados. Puede tardar bastantes minutos, espere...
%TOOLSDIR%\7za.exe a %date:~6,4%%date:~3,2%%date:~0,2%_Evidencias_%COMPUTERNAME%.7z %RESULTDIR%/*

echo ""
echo "Finalizado. Por favor, suba el fichero %date:~6,4%%date:~3,2%%date:~0,2%_Evidencias_%COMPUTERNAME%.7z a %UPLOADURL%"
explorer %UPLOADURL%
explorer .
pause
