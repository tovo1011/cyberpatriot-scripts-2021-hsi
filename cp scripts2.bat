@echo off
setlocal enabledelayedexpansion
net session
title CPscripts HSISL
color 0A
 
 
:menu
	echo "1)enable and reset firewall"
	echo "2)Disable services"
	echo "3)password policy"
	echo "4)lockout policy"
	echo "5)security options"
	set /p response=Please choose an option: 
		if %response% == "1" goto :firewall
		if %response% == "2" goto :disableservices
		if %response% == "3" goto :passwordpol
		if %response% == "4" goto :lockoutpol
		if %response% == "5" goto :securityOptions
	
	pause
		

:firewall
	REM Firewall stuffs
	netsh advfirewall set allprofiles state on
	netsh advfirewall reset
	
	pause
	goto :menu

:disableservices
	REM Services to turn off
	echo Disabling services
	sc stop TapiSrv
	sc config TapiSrv start= disabled
	sc stop TlntSvr
	sc config TlntSvr start= disabled
	sc stop ftpsvc
	sc config ftpsvc start= disabled
	sc stop SNMP
	sc config SNMP start= disabled
	sc stop SessionEnv
	sc config SessionEnv start= disabled
	sc stop TermService
	sc config TermService start= disabled
	sc stop UmRdpService
	sc config UmRdpService start= disabled
	sc stop SharedAccess
	sc config SharedAccess start= disabled
	sc stop remoteRegistry 
	sc config remoteRegistry start= disabled
	sc stop SSDPSRV
	sc config SSDPSRV start= disabled
	sc stop W3SVC
	sc config W3SVC start= disabled
	sc stop SNMPTRAP
	sc config SNMPTRAP start= disabled
	sc stop remoteAccess
	sc config remoteAccess start= disabled
	sc stop RpcSs
	sc config RpcSs start= disabled
	sc stop HomeGroupProvider
	sc config HomeGroupProvider start= disabled
	sc stop HomeGroupListener
	sc config HomeGroupListener start= disabled
	sc stop msftpsvc
	sc config msftpsvc start= disabled
	
	pause
	goto :menu
	
:passwordpol
	REM setting password lockout policy
	REM setting complexity
	echo setting password policy
	net accounts /minpwlen:8
	net accounts /maxpwage:60
	net accounts /minpwage:10
	net accounts /uniquepw:3
	
	pause
	goto :menu

:lockoutpol
	REM setting lockout policy
	echo setting lockout policy
	net accounts /lockoutduration:30
	net accounts /lockoutthreshold:3
	net accounts /lockoutwindow:30
	
	pause
	goto :menu

:securityOptions
	echo changing some security options
	
	rem Idle Time Limit - 45 mins
	reg ADD HKLM\SYSTEM\CurrentControlSet\services\LanmanServer\Parameters /v autodisconnect /t REG_DWORD /d 45 /f 
	rem Enable Installer Detection
    reg ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableInstallerDetection /t REG_DWORD /d 1 /f
    rem Restrict Anonymous Enumeration #1
    reg ADD HKLM\SYSTEM\CurrentControlSet\Control\Lsa /v restrictanonymous /t REG_DWORD /d 1 /f 
    rem Restrict Anonymous Enumeration #2
    reg ADD HKLM\SYSTEM\CurrentControlSet\Control\Lsa /v restrictanonymoussam /t REG_DWORD /d 1 /f 
	rem Don't Give  Everyone Permissions
    reg ADD HKLM\SYSTEM\CurrentControlSet\Control\Lsa /v everyoneincludesanonymous /t REG_DWORD /d 0 /f 
	rem SMB Passwords unencrypted to third party
    reg ADD HKLM\SYSTEM\CurrentControlSet\services\LanmanWorkstation\Parameters /v EnablePlainTextPassword /t REG_DWORD /d 0 /f
	rem Restict anonymous access to named pipes and sharesreg ADD HKLM\SYSTEM\CurrentControlSet\services\LanmanServer\Parameters /v NullSessionShares /t REG_MULTI_SZ /d "" /f
	rem Restict anonymous access to named pipes and shares
	reg ADD HKLM\SYSTEM\CurrentControlSet\services\LanmanServer\Parameters /v NullSessionShares /t REG_MULTI_SZ /d "" /f
	
endlocal
	
	
	
	
	
	
