$ErrorActionPreference = 'SilentlyContinue'

#----- LOCK OUT Administrator from that which was set on yaml / Instructor ACCESS ONLY ---
net user Administrator ReallyStrongPassword!!
Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\winlogon" -Name "DefaultPassword" -PropertyType String -Value 'ReallyStrongPassword!!'

#----- OUs ---
dsadd ou "OU=WARRIORS,DC=army,DC=warriors"
dsadd ou "OU=Apprent1ce,OU=WARRIORS,DC=army,DC=warriors"
dsadd ou "OU=Fight3r,OU=WARRIORS,DC=army,DC=warriors"
dsadd ou "OU=Paladin,OU=WARRIORS,DC=army,DC=warriors"
dsadd ou "OU=Wizard,OU=WARRIORS,DC=army,DC=warriors"
dsadd ou "OU=OSsassin,OU=WARRIORS,DC=army,DC=warriors"
dsadd ou "OU=SYNmurai,OU=WARRIORS,DC=army,DC=warriors"

#----- Security Groups ---
dsadd group "CN=Apprent1ce5,CN=Users,DC=army,DC=warriors" -secgrp yes -scope u -desc "Apprent1ce"
dsadd group "CN=Fight3r5,CN=Users,DC=army,DC=warriors" -secgrp yes -scope g -desc "Fight3r" -memberof "CN=Apprent1ce5,CN=Users,DC=army,DC=warriors"
dsadd group "CN=Paladin5,CN=Users,DC=army,DC=warriors" -secgrp yes -scope g -desc "Paladin" -memberof "CN=Fight3r5,CN=Users,DC=army,DC=warriors"
dsadd group "CN=Wizard5,CN=Users,DC=army,DC=warriors" -secgrp yes -scope g -desc "Wizard" -memberof "CN=Paladin5,CN=Users,DC=army,DC=warriorss"
dsadd group "CN=OSsassin5,CN=Users,DC=army,DC=warriors" -secgrp yes -scope g -desc "OSsassin" -memberof "CN=Wizard5,CN=Users,DC=army,DC=warriors"
dsadd group "CN=SYNmurai5,CN=Users,DC=army,DC=warriors" -secgrp yes -scope g -desc "SYNmurai" -memberof "CN=OSsassin5,CN=Users,DC=army,DC=warriors"
dsadd group "CN=Rang3r5,CN=Users,DC=army,DC=warriors" -secgrp yes -scope g -desc "Rang3r" -memberof "CN=SYNmurai5,CN=Users,DC=army,DC=warriors"
dsadd group "CN=C0deSling3r5,CN=Users,DC=army,DC=warriors" -secgrp yes -scope g -desc "C0deSling3r" -memberof "CN=SYNmurai5,CN=Users,DC=army,DC=warriors"
dsadd group "CN=M45T3R5,CN=Users,DC=army,DC=warriors" -secgrp yes -scope g -desc "M45T3R" -memberof "CN=SYNmurai5,CN=Users,DC=army,DC=warriors"


#----- Share Drive Setup ---

#----- Creates Share Folders for all Levels ---  10990 folders
set-variable -name ROOT -value "C:\share"
set-variable -name TOP -value "WARRIORS"
new-item -ItemType Directory -Path "$ROOT\$TOP\" -Force

$CLASSES = @("Apprent1ce","Fight3r","Paladin","Wizard","OSsassin","SYNmurai","M45T3R","Rang3r","C0deSling3r")
$1STFOLDER = @("1","2","3","4","5","6","7","8","9","10")
$2NDFOLDER = @("10","9","8","7","6","5","4","3","2","1")
$3RDFOLDER = @("1","2","3","4","5","6","7","8","9","10")
$4THFOLDER = @("10","9","8","7","6","5","4","3","2","1")

foreach ($CLASS in $CLASSES) {
	echo $CLASS
	foreach ($3RD in $3RDFOLDER) {
		echo $3RD
		foreach ($2ND in $2NDFOLDER) {
			echo $2ND
			foreach ($1ST in $1STFOLDER) {
				new-item -ItemType Directory -Path "$ROOT\$TOP\$CLASS\$3RD\HOME\$2ND\HOME\$1ST" -Force
			}
		}
	}
}

   
    foreach ($4TH in $4THFOLDER) {
        echo $4TH
        foreach ($3RD in $3RDFOLDER) {
            new-item -ItemType Directory -Path "$CLASS\$1ST\$4TH\$3RD"
            }
        }
