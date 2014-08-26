WinForensicSuite_v1.0
=====================

Basic information recolection batch script to retrieve information of a possibly infected Window machine

This scipt retrieves information of a possibly infected Windows machine with the __native Windows tools__ and with 
a little help of __external third party tools__ to detect possible rootkits (gmer, catchme.exe, mrb.exe, etc...) along 
with a memory dump with dumpit.exe to further analyze later and take the decision about if this Windows box needs a real
forensic process or not.

This batch script has to be executed with administrator privileges.

The output of this script would be like this:

```
C:\>cd C:\Users\fmt\Tools\Forensics\ForensicSuite_v1.0
C:\Users\fmt\Tools\Forensics\ForensicSuite_v1.0>forense.basico.server.bat
#############################################
#      USUARIO ADMINISTRADOR DETECTADO      #
#############################################
Creando carpeta "audit.results"
Creando carpeta "audit.results"/registry
Creando carpeta "audit.results"/memdump
Creando carpeta "audit.results"/networkdump
Creando carpeta "audit.results"/eventlog
Obteniendo systeminfo del servidor. Sea paciente...
Obteniendo listado de interfaces del servidor...
Obteniendo un listado de procesos ejecutandose actualmente...
Obteniendo el listado de servicios en ejecucion...
Obteniendo el listado de conexiones NetBIOS...
Obteniendo los programas/procesos que se inician al arrancar el servidor...
ERROR: El sistema no ha podido encontrar la clave o el valor del Registro
especificados.
ERROR: El sistema no ha podido encontrar la clave o el valor del Registro
especificados.
Obteniendo los drivers instalados y firmados en el equipo...
Obteniendo las rutas de la tabla de enrutamiento...
Obteniendo las conexiones actuales del servidor...
Obteniendo la configuraci¾n del firewall de Windows:
Obteniendo listado de tareas programadas...
Obteniendo listado de Usuarios y Administradores...
Error de sistema 1376.

El grupo local especificado no existe.

Obteniendo programas instalados en el equipo...
Nombre de archivo no válido.
Obteniendo nivel de parcheado del servidor...
Nombre de archivo no válido.
Obteniendo registro de windows...
La operación se completó correctamente.
La operación se completó correctamente.
La operación se completó correctamente.
La operación se completó correctamente.
La operación se completó correctamente.
Listando directorios compartidos en el servidor...
Buscando rootkits con detector rkr (No se eliminaran '/scanonly'
Rootkit Remover v0.8.9.171 [Feb 11 2014 - 16:35:32]
McAfee Labs.

Windows build 6.1.7601 x64 Service Pack 1
    Switching to ScanOnly Mode
Checking for updates ...
Updated version is available: v0.8.9.174


Scanning for user-mode threats ...

Saltamos paso de deteccion de rootkits con rkr
Volcando el log de eventos del sistema de los ultimos 14 dias

PsLoglist v2.71 - local and remote event log viewer
Copyright (C) 2000-2009 Mark Russinovich
Sysinternals - www.sysinternals.com

Volcando el log de eventos de aplicacion de los ultimos 14 dias

PsLoglist v2.71 - local and remote event log viewer
Copyright (C) 2000-2009 Mark Russinovich
Sysinternals - www.sysinternals.com

Volcando el log de eventos de seguridad de los ultimos 14 dias

PsLoglist v2.71 - local and remote event log viewer
Copyright (C) 2000-2009 Mark Russinovich
Sysinternals - www.sysinternals.com

Si quieres volcarlos en formato importable deberas hacerlo a mano invocando a eventvwr.msc
Buscando rootkits con gmer
Cuando termine el escaneo con gmer, guarda manualmente el fichero de resultados en "audit.results"
Buscando rootkits en MBR con mbr.exe
Buscando rootkits en procesos, servicios y autostart entries con catchme.exe
Iniciando volcado de memoria con DumpIt...
  DumpIt - v1.3.2.20110401 - One click memory memory dumper
  Copyright (c) 2007 - 2011, Matthieu Suiche <http://www.msuiche.net>
  Copyright (c) 2010 - 2011, MoonSols <http://www.moonsols.com>


    Address space size:        5360320512 bytes (   5112 Mb)
    Free space size:          31384100864 bytes (  29930 Mb)

    * Destination = \??\C:\Users\ffmt\Tools\Forensics\ForensicSuite_v1.0\PORFMT-20140826-162129.raw

    --> Are you sure you want to continue? [y/n] y

Volcado finalizado. Moviendolo a directorio ../"audit.results"/memdump
Comprimiendo la carpeta de resultados. Puede tardar bastantes minutos, espere...

7-Zip (A) 9.20  Copyright (c) 1999-2010 Igor Pavlov  2010-11-18
Scanning

Creating archive 20140826_Evidencias_PORFFMT.7z

Compressing  audit.results\administradores.PORFMT.txt
Compressing  audit.results\eventlog\application.evt.txt
Compressing  audit.results\conexiones.NetBIOS.PORFMT.txt
Compressing  audit.results\drivers.PORFMT.txt
Compressing  audit.results\firewall.naob.PORFMT.txt
Compressing  audit.results\interfaces.PORFMT.txt
Compressing  audit.results\netstat.naob.PORFMT.txt
Compressing  audit.results\procesos.y.servicios.PORFMT.txt
Compressing  audit.results\process.list.PORFMT.txt
Compressing  audit.results\rutas.PORFMT.txt
Compressing  audit.results\eventlog\security.evt.txt
Compressing  audit.results\servicios.PORFMT.txt
Compressing  audit.results\shares.PORFMT.txt
Compressing  audit.results\startup.programs.PORFMT.txt
Compressing  audit.results\eventlog\system.evt.txt
Compressing  audit.results\systeminfoPORFMT.txt
Compressing  audit.results\tareas.PORFMT.txt
Compressing  audit.results\tasklist.PORFMT.txt
Compressing  audit.results\usuarios.PORFMT.txt
Compressing  audit.results\wmic.startup.txt
Compressing  audit.results\registry\HKCC.PORFMT.reg
Compressing  audit.results\registry\HKCR.PORFMT.reg
Compressing  audit.results\registry\HKCU.PORFMT.reg
Compressing  audit.results\registry\HKLM.PORFMT.reg
Compressing  audit.results\registry\HKU.PORFMT.reg
Compressing  audit.results\RootkitRemover_20140826_181926.log

Everything is Ok
ECHO está desactivado.
"Finalizado. Por favor, suba el fichero 20140826_Evidencias_PORFMT.7z a "https://ydray.com""
Presione una tecla para continuar . . .
```