start-sleep -s 1
	
# ----- creates SMB share for folders created above ---
new-SMBshare -path "C:\share" `
-Name "The Share" `
-Desc "A Share Drive"

Add-NTFSAccess -Path C:\share -Account 'Everyone' -AccessRights Read

icacls "C:\share\WARRIORS" /grant Everyone:R /C
icacls "C:\share\WARRIORS\M45T3R" /grant M45T3R:F /T /C
icacls "C:\share\WARRIORS\C0deSling3r" /grant C0deSling3r:F /T /C
icacls "C:\share\WARRIORS\Rang3r" /grant Rang3r:F /T /C
icacls "C:\share\WARRIORS\SYNmurai" /grant SYNmurai5:F /T /C
icacls "C:\share\WARRIORS\OSsassin5" /grant OSsassin5:F /T /C
icacls "C:\share\WARRIORS\Wizard5" /grant Wizard5:F /T /C
icacls "C:\share\WARRIORS\Paladin5" /grant Paladin5:F /T /C
icacls "C:\share\WARRIORS\Fight3r5" /grant Fight3r5:F /T /C
icacls "C:\share\WARRIORS\Apprent1ce5" /grant Apprent1ce5:F /T /C

#----- DISSABLES PASSWORDS COMPLEXITY REQ ---

secedit /export /cfg c:\secpol.cfg
(gc C:\secpol.cfg).replace("PasswordComplexity = 1", "PasswordComplexity = 0") | Out-File C:\secpol.cfg
(gc C:\secpol.cfg).replace("MinimumPasswordLength = 7", "MinimumPasswordLength = 1") | Out-File C:\secpol.cfg
(gc C:\secpol.cfg).replace("SeInteractiveLogonRight = *S-1-5-32-544,*S-1-5-32-548,*S-1-5-32-549,*S-1-5-32-550,*S-1-5-32-551,*S-1-5-9", "SeInteractiveLogonRight = *S-1-5-32-544,*S-1-5-32-548,*S-1-5-32-549,*S-1-5-32-550,*S-1-5-32-551,*S-1-5-9,*S-1-1-0,*S-1-5-11") | Out-File C:\secpol.cfg
secedit /configure /db c:\windows\security\local.sdb /cfg c:\secpol.cfg
rm -force c:\secpol.cfg -confirm:$false

New-ADFineGrainedPasswordPolicy `
-Name "DomainUsersPSO" `
-Precedence 10 `
-ComplexityEnabled $false `
-Description "The Domain Users Password Policy" `
-DisplayName "Domain Users PSO" `
-LockoutDuration "0.12:00:00" `
-LockoutObservationWindow "0.00:15:00" `
-LockoutThreshold 10 `
-MaxPasswordAge "60.00:00:00" `
-MinPasswordAge "1.00:00:00" `
-MinPasswordLength 1 `
-PasswordHistoryCount 24 `
-ReversibleEncryptionEnabled $false
Add-ADFineGrainedPasswordPolicySubject DomainUsersPSO -Subjects 'Domain Users'

#----- Disables Control Panel, Registry.exe GUIs, and Last User Name at login ---
New-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name NoControlPanel -Value 1 -PropertyType DWord | Out-Null
New-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name DisableRegistryTools -Value 1 -PropertyType DWord | Out-Null
Set-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name DontDisplayLastUserName -Value 1

#----- CLreates 50 Domain User Accounts .. 3 hidden ---  all must have default password to be used in follow on psexec for loops

$users1 = @("Apprent1ce01","Apprent1ce02","Apprent1ce03","Apprent1ce04","Apprent1ce05","Apprent1ce06","Apprent1ce07","Apprent1ce08","Apprent1ce09","Apprent1ce10")
foreach ($user in $users1) {
dsadd user "CN=$user,OU=Apprent1ce,OU=WARRIORS,DC=army,DC=warriors" -memberof "CN=Apprent1ce5,CN=Users,DC=army,DC=warriors" -pwd "password" -mustchpwd no -canchpwd yes -pwdneverexpires no -acctexpires "180" -disabled no -reversiblepwd no 
}
start-sleep -s 1

$users2 = @("Fight3r01","Fight3r02","Fight3r03","Fight3r04","Fight3r05","Fight3r06","Fight3r07","Fight3r08","Fight3r09","Fight3r10")
foreach ($user in $users2) {
dsadd user "CN=$user,OU=Fight3r,OU=WARRIORS,DC=army,DC=warriors" -memberof "CN=Fight3r5,CN=Users,DC=army,DC=warriors" -pwd "password" -mustchpwd no -canchpwd yes -pwdneverexpires no -acctexpires "180" -disabled no -reversiblepwd no
}
start-sleep -s 1

$users3 = @("Paladin01","Paladin02","Paladin03","Paladin04","Paladin05","Paladin06","Paladin07","Paladin08","Paladin09","Paladin10")
foreach ($user in $users3) {
dsadd user "CN=$user,OU=Paladin,OU=WARRIORS,DC=army,DC=warriors" -memberof "CN=Paladin5,CN=Users,DC=army,DC=warriors" -pwd "password" -mustchpwd no -canchpwd yes -pwdneverexpires no -acctexpires "180" -disabled no -reversiblepwd no 
}
start-sleep -s 1

$users4 = @("Wizard01","Wizard02","Wizard03","Wizard04","Wizard05","Wizard06","Wizard07","Wizard08","Wizard09","Wizard10")
foreach ($user in $users4) {
dsadd user "CN=$user,OU=Wizard,OU=WARRIORS,DC=army,DC=warriors" -memberof "CN=Wizard5,CN=Users,DC=army,DC=warriors" -pwd "password" -mustchpwd no -canchpwd yes -pwdneverexpires no -acctexpires "180" -disabled no -reversiblepwd no 
}
start-sleep -s 1

$users5 = @("OSsassin01","OSsassin02","OSsassin03","OSsassin04","OSsassin05","OSsassin06","OSsassin07","OSsassin08","OSsassin09")
foreach ($user in $users5) {
dsadd user "CN=$user,OU=OSsassin,OU=WARRIORS,DC=army,DC=warriors" -memberof "CN=OSsassin5,CN=Users,DC=army,DC=warriors" -pwd "password" -mustchpwd no -canchpwd yes -pwdneverexpires no -acctexpires "180" -disabled no -reversiblepwd no
}
start-sleep -s 1

dsadd user "CN=SYNmurai,OU=SYNmurai,OU=WARRIORS,DC=army,DC=warriors" -memberof "CN=SYNmurai5,CN=Users,DC=army,DC=warriors" -pwd "password" -mustchpwd no -canchpwd yes -pwdneverexpires no -acctexpires "180" -disabled no -reversiblepwd no 
dsadd user "CN=Rang3r,OU=SYNmurai,OU=WARRIORS,DC=army,DC=warriors" -memberof "CN=SYNmurai5,CN=Users,DC=army,DC=warriors" -pwd "password" -mustchpwd no -canchpwd yes -pwdneverexpires no -acctexpires "180" -disabled no -reversiblepwd no 
dsadd user "CN=C0deSling3r,OU=SYNmurai,OU=WARRIORS,DC=army,DC=warriors" -memberof "CN=SYNmurai5,CN=Users,DC=army,DC=warriors" -pwd "password" -mustchpwd no -canchpwd yes -pwdneverexpires no -acctexpires "180" -disabled no -reversiblepwd no 
dsadd user "CN=M45T3R,OU=SYNmurai,OU=WARRIORS,DC=army,DC=warriors" -memberof "CN=SYNmurai5,CN=Users,DC=army,DC=warriors" -pwd "password" -mustchpwd no -canchpwd yes -pwdneverexpires no -acctexpires "180" -disabled no -reversiblepwd no

#----- Creates Profiles for Every User/Level in Domain .. to be populated with the follow-on challenges

$users1 = @("Apprent1ce01","Apprent1ce02","Apprent1ce03","Apprent1ce04","Apprent1ce05","Apprent1ce06","Apprent1ce07","Apprent1ce08","Apprent1ce09","Apprent1ce10")
foreach ($user in $users1) {
	psexec -accepteula -u army\$user -p password \\$(hostname) cmd /c "exit" -accepteula -nobanner
}
$users2 = @("Fight3r01","Fight3r02","Fight3r03","Fight3r04","Fight3r05","Fight3r06","Fight3r07","Fight3r08","Fight3r09","Fight3r10")
foreach ($user in $users2) {
	psexec -accepteula -u army\$user -p password \\$(hostname) cmd /c "exit" -accepteula -nobanner
}
$users3 = @("Paladin01","Paladin02","Paladin03","Paladin04","Paladin05","Paladin06","Paladin07","Paladin08","Paladin09","Paladin10")
foreach ($user in $users3) {
	psexec -accepteula -u army\$user -p password \\$(hostname) cmd /c "exit" -accepteula -nobanner
}
$users4 = @("Wizard01","Wizard02","Wizard03","Wizard04","Wizard05","Wizard06","Wizard07","Wizard08","Wizard09","Wizard10")
foreach ($user in $users4) {
	psexec -accepteula -u army\$user -p password \\$(hostname) cmd /c "exit" -accepteula -nobanner
}
$users5 = @("OSsassin01","OSsassin02","OSsassin03","OSsassin04","OSsassin05","OSsassin06","OSsassin07","OSsassin08","OSsassin09")
foreach ($user in $users5) {
	psexec -accepteula -u army\$user -p password \\$(hostname) cmd /c "exit" -accepteula -nobanner
}
$users6 = @("SYNmurai","Rang3r","C0deSling3r","M45T3R")
foreach ($user in $users6) {
	psexec -accepteula -u army\$user -p password \\$(hostname) cmd /c "exit" -accepteula -nobanner
}


#----- Specific Files for each account/level/challenge .. modify domain user accounts with correct challenge "passwords"


dsmod user "CN=Apprent1ce01,OU=Apprent1ce,OU=WARRIORS,DC=army,DC=warriors" -pwd password
	Write-Output "The password for the next level is the Powershell build version." -n > C:\Users\Apprent1ce01\Desktop\challenge.txt
		
dsmod user "CN=Apprent1ce02,OU=Apprent1ce,OU=WARRIORS,DC=army,DC=warriors" -pwd 10.0.14409.1005
	Write-Output "The password for the next level is the short name of the domain in which this server is a part of." -n > C:\Users\Apprent1ce02\Desktop\challenge.txt
	
dsmod user "CN=Apprent1ce03,OU=Apprent1ce,OU=WARRIORS,DC=army,DC=warriors" -pwd army
	Write-Output "The password for the next level is in a readme file somewhere in this user’s profile." -n > C:\Users\Apprent1ce03\Desktop\challenge.txt
	
dsmod user "CN=Apprent1ce04,OU=Apprent1ce,OU=WARRIORS,DC=army,DC=warriors" -pwd 123456
	Write-Output "The password for the next level is in a file in a hidden directory in the root of this user’s profile." -n > C:\Users\Apprent1ce04\Desktop\challenge.txt
	echo "123456" > C:\Users\Apprent1ce03\Favorites\README
	icacls C:\Users\Apprent1ce03 /grant Apprent1ce03:F /T /C

dsmod user "CN=Apprent1ce05,OU=Apprent1ce,OU=WARRIORS,DC=army,DC=warriors" -pwd ketchup
	Write-Output "The password for the next level is in a file in a directory on the desktop with spaces in it." -n > C:\Users\Apprent1ce05\Desktop\challenge.txt
	new-item -ItemType Directory -Path "C:\Users\Apprent1ce04\secretsauce" -Force
	echo "ketchup" > C:\Users\Apprent1ce04\secretsauce\saucey
	attrib +h C:\Users\Apprent1ce04\secretsauce
	icacls C:\Users\Apprent1ce04 /grant Apprent1ce04:F /T /C 
	
dsmod user "CN=Apprent1ce06,OU=Apprent1ce,OU=WARRIORS,DC=army,DC=warriors" -pwd 987654321
	Write-Output "The password for the next level is the manufacturing name of the only USB drive that was plugged into this server at some point." -n > C:\Users\Apprent1ce06\Desktop\challenge.txt
	$dirs = @("1    -     99","100     -     199","a     -      z","z                                                                                                           -                                                                          a")
	foreach ($dir in $dirs) {
		new-item -ItemType Directory -Path C:\Users\Apprent1ce05\Desktop\$dir -Force
		}
	echo "987654321" > "C:\Users\Apprent1ce05\Desktop\z                                                                                                           -                                                                          a\space.txt"
	icacls C:\Users\Apprent1ce05 /grant Apprent1ce05:F /T /C
	
dsmod user "CN=Apprent1ce07,OU=Apprent1ce,OU=WARRIORS,DC=army,DC=warriors" -pwd SanDisk
	Write-Output "The password for the next level is the description of the Lego Land service." -n > C:\Users\Apprent1ce07\Desktop\challenge.txt
	Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\USBSTOR" -Name Start -Value 1 
	New-Item "C:\windows\system32" -ItemType File -Name reg.ps1 -Force
		echo 'New-Item "HKLM:\SYSTEM\CurrentControlSet\Enum" -Name USBSTOR -Force' > "C:\windows\system32\reg.ps1"
			echo 'New-Item "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\Disk_Ven_SanDisk_Prod_Cruzer_Blade_Rev_PMAP\CF52A6CB0" -Name "Device Parameters" -Force' >> "C:\windows\system32\reg.ps1"
			echo 'New-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\Disk_Ven_SanDisk_Prod_Cruzer_Blade_Rev_PMAP\CF52A6CB0" -Name "Capabilities" -Value "0X00000010" -PropertyType DWord | Out-Null' >> "C:\windows\system32\reg.ps1"
			echo 'New-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\Disk_Ven_SanDisk_Prod_Cruzer_Blade_Rev_PMAP\CF52A6CB0" -Name "Class" -Value "DiskDrive" -PropertyType String | Out-Null' >> "C:\windows\system32\reg.ps1"
			echo 'New-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\Disk_Ven_SanDisk_Prod_Cruzer_Blade_Rev_PMAP\CF52A6CB0" -Name "ClassGUID" -Value "{4d36e967-e325-11ce-bfc1-08002be10318}" -PropertyType String | Out-Null' >> "C:\windows\system32\reg.ps1"
			echo 'New-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\Disk_Ven_SanDisk_Prod_Cruzer_Blade_Rev_PMAP\CF52A6CB0" -Name "CompatibleIDs" -Value "USBSTOR\Disk USBSTOR\RAW" -PropertyType MultiString | Out-Null' >> "C:\windows\system32\reg.ps1"
			echo 'New-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\Disk_Ven_SanDisk_Prod_Cruzer_Blade_Rev_PMAP\CF52A6CB0" -Name "ConfigFlags" -Value "0X00000000" -PropertyType DWord | Out-Null' >> "C:\windows\system32\reg.ps1"
			echo 'New-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\Disk_Ven_SanDisk_Prod_Cruzer_Blade_Rev_PMAP\CF52A6CB0" -Name "ContainerID" -Value "{c2dc3c42-a281-557a-a6ed-e607894e99b3}" -PropertyType String | Out-Null' >> "C:\windows\system32\reg.ps1"
			echo 'New-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\Disk_Ven_SanDisk_Prod_Cruzer_Blade_Rev_PMAP\CF52A6CB0" -Name "DeviceDesc" -Value "@disk.inf;%disk_devdesc%;Disk Drive" -PropertyType String | Out-Null' >> "C:\windows\system32\reg.ps1"
			echo 'New-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\Disk_Ven_SanDisk_Prod_Cruzer_Blade_Rev_PMAP\CF52A6CB0" -Name "Driver" -Value "{4d36e967-e325-11ce-bfc1-08002be10318}\0001" -PropertyType String | Out-Null' >> "C:\windows\system32\reg.ps1"
			echo 'New-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\Disk_Ven_SanDisk_Prod_Cruzer_Blade_Rev_PMAP\CF52A6CB0" -Name "FriendlyName" -Value "SanDisk Cruzer Blade USB Device" -PropertyType String | Out-Null' >> "C:\windows\system32\reg.ps1"
			echo 'New-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\Disk_Ven_SanDisk_Prod_Cruzer_Blade_Rev_PMAP\CF52A6CB0" -Name "HardwareID" -Value "USBSTOR\DiskSanDisk_Cruzer_Blade___PMAP USBST..." -PropertyType MultiString | Out-Null' >> "C:\windows\system32\reg.ps1"
			echo 'New-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\Disk_Ven_SanDisk_Prod_Cruzer_Blade_Rev_PMAP\CF52A6CB0" -Name "Mfg" -Value "@disk.inf;%genmanufacturer%;Standard disk drives" -PropertyType String | Out-Null' >> "C:\windows\system32\reg.ps1"
			echo 'New-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\Disk_Ven_SanDisk_Prod_Cruzer_Blade_Rev_PMAP\CF52A6CB0" -Name "Service" -Value "disk" -PropertyType String | Out-Null' >> "C:\windows\system32\reg.ps1"
				echo 'New-Item "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\Disk_Ven_SanDisk_Prod_Cruzer_Blade_Rev_PMAP\CF52A6CB0\Device Parameters" -Name "MediaChangeNotification" -Force' >> "C:\windows\system32\reg.ps1"
				echo 'New-Item "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\Disk_Ven_SanDisk_Prod_Cruzer_Blade_Rev_PMAP\CF52A6CB0\Device Parameters" -Name "Partmgr" -Force' >> "C:\windows\system32\reg.ps1"
					echo 'New-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\Disk_Ven_SanDisk_Prod_Cruzer_Blade_Rev_PMAP\CF52A6CB0\Device Parameters\Partmgr" -Name "Attributes" -Value "0X00000000" -PropertyType DWord | Out-Null' >> "C:\windows\system32\reg.ps1"
					echo 'New-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\Disk_Ven_SanDisk_Prod_Cruzer_Blade_Rev_PMAP\CF52A6CB0\Device Parameters\Partmgr" -Name "DiskId" -Value "{116c15b5-5f04-11e5-9d2b-000c293089ea}" -PropertyType String | Out-Null' >> "C:\windows\system32\reg.ps1"
			echo 'New-Item "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\Disk_Ven_SanDisk_Prod_Cruzer_Blade_Rev_PMAP\CF52A6CB0" -Name "LogConf" -Force' >> "C:\windows\system32\reg.ps1"
			echo 'New-Item "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\Disk_Ven_SanDisk_Prod_Cruzer_Blade_Rev_PMAP\CF52A6CB0" -Name "Properties" -Force' >> "C:\windows\system32\reg.ps1"
		schtasks /create /tn "Reg" /tr "powershell.exe -file C:\windows\system32\reg.ps1" /ru SYSTEM /sc ONCE /st (get-date).AddMinutes(1).ToString("HH:mm") /V1 /z
		# Register-ScheduledJob -Name USB -FilePath  C:\windows\system32\reg.ps1 -RunNow
	    start-sleep -s 1
	
dsmod user "CN=Apprent1ce08,OU=Apprent1ce,OU=WARRIORS,DC=army,DC=warriors" -pwd i_love_legos
	Write-Output "The password for the next level is the number of files in the Videos folder." -n > C:\Users\Apprent1ce08\Desktop\challenge.txt
	new-service LegoLand -Desc "i_love_legos" "C:\windows\system32\notepad.exe"

dsmod user "CN=Apprent1ce09,OU=Apprent1ce,OU=WARRIORS,DC=army,DC=warriors" -pwd 925
	Write-Output "The password for the next level is the number of folders in the Music folder." -n > C:\Users\Apprent1ce09\Desktop\challenge.txt
	0..698 | % { new-item -ItemType File -Path C:\Users\Apprent1ce08\Videos\file$_.txt -Force }
	710..776 | % { new-item -ItemType File -Path C:\Users\Apprent1ce08\Videos\file$_.txt -Force }
	834..991 | % { new-item -ItemType File -Path C:\Users\Apprent1ce08\Videos\file$_.txt -Force }
	new-item -ItemType Directory -Path "C:\Users\Apprent1ce08\Videos" -Force
	new-item -ItemType File -Path "C:\Users\Apprent1ce08\Videos\file1103.txt" -Force
	
dsmod user "CN=Apprent1ce10,OU=Apprent1ce,OU=WARRIORS,DC=army,DC=warriors" -pwd 411
	Write-Output "The password for the next level is the number of words in a file on the desktop." -n > C:\Users\Apprent1ce10\Desktop\challenge.txt
	1..703 | % {if($_ % 2 -eq 1 ) { new-item -ItemType Directory -Path C:\Users\Apprent1ce09\Music\Stevie_Wonder$_ -Force } }
	18..73 | % { new-item -ItemType Directory -Path C:\Users\Apprent1ce09\Music\Teddy_Pendergrass$_ -Force }
	new-item -ItemType Directory -Path "C:\Users\Apprent1ce09\Music\Teddy_Pendergrass" -Force
	new-item -ItemType Directory -Path "C:\Users\Apprent1ce09\Music\Luther Vandros" -Force
	new-item -ItemType Directory -Path "C:\Users\Apprent1ce09\Music\Stevie_Wonder 139" -Force
	icacls C:\Users\Apprent1ce09 /grant Apprent1ce09:F /T /C

dsmod user "CN=Fight3r01,OU=Fight3r,OU=WARRIORS,DC=army,DC=warriors" -pwd 5254
	Write-Output "The password for the next level is the last five digits of the MD5 hash of the hosts file." -n > C:\Users\Fight3r01\Desktop\challenge.txt
	new-item -ItemType Directory -Path "C:\Users\Apprent1ce10\Desktop" -Force
	new-item -ItemType File -Path "C:\Users\Apprent1ce10\Desktop\words.txt" -Force
	function global:GET-8LetterWord() {
	[int32[]]$ArrayofAscii=26,97,26,65,10,48,15,33
	$Complexity=1
	# Complexity:
	# 1 - Pure lowercase ASCII
	# 2 - Mix Uppercase and Lowercase ASCII
	# 3 - ASCII Upper/Lower with Numbers
	# 4 - ASCII Upper/Lower with Numbers and Punctuation
	$WordLength=8
	$NewWord=$NULL
		Foreach ($counter in 1..$WordLength) {
			$pickSet=(GET-Random $complexity)*2
			$NewWord=$NewWord+[char]((get-random $ArrayOfAscii[$pickset])+$ArrayOfAscii[$pickset+1])
		}
	Return $NewWord
	}
	
	foreach ($Counter in 1..5254) { 
	GET-8LetterWord >> C:\Users\Apprent1ce10\Desktop\words.txt 
	}
	icacls C:\Users\Apprent1ce10 /grant Apprent1ce10:F /T /C
	
dsmod user "CN=Fight3r02,OU=Fight3r,OU=WARRIORS,DC=army,DC=warriors" -pwd 7566D
	Write-Output "The password for the next level is the number of times 'gaab' is listed in the file on the desktop." -n > C:\Users\Fight3r02\Desktop\challenge.txt
	# no prep necessary

dsmod user "CN=Fight3r03,OU=Fight3r,OU=WARRIORS,DC=army,DC=warriors" -pwd 1
	Write-Output "The password for the next level is the number of words with 'az', in the word, in the file on the desktop." -n > C:\Users\Fight3r03\Desktop\challenge.txt
	$AA = [char[]]([char]'a'..[char]'z')
	$BB = [char[]]([char]'a'..[char]'z')
	$CC = [char[]]([char]'a'..[char]'z')
	$DD = [char[]]([char]'a'..[char]'z')
	$(foreach ($A in $AA) {
		"$A"
	}) > C:\Users\Fight3r02\Desktop\words.txt
	
	$(foreach ($A in $AA) {
		foreach ($B in $BB) {
			"$A$B"
		}
	}) >> C:\Users\Fight3r02\Desktop\words.txt
	
	$(foreach ($A in $AA) {
		foreach ($B in $BB) {
			foreach ($C in $CC) {
				"$A$B$C"
			}
		}
	}) >> C:\Users\Fight3r02\Desktop\words.txt
	
	$(foreach ($A in $AA) {
		foreach ($B in $BB) {
			foreach ($C in $CC) {
				foreach ($D in $DD) {
					"$A$B$C$D"
				}
			}
		}
	}) >> C:\Users\Fight3r02\Desktop\words.txt
	icacls C:\Users\Fight3r02\Desktop /grant Fight3r02:F /T /C
	
dsmod user "CN=Fight3r04,OU=Fight3r,OU=WARRIORS,DC=army,DC=warriors" -pwd 2081
	Write-Output "The password for the next level is the number of words with either 'a' OR 'z', in the word, in the file on the desktop." -n > C:\Users\Fight3r04\Desktop\challenge.txt
	new-item -ItemType Directory -Path "C:\Users\Fight3r02\Desktop" -Force
	copy-item C:\Users\Fight3r02\Desktop\words.txt C:\Users\Fight3r03\Desktop\
	icacls C:\Users\Fight3r03 /grant Fight3r03:F /T /C

dsmod user "CN=Fight3r05,OU=Fight3r,OU=WARRIORS,DC=army,DC=warriors" -pwd 144770
	Write-Output "The password for the next level is the number of words meeting the following criteria in the file on the desktop CRITERIA - 'a' appears at least twice, followed by either an a, b, c . .  OR g" -n > C:\Users\Fight3r05\Desktop\challenge.txt
	new-item -ItemType Directory -Path "C:\Users\Fight3r02\Desktop" -Force
	copy-item C:\Users\Fight3r02\Desktop\words.txt C:\Users\Fight3r04\Desktop\
	icacls C:\Users\Fight3r04 /grant Fight3r04:F /T /C
	
dsmod user "CN=Fight3r06,OU=Fight3r,OU=WARRIORS,DC=army,DC=warriors" -pwd 364
	Write-Output "The password for the next level is the number of unique words in the file on the desktop." -n > C:\Users\Fight3r06\Desktop\challenge.txt
	new-item -ItemType Directory -Path "C:\Users\Fight3r02\Desktop" -Force
	copy-item C:\Users\Fight3r02\Desktop\words.txt C:\Users\Fight3r05\Desktop\
	icacls C:\Users\Fight3r05 /grant Fight3r05:F /T /C
	
dsmod user "CN=Fight3r07,OU=Fight3r,OU=WARRIORS,DC=army,DC=warriors" -pwd 456976
	Write-Output "The password for the next level is the only line that makes the two files in the Downloads folder different." -n > C:\Users\Fight3r07\Desktop\challenge.txt
	new-item -ItemType Directory -Path "C:\Users\Fight3r06\Desktop" -Force
	$AA = [char[]]([char]'a'..[char]'z')
	$BB = [char[]]([char]'A'..[char]'Z')
	$CC = [char[]]([char]'a'..[char]'z')
	$DD = [char[]]([char]'A'..[char]'Z')
	$(foreach ($A in $AA) {
		foreach ($B in $BB) {
			foreach ($C in $CC) {
				foreach ($D in $DD) {
					"$B$A$D$C"
				}
			}
		}
	}) >> C:\Users\Fight3r06\Desktop\words.txt
	start-sleep -s 1
	$EE = [char[]]([char]'A'..[char]'Z')
	$FF = [char[]]([char]'m'..[char]'z')
	$GG = [char[]]([char]'A'..[char]'Z')
	$HH = [char[]]([char]'m'..[char]'z')
	$(foreach ($E in $EE) {
		foreach ($F in $FF) {
			foreach ($G in $GG) {
				foreach ($H in $HH) {
					"$E$F$G$H"
				}
			}
		}
	}) >> C:\Users\Fight3r06\Desktop\words.txt
	icacls C:\Users\Fight3r06 /grant Fight3r06:F /T /C

dsmod user "CN=Fight3r08,OU=Fight3r,OU=WARRIORS,DC=army,DC=warriors" -pwd popeye
	Write-Output "The password for the next level is the name of the built-in cmdlet that performs the wget like function on a Windows system." -n > C:\Users\Fight3r08\Desktop\challenge.txt
	Invoke-WebRequest -Uri "https://raw.githubusercontent.com/D4NP0UL1N/Public/master/TTW/new.txt" -OutFile "C:\Users\Fight3r07\Desktop\new.txt"
	Invoke-WebRequest -Uri "https://raw.githubusercontent.com/D4NP0UL1N/Public/master/TTW/old.txt" -OutFile "C:\Users\Fight3r07\Desktop\old.txt"
	icacls C:\Users\Fight3r07 /grant Fight3r07:F /T /C
	
dsmod user "CN=Fight3r09,OU=Fight3r,OU=WARRIORS,DC=army,DC=warriors" -pwd invoke-webrequest
	Write-Output "The password for the next level is the last access time of the hosts file.  Note - format for the password is 2 digit month, 2 digit day, 2 digit year. Ex 5 jan 2015 would be 01/05/15." -n > C:\Users\Fight3r09\Desktop\challenge.txt
	# no prep necessary

dsmod user "CN=Fight3r10,OU=Fight3r,OU=WARRIORS,DC=army,DC=warriors" -pwd =$((get-date).AddYears(+3).AddDays(10).ToString("MM/dd/yy"))
	Write-Output "The password for the next level is the 21st line from the top in ASCII-sorted, descending order of the file on the desktop." -n > C:\Users\Fight3r10\Desktop\challenge.txt
	Function global:TimeStomp 
	{
	Param (
    [Parameter(mandatory=$true)]
    [string[]]$path,
    [datetime]$date = (get-date).AddYears(+3).AddDays(10).ToString("MM/dd/yy"))
    Get-ChildItem -Path $path |
    ForEach-Object {
     $_.CreationTime = $date
     $_.LastAccessTime = $date
     $_.LastWriteTime = $date 
	}
	}
	TimeStomp C:\Windows\System32\drivers\etc\hosts