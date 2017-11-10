$ErrorActionPreference = 'SilentlyContinue'

#----- LOCK OUT Administrator from that which was set on yaml / Instructor ACCESS ONLY ---
net user Administrator ReallyStrongPassword!!
Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\winlogon" -Name "DefaultPassword" -PropertyType String -Value 'ReallyStrongPassword!!'

#----- OUs ---
New-ADOrganizationalUnit -Name WARRIORS -Path "DC=army,DC=warriors"
New-ADOrganizationalUnit -Name Apprentice -Path "OU=WARRIORS,DC=army,DC=warriors"
New-ADOrganizationalUnit -Name Fighter -Path "OU=WARRIORS,DC=army,DC=warriors"
New-ADOrganizationalUnit -Name Paladin -Path "OU=WARRIORS,DC=army,DC=warriors"
New-ADOrganizationalUnit -Name Wizard -Path "OU=WARRIORS,DC=army,DC=warriors"
New-ADOrganizationalUnit -Name OSsassin -Path "OU=WARRIORS,DC=army,DC=warriors"
New-ADOrganizationalUnit -Name SYNmurai -Path "OU=WARRIORS,DC=army,DC=warriors"

#----- Security Groups ---
New-ADGroup -Name Apprentices -Path "CN=Users,DC=army,DC=warriors" -GroupCategory Security -GroupScope Universal
 
New-ADGroup -Name Fighters -Path "CN=Users,DC=army,DC=warriors" -GroupCategory Security -GroupScope Global 
Add-ADGroupMember -Identity "CN=Fighters,CN=Users,DC=army,DC=warriors" -Members "CN=Apprentices,CN=Users,DC=army,DC=warriors"

New-ADGroup -Name Paladins -Path "CN=Users,DC=army,DC=warriors" -GroupCategory Security -GroupScope Global 
Add-ADGroupMember -Identity "CN=Paladins,CN=Users,DC=army,DC=warriors" -Members "CN=Fighters,CN=Users,DC=army,DC=warriors"

New-ADGroup -Name Wizards -Path "CN=Users,DC=army,DC=warriors" -GroupCategory Security -GroupScope Global 
Add-ADGroupMember -Identity "CN=Wizards,CN=Users,DC=army,DC=warriors" -Members "CN=Paladins,CN=Users,DC=army,DC=warriors"

New-ADGroup -Name OSsassins -Path "CN=Users,DC=army,DC=warriors" -GroupCategory Security -GroupScope Global 
Add-ADGroupMember -Identity "CN=OSsassins,CN=Users,DC=army,DC=warriors" -Members "CN=Wizards,CN=Users,DC=army,DC=warriors"

New-ADGroup -Name SYNmurais -Path "CN=Users,DC=army,DC=warriors" -GroupCategory Security -GroupScope Global 
Add-ADGroupMember -Identity "CN=SYNmurais,CN=Users,DC=army,DC=warriors" -Members "CN=OSsassins,CN=Users,DC=army,DC=warriors"

New-ADGroup -Name Rangers -Path "CN=Users,DC=army,DC=warriors" -GroupCategory Security -GroupScope Global 
Add-ADGroupMember -Identity "CN=Rangers,CN=Users,DC=army,DC=warriors" -Members "CN=SYNmurais,CN=Users,DC=army,DC=warriors"

New-ADGroup -Name CodeSlingers -Path "CN=Users,DC=army,DC=warriors" -GroupCategory Security -GroupScope Global 
Add-ADGroupMember -Identity "CN=CodeSlingers,CN=Users,DC=army,DC=warriors" -Members "CN=SYNmurais,CN=Users,DC=army,DC=warriors"

New-ADGroup -Name MASTERS -Path "CN=Users,DC=army,DC=warriors" -GroupCategory Security -GroupScope Global 
Add-ADGroupMember -Identity "CN=MASTERS,CN=Users,DC=army,DC=warriors" -Members "CN=SYNmurais,CN=Users,DC=army,DC=warriors"


#----- Share Drive Setup ---

#----- Creates Share Folders for all Levels ---  10990 folders
set-variable -name ROOT -value "C:\share"
set-variable -name TOP -value "WARRIORS"
New-Item -ItemType Directory -Path "$ROOT\$TOP\" -Force

$CLASSES = @("Apprentice","Fighter","Paladin","Wizard","OSsassin","SYNmurai","MASTER","Ranger","CodeSlinger")
$1STFOLDER = @("1","2","3","4","5","6","7","8","9","10")
$2NDFOLDER = @("10","9","8","7","6","5","4","3","2","1")
$3RDFOLDER = @("1","2","3","4","5","6","7","8","9","10")
$4THFOLDER = @("10","9","8","7","6","5","4","3","2","1")

foreach ($CLASS in $CLASSES) {
	Write-Output $CLASS
	foreach ($3RD in $3RDFOLDER) {
		Write-Output $3RD
		foreach ($2ND in $2NDFOLDER) {
			Write-Output $2ND
			foreach ($1ST in $1STFOLDER) {
				New-Item -ItemType Directory -Path "$ROOT\$TOP\$CLASS\$3RD\HOME\$2ND\HOME\$1ST" -Force
			}
		}
	}
}

   
    foreach ($4TH in $4THFOLDER) {
        Write-Output $4TH
        foreach ($3RD in $3RDFOLDER) {
            New-Item -ItemType Directory -Path "$CLASS\$1ST\$4TH\$3RD"
            }
        }
start-sleep -s 1
	
# ----- creates SMB share for folders created above ---
new-SMBshare -path "C:\share" `
-Name "The Share" `
-Desc "A Share Drive"

Add-NTFSAccess -Path C:\share -Account 'Everyone' -AccessRights Read

icacls "C:\share\WARRIORS" /grant Everyone:R /C
icacls "C:\share\WARRIORS\MASTER" /grant MASTER:F /T /C
icacls "C:\share\WARRIORS\CodeSlinger" /grant CodeSlinger:F /T /C
icacls "C:\share\WARRIORS\Ranger" /grant Ranger:F /T /C
icacls "C:\share\WARRIORS\SYNmurai" /grant SYNmurais:F /T /C
icacls "C:\share\WARRIORS\OSsassins" /grant OSsassins:F /T /C
icacls "C:\share\WARRIORS\Wizards" /grant Wizards:F /T /C
icacls "C:\share\WARRIORS\Paladins" /grant Paladins:F /T /C
icacls "C:\share\WARRIORS\Fighters" /grant Fighters:F /T /C
icacls "C:\share\WARRIORS\Apprentices" /grant Apprentices:F /T /C

#----- DISABLES PASSWORD COMPLEXITY REQ AND ENABLES LOCAL LOGIN FOR USERS OTHER THAN ADMIN ---

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
-LockoutDuration "0.00:00:10" `
-LockoutObservationWindow "0.00:00:05" `
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

$users1 = @("Apprentice01","Apprentice02","Apprentice03","Apprentice04","Apprentice05","Apprentice06","Apprentice07","Apprentice08","Apprentice09","Apprentice10")
foreach ($user in $users1) {
New-ADUser -Name "CN=$user,OU=Apprentice,OU=WARRIORS,DC=army,DC=warriors" -AccountPassword "password" -ChangePasswordAtLogon $false -CannotChangePassword $false -AccountPasswordneverexpires $false -AccountExpirationDate $expire -Enabled $true -AllowReversiblePasswordEncryption $false 
Add-ADGroupMember -Identity "CN=Apprentices,CN=Users,DC=army,DC=warriors" -Members $user
}
start-sleep -s 1

$users2 = @("Fighter01","Fighter02","Fighter03","Fighter04","Fighter05","Fighter06","Fighter07","Fighter08","Fighter09","Fighter10")
foreach ($user in $users2) {
New-ADUser -Name $user -Path "OU=Fighter,OU=WARRIORS,DC=army,DC=warriors" -AccountPassword "password" -ChangePasswordAtLogon $false -CannotChangePassword $false -AccountPasswordneverexpires $false -AccountExpirationDate $expire -Enabled $true -AllowReversiblePasswordEncryption $false
Add-ADGroupMember -Identity "CN=Fighters,CN=Users,DC=army,DC=warriors" -Members $user
}
start-sleep -s 1

$users3 = @("Paladin01","Paladin02","Paladin03","Paladin04","Paladin05","Paladin06","Paladin07","Paladin08","Paladin09","Paladin10")
foreach ($user in $users3) {
New-ADUser -Name $user -Path "OU=Paladin,OU=WARRIORS,DC=army,DC=warriors" -AccountPassword "password" -ChangePasswordAtLogon $false -CannotChangePassword $false -AccountPasswordneverexpires $false -AccountExpirationDate $expire -Enabled $true -AllowReversiblePasswordEncryption $false 
Add-ADGroupMember -Identity "CN=Paladins,CN=Users,DC=army,DC=warriors" -Members $user
}
start-sleep -s 1

$users4 = @("Wizard01","Wizard02","Wizard03","Wizard04","Wizard05","Wizard06","Wizard07","Wizard08","Wizard09","Wizard10")
foreach ($user in $users4) {
New-ADUser -Name $user -Path "OU=Wizard,OU=WARRIORS,DC=army,DC=warriors" -AccountPassword "password" -ChangePasswordAtLogon $false -CannotChangePassword $false -AccountPasswordneverexpires $false -AccountExpirationDate $expire -Enabled $true -AllowReversiblePasswordEncryption $false 
Add-ADGroupMember -Identity "CN=Wizards,CN=Users,DC=army,DC=warriors" -Members $user
}
start-sleep -s 1

$users5 = @("OSsassin01","OSsassin02","OSsassin03","OSsassin04","OSsassin05","OSsassin06","OSsassin07","OSsassin08","OSsassin09")
foreach ($user in $users5) {
New-ADUser -Name $user -Path "OU=OSsassin,OU=WARRIORS,DC=army,DC=warriors" -AccountPassword "password" -ChangePasswordAtLogon $false -CannotChangePassword $false -AccountPasswordneverexpires $false -AccountExpirationDate $expire -Enabled $true -AllowReversiblePasswordEncryption $false
Add-ADGroupMember -Identity "CN=OSsassins,CN=Users,DC=army,DC=warriors" -Members $user
}
start-sleep -s 1

New-ADUser -Name "CN=SYNmurai,OU=SYNmurai,OU=WARRIORS,DC=army,DC=warriors" -AccountPassword "password" -ChangePasswordAtLogon $false -CannotChangePassword $false -AccountPasswordneverexpires $false -AccountExpirationDate $expire -Enabled $true -AllowReversiblePasswordEncryption $false 
Add-ADGroupMember -Identity "CN=SYNmurais,CN=Users,DC=army,DC=warriors" -Members "CN=SYNmurai,OU=SYNmurai,OU=WARRIORS,DC=army,DC=warriors"

New-ADUser -Name "CN=Ranger,OU=SYNmurai,OU=WARRIORS,DC=army,DC=warriors" -AccountPassword "password" -ChangePasswordAtLogon $false -CannotChangePassword $false -AccountPasswordneverexpires $false -AccountExpirationDate $expire -Enabled $true -AllowReversiblePasswordEncryption $false 
Add-ADGroupMember -Identity "CN=SYNmurais,CN=Users,DC=army,DC=warriors" -Members "CN=Ranger,OU=SYNmurai,OU=WARRIORS,DC=army,DC=warriors"

New-ADUser -Name "CN=CodeSlinger,OU=SYNmurai,OU=WARRIORS,DC=army,DC=warriors" -AccountPassword "password" -ChangePasswordAtLogon $false -CannotChangePassword $false -AccountPasswordneverexpires $false -AccountExpirationDate $expire -Enabled $true -AllowReversiblePasswordEncryption $false 
Add-ADGroupMember -Identity "CN=SYNmurais,CN=Users,DC=army,DC=warriors" -Members "CN=CodeSlinger,OU=SYNmurai,OU=WARRIORS,DC=army,DC=warriors"

New-ADUser -Name "CN=MASTER,OU=SYNmurai,OU=WARRIORS,DC=army,DC=warriors" -AccountPassword "password" -ChangePasswordAtLogon $false -CannotChangePassword $false -AccountPasswordneverexpires $false -AccountExpirationDate $expire -Enabled $true -AllowReversiblePasswordEncryption $false
Add-ADGroupMember -Identity "CN=SYNmurais,CN=Users,DC=army,DC=warriors" -Members "CN=MASTER,OU=SYNmurai,OU=WARRIORS,DC=army,DC=warriors"


#----- Creates Profiles for Every User/Level in Domain .. to be populated with the follow-on challenges

$users1 = @("Apprentice01","Apprentice02","Apprentice03","Apprentice04","Apprentice05","Apprentice06","Apprentice07","Apprentice08","Apprentice09","Apprentice10")
foreach ($user in $users1) {
	psexec -accepteula -u army\$user -p password \\$(hostname) cmd /c "exit" -nobanner
}
$users2 = @("Fighter01","Fighter02","Fighter03","Fighter04","Fighter05","Fighter06","Fighter07","Fighter08","Fighter09","Fighter10")
foreach ($user in $users2) {
	psexec -accepteula -u army\$user -p password \\$(hostname) cmd /c "exit" -nobanner
}
$users3 = @("Paladin01","Paladin02","Paladin03","Paladin04","Paladin05","Paladin06","Paladin07","Paladin08","Paladin09","Paladin10")
foreach ($user in $users3) {
	psexec -accepteula -u army\$user -p password \\$(hostname) cmd /c "exit" -nobanner
}
$users4 = @("Wizard01","Wizard02","Wizard03","Wizard04","Wizard05","Wizard06","Wizard07","Wizard08","Wizard09","Wizard10")
foreach ($user in $users4) {
	psexec -accepteula -u army\$user -p password \\$(hostname) cmd /c "exit" -nobanner
}
$users5 = @("OSsassin01","OSsassin02","OSsassin03","OSsassin04","OSsassin05","OSsassin06","OSsassin07","OSsassin08","OSsassin09")
foreach ($user in $users5) {
	psexec -accepteula -u army\$user -p password \\$(hostname) cmd /c "exit" -nobanner
}
$users6 = @("SYNmurai","Ranger","CodeSlinger","MASTER")
foreach ($user in $users6) {
	psexec -accepteula -u army\$user -p password \\$(hostname) cmd /c "exit" -nobanner
}


#----- Specific Files for each account/level/challenge .. modifies domain user accounts with correct challenge "passwords"


Set-ADUser -Identity "CN=Apprentice01,OU=Apprentice,OU=WARRIORS,DC=army,DC=warriors" -AccountPassword "password"
	Write-Output "The password for the next level is the Powershell build version. Note - Please be sure to include all periods" -n > C:\Users\Apprentice01\Desktop\challenge.txt

Set-ADUser -Identity "CN=Apprentice02,OU=Apprentice,OU=WARRIORS,DC=army,DC=warriors" -AccountPassword "$(($PSVersionTable.BuildVersion).ToString())"
	Write-Output "The password for the next level is the short name of the domain in which this server is a part of." -n > C:\Users\Apprentice02\Desktop\challenge.txt
	
Set-ADUser -Identity "CN=Apprentice03,OU=Apprentice,OU=WARRIORS,DC=army,DC=warriors" -AccountPassword "dod"
	Write-Output "The password for the next level is in a readme file somewhere in this user’s profile." -n > C:\Users\Apprentice03\Desktop\challenge.txt
	
Set-ADUser -Identity "CN=Apprentice04,OU=Apprentice,OU=WARRIORS,DC=army,DC=warriors" -AccountPassword "123456"
	Write-Output "The password for the next level is in a file in a hidden directory in the root of this user’s profile." -n > C:\Users\Apprentice04\Desktop\challenge.txt
	Write-Output "123456" > C:\Users\Apprentice03\Favorites\README
	icacls C:\Users\Apprentice03 /grant Apprentice03:F /T /C

Set-ADUser -Identity "CN=Apprentice05,OU=Apprentice,OU=WARRIORS,DC=army,DC=warriors" -AccountPassword "ketchup"
	Write-Output "The password for the next level is in a file in a directory on the desktop with spaces in it." -n > C:\Users\Apprentice05\Desktop\challenge.txt
	New-Item -ItemType Directory -Path "C:\Users\Apprentice04\secretsauce" -Force
	Write-Output "ketchup" > C:\Users\Apprentice04\secretsauce\saucey
	attrib +h C:\Users\Apprentice04\secretsauce
	icacls C:\Users\Apprentice04 /grant Apprentice04:F /T /C 
	
Set-ADUser -Identity "CN=Apprentice06,OU=Apprentice,OU=WARRIORS,DC=army,DC=warriors" -AccountPassword "987654321"
	Write-Output "The password for the next level is the manufacturing name of the only USB drive that was plugged into this server at some point." -n > C:\Users\Apprentice06\Desktop\challenge.txt
	$dirs = @("1    -     99","100     -     199","a     -      z","z                                                                                                           -                                                                          a")
	foreach ($dir in $dirs) {
		New-Item -ItemType Directory -Path C:\Users\Apprentice05\Desktop\$dir -Force
		}
	Write-Output "987654321" > "C:\Users\Apprentice05\Desktop\z                                                                                                           -                                                                          a\space.txt"
	icacls C:\Users\Apprentice05 /grant Apprentice05:F /T /C
	
Set-ADUser -Identity "CN=Apprentice07,OU=Apprentice,OU=WARRIORS,DC=army,DC=warriors" -AccountPassword "SanDisk"
	Write-Output "The password for the next level is the description of the Lego Land service." -n > C:\Users\Apprentice07\Desktop\challenge.txt
	Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\USBSTOR" -Name Start -Value 1 
	New-Item "C:\windows\system32" -ItemType File -Name reg.ps1 -Force
		Write-Output 'New-Item "HKLM:\SYSTEM\CurrentControlSet\Enum" -Name USBSTOR -Force' > "C:\windows\system32\reg.ps1"
			Write-Output 'New-Item "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\Disk_Ven_SanDisk_Prod_Cruzer_Blade_Rev_PMAP\CF52A6CB0" -Name "Device Parameters" -Force' >> "C:\windows\system32\reg.ps1"
			Write-Output 'New-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\Disk_Ven_SanDisk_Prod_Cruzer_Blade_Rev_PMAP\CF52A6CB0" -Name "Capabilities" -Value "0X00000010" -PropertyType DWord | Out-Null' >> "C:\windows\system32\reg.ps1"
			Write-Output 'New-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\Disk_Ven_SanDisk_Prod_Cruzer_Blade_Rev_PMAP\CF52A6CB0" -Name "Class" -Value "DiskDrive" -PropertyType String | Out-Null' >> "C:\windows\system32\reg.ps1"
			Write-Output 'New-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\Disk_Ven_SanDisk_Prod_Cruzer_Blade_Rev_PMAP\CF52A6CB0" -Name "ClassGUID" -Value "{4d36e967-e325-11ce-bfc1-08002be10318}" -PropertyType String | Out-Null' >> "C:\windows\system32\reg.ps1"
			Write-Output 'New-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\Disk_Ven_SanDisk_Prod_Cruzer_Blade_Rev_PMAP\CF52A6CB0" -Name "CompatibleIDs" -Value "USBSTOR\Disk USBSTOR\RAW" -PropertyType MultiString | Out-Null' >> "C:\windows\system32\reg.ps1"
			Write-Output 'New-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\Disk_Ven_SanDisk_Prod_Cruzer_Blade_Rev_PMAP\CF52A6CB0" -Name "ConfigFlags" -Value "0X00000000" -PropertyType DWord | Out-Null' >> "C:\windows\system32\reg.ps1"
			Write-Output 'New-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\Disk_Ven_SanDisk_Prod_Cruzer_Blade_Rev_PMAP\CF52A6CB0" -Name "ContainerID" -Value "{c2dc3c42-a281-557a-a6ed-e607894e99b3}" -PropertyType String | Out-Null' >> "C:\windows\system32\reg.ps1"
			Write-Output 'New-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\Disk_Ven_SanDisk_Prod_Cruzer_Blade_Rev_PMAP\CF52A6CB0" -Name "DeviceDesc" -Value "@disk.inf;%disk_devdesc%;Disk Drive" -PropertyType String | Out-Null' >> "C:\windows\system32\reg.ps1"
			Write-Output 'New-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\Disk_Ven_SanDisk_Prod_Cruzer_Blade_Rev_PMAP\CF52A6CB0" -Name "Driver" -Value "{4d36e967-e325-11ce-bfc1-08002be10318}\0001" -PropertyType String | Out-Null' >> "C:\windows\system32\reg.ps1"
			Write-Output 'New-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\Disk_Ven_SanDisk_Prod_Cruzer_Blade_Rev_PMAP\CF52A6CB0" -Name "FriendlyName" -Value "SanDisk Cruzer Blade USB Device" -PropertyType String | Out-Null' >> "C:\windows\system32\reg.ps1"
			Write-Output 'New-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\Disk_Ven_SanDisk_Prod_Cruzer_Blade_Rev_PMAP\CF52A6CB0" -Name "HardwareID" -Value "USBSTOR\DiskSanDisk_Cruzer_Blade___PMAP USBST..." -PropertyType MultiString | Out-Null' >> "C:\windows\system32\reg.ps1"
			Write-Output 'New-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\Disk_Ven_SanDisk_Prod_Cruzer_Blade_Rev_PMAP\CF52A6CB0" -Name "Mfg" -Value "@disk.inf;%genmanufacturer%;Standard disk drives" -PropertyType String | Out-Null' >> "C:\windows\system32\reg.ps1"
			Write-Output 'New-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\Disk_Ven_SanDisk_Prod_Cruzer_Blade_Rev_PMAP\CF52A6CB0" -Name "Service" -Value "disk" -PropertyType String | Out-Null' >> "C:\windows\system32\reg.ps1"
				Write-Output 'New-Item "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\Disk_Ven_SanDisk_Prod_Cruzer_Blade_Rev_PMAP\CF52A6CB0\Device Parameters" -Name "MediaChangeNotification" -Force' >> "C:\windows\system32\reg.ps1"
				Write-Output 'New-Item "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\Disk_Ven_SanDisk_Prod_Cruzer_Blade_Rev_PMAP\CF52A6CB0\Device Parameters" -Name "Partmgr" -Force' >> "C:\windows\system32\reg.ps1"
					Write-Output 'New-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\Disk_Ven_SanDisk_Prod_Cruzer_Blade_Rev_PMAP\CF52A6CB0\Device Parameters\Partmgr" -Name "Attributes" -Value "0X00000000" -PropertyType DWord | Out-Null' >> "C:\windows\system32\reg.ps1"
					Write-Output 'New-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\Disk_Ven_SanDisk_Prod_Cruzer_Blade_Rev_PMAP\CF52A6CB0\Device Parameters\Partmgr" -Name "DiskId" -Value "{116c15b5-5f04-11e5-9d2b-000c293089ea}" -PropertyType String | Out-Null' >> "C:\windows\system32\reg.ps1"
			Write-Output 'New-Item "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\Disk_Ven_SanDisk_Prod_Cruzer_Blade_Rev_PMAP\CF52A6CB0" -Name "LogConf" -Force' >> "C:\windows\system32\reg.ps1"
			Write-Output 'New-Item "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\Disk_Ven_SanDisk_Prod_Cruzer_Blade_Rev_PMAP\CF52A6CB0" -Name "Properties" -Force' >> "C:\windows\system32\reg.ps1"
		schtasks /create /tn "Reg" /tr "powershell.exe -file C:\windows\system32\reg.ps1" /ru SYSTEM /sc ONCE /st (get-date).AddMinutes(1).ToString("HH:mm") /V1 /z
		# Register-ScheduledJob -Name USB -FilePath  C:\windows\system32\reg.ps1 -RunNow
	    start-sleep -s 1
	
Set-ADUser -Identity "CN=Apprentice08,OU=Apprentice,OU=WARRIORS,DC=army,DC=warriors" -AccountPassword "i_love_legos"
	Write-Output "The password for the next level is the number of files in the Videos folder." -n > C:\Users\Apprentice08\Desktop\challenge.txt
	New-Service LegoLand -Desc "i_love_legos" "C:\windows\system32\notepad.exe"

Set-ADUser -Identity "CN=Apprentice09,OU=Apprentice,OU=WARRIORS,DC=army,DC=warriors" -AccountPassword "925"
	Write-Output "The password for the next level is the number of folders in the Music folder." -n > C:\Users\Apprentice09\Desktop\challenge.txt
	0..698 | % { New-Item -ItemType File -Path C:\Users\Apprentice08\Videos\file$_.txt -Force }
	710..776 | % { New-Item -ItemType File -Path C:\Users\Apprentice08\Videos\file$_.txt -Force }
	834..991 | % { New-Item -ItemType File -Path C:\Users\Apprentice08\Videos\file$_.txt -Force }
	New-Item -ItemType Directory -Path "C:\Users\Apprentice08\Videos" -Force
	New-Item -ItemType File -Path "C:\Users\Apprentice08\Videos\file1103.txt" -Force
	
Set-ADUser -Identity "CN=Apprentice10,OU=Apprentice,OU=WARRIORS,DC=army,DC=warriors" -AccountPassword "411"
	Write-Output "The password for the next level is the number of words in a file on the desktop." -n > C:\Users\Apprentice10\Desktop\challenge.txt
	Write-Output "Note: Next Level Login - Fighter01" -n >> C:\Users\Apprentice10\Desktop\challenge.txt
	1..703 | % {if($_ % 2 -eq 1 ) { New-Item -ItemType Directory -Path C:\Users\Apprentice09\Music\Stevie_Wonder$_ -Force } }
	18..73 | % { New-Item -ItemType Directory -Path C:\Users\Apprentice09\Music\Teddy_Pendergrass$_ -Force }
	New-Item -ItemType Directory -Path "C:\Users\Apprentice09\Music\Teddy_Pendergrass" -Force
	New-Item -ItemType Directory -Path "C:\Users\Apprentice09\Music\Luther Vandros" -Force
	New-Item -ItemType Directory -Path "C:\Users\Apprentice09\Music\Stevie_Wonder 139" -Force
	icacls C:\Users\Apprentice09 /grant Apprentice09:F /T /C

Set-ADUser -Identity "CN=Fighter01,OU=Fighter,OU=WARRIORS,DC=army,DC=warriors" -AccountPassword "5254"
	Write-Output "The password for the next level is the last five digits of the MD5 hash of the hosts file." -n > C:\Users\Fighter01\Desktop\challenge.txt
	New-Item -ItemType File -Path "C:\Users\Apprentice10\Desktop\words.txt" -Force
	function global:Get-8LetterWord() {
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
			$pickSet=(Get-Random $complexity)*2
			$NewWord=$NewWord+[char]((Get-Random $ArrayOfAscii[$pickset])+$ArrayOfAscii[$pickset+1])
		}
	Return $NewWord
	}
	
	foreach ($Counter in 1..5254) { 
	Get-8LetterWord >> C:\Users\Apprentice10\Desktop\words.txt 
	}
	icacls C:\Users\Apprentice10 /grant Apprentice10:F /T /C
	
Set-ADUser -Identity "CN=Fighter02,OU=Fighter,OU=WARRIORS,DC=army,DC=warriors" -AccountPassword "7566D"
	Write-Output "The password for the next level is the number of times 'gaab' is listed in the file on the desktop." -n > C:\Users\Fighter02\Desktop\challenge.txt
	# no prep necessary

Set-ADUser -Identity "CN=Fighter03,OU=Fighter,OU=WARRIORS,DC=army,DC=warriors" -AccountPassword "1"
	Write-Output "The password for the next level is the number of times 'az' appears in the words.txt file on the desktop." -n > C:\Users\Fighter03\Desktop\challenge.txt
	Write-Output "Hint: 'az', may appear more than one time in a word." -n >> C:\Users\Fighter03\Desktop\challenge.txt
	$AA = [char[]]([char]'a'..[char]'z')
	$BB = [char[]]([char]'a'..[char]'z')
	$CC = [char[]]([char]'a'..[char]'z')
	$DD = [char[]]([char]'a'..[char]'z')
	$(foreach ($A in $AA) {
		"$A"
	}) > C:\Users\Fighter02\Desktop\words.txt
	
	$(foreach ($A in $AA) {
		foreach ($B in $BB) {
			"$A$B"
		}
	}) >> C:\Users\Fighter02\Desktop\words.txt
	
	$(foreach ($A in $AA) {
		foreach ($B in $BB) {
			foreach ($C in $CC) {
				"$A$B$C"
			}
		}
	}) >> C:\Users\Fighter02\Desktop\words.txt
	
	$(foreach ($A in $AA) {
		foreach ($B in $BB) {
			foreach ($C in $CC) {
				foreach ($D in $DD) {
					"$A$B$C$D"
				}
			}
		}
	}) >> C:\Users\Fighter02\Desktop\words.txt
	icacls C:\Users\Fighter02\Desktop /grant Fighter02:F /T /C
	
Set-ADUser -Identity "CN=Fighter04,OU=Fighter,OU=WARRIORS,DC=army,DC=warriors" -AccountPassword "2081"
	Write-Output "The password for the next level is the number of words with either 'a' OR 'z', in the word, in the words.txt file on the desktop." -n > C:\Users\Fighter04\Desktop\challenge.txt
	New-Item -ItemType Directory -Path "C:\Users\Fighter02\Desktop" -Force
	Copy-Item C:\Users\Fighter02\Desktop\words.txt C:\Users\Fighter03\Desktop\
	icacls C:\Users\Fighter03 /grant Fighter03:F /T /C

Set-ADUser -Identity "CN=Fighter05,OU=Fighter,OU=WARRIORS,DC=army,DC=warriors" -AccountPassword "129054"
	Write-Output "The password for the next level is the number of words meeting the following criteria in the file on the desktop CRITERIA - 'a' appears at least twice, followed by either an a, b, c . .  OR g" -n > C:\Users\Fighter05\Desktop\challenge.txt
	New-Item -ItemType Directory -Path "C:\Users\Fighter02\Desktop" -Force
	Copy-Item C:\Users\Fighter02\Desktop\words.txt C:\Users\Fighter04\Desktop\
	icacls C:\Users\Fighter04 /grant Fighter04:F /T /C
	
Set-ADUser -Identity "CN=Fighter06,OU=Fighter,OU=WARRIORS,DC=army,DC=warriors" -AccountPassword "364"
	Write-Output "The password for the next level is the number of unique words in the file on the desktop." -n > C:\Users\Fighter06\Desktop\challenge.txt
	New-Item -ItemType Directory -Path "C:\Users\Fighter02\Desktop" -Force
	Copy-Item C:\Users\Fighter02\Desktop\words.txt C:\Users\Fighter05\Desktop\
	icacls C:\Users\Fighter05 /grant Fighter05:F /T /C
	
Set-ADUser -Identity "CN=Fighter07,OU=Fighter,OU=WARRIORS,DC=army,DC=warriors" -AccountPassword "456976"
	Write-Output "The password for the next level is the only line that makes the two files in the Downloads folder different." -n > C:\Users\Fighter07\Desktop\challenge.txt
	New-Item -ItemType Directory -Path "C:\Users\Fighter06\Desktop" -Force
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
	}) >> C:\Users\Fighter06\Desktop\words.txt
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
	}) >> C:\Users\Fighter06\Desktop\words.txt
	icacls C:\Users\Fighter06 /grant Fighter06:F /T /C

Set-ADUser -Identity "CN=Fighter08,OU=Fighter,OU=WARRIORS,DC=army,DC=warriors" -AccountPassword "popeye"
	Write-Output "The password for the next level is the name of the built-in cmdlet that performs the wget like function on a Windows system." -n > C:\Users\Fighter08\Desktop\challenge.txt
	Invoke-WebRequest -Uri "https://raw.githubusercontent.com/D4NP0UL1N/Public/master/TTW/new.txt" -OutFile "C:\Users\Fighter07\Downloads\new.txt"
	Invoke-WebRequest -Uri "https://raw.githubusercontent.com/D4NP0UL1N/Public/master/TTW/old.txt" -OutFile "C:\Users\Fighter07\Downloads\old.txt"
	icacls C:\Users\Fighter07 /grant Fighter07:F /T /C
	
Set-ADUser -Identity "CN=Fighter09,OU=Fighter,OU=WARRIORS,DC=army,DC=warriors" -AccountPassword "invoke-webrequest"
	Write-Output "The password for the next level is the last access time of the hosts file.  Note - format for the password is 2 digit month, 2 digit day, 2 digit year. Ex 5 jan 2015 would be 01/05/15." -n > C:\Users\Fighter09\Desktop\challenge.txt
	# no prep necessary

Set-ADUser -Identity "CN=Fighter10,OU=Fighter,OU=WARRIORS,DC=army,DC=warriors" -AccountPassword "$((get-date).AddYears(+3).AddDays(10).ToString("MM/dd/yy"))"
	Write-Output "The password for the next level is the 21st line from the top in ASCII-sorted, descending order of the file on the desktop." -n > C:\Users\Fighter10\Desktop\challenge.txt
	Write-Output "Note: Next Level Login - Paladin01" -n >> C:\Users\Fighter10\Desktop\challenge.txt
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

Set-ADUser -Identity "CN=Paladin01,OU=Paladin,OU=WARRIORS,DC=army,DC=warriors" -AccountPassword "ZzZp"
	Write-Output "The password for the next level is the date KB3200970 was installed on the server.  Note - format for the password is 2 digit month, 2 digit day, 4 digit year. Ex 5 jan 2015 would be 01/05/2015" -n > C:\Users\Paladin01\Desktop\challenge.txt
	Copy-Item C:\Users\Fighter06\Desktop\words.txt C:\Users\Fighter10\Desktop\
	icacls C:\Users\Fighter10 /grant Fighter10:F /T /C
	
#Set-ADUser -Identity "CN=Paladin02,OU=Paladin,OU=WARRIORS,DC=army,DC=warriors" -AccountPassword "$((((Get-HotFix –ID KB3200970 | select Installedon) -split ' ')[0] -split '=')[1])"
Set-ADUser -Identity "CN=Paladin02,OU=Paladin,OU=WARRIORS,DC=army,DC=warriors" -AccountPassword "11/21/2016"
	Write-Output "The password for the next level is the SID of the current user. Example  S-1-5-21-1004336348-1177238915-[682003330]-1000" -n > C:\Users\Paladin02\Desktop\challenge.txt
	
Set-ADUser -Identity "CN=Paladin03,OU=Paladin,OU=WARRIORS,DC=army,DC=warriors" -AccountPassword "$(((wmic useraccount list brief | select-string 'Paladin02') -split '-')[6])"
	Write-Output "The password for the next level is the RID of the 'krbtgt' account. Example  S-1-5-21-1004336348-1177238915-682003330-[501]" -n > C:\Users\Paladin03\Desktop\challenge.txt
	# no prep necessary
  
Set-ADUser -Identity "CN=Paladin04,OU=Paladin,OU=WARRIORS,DC=army,DC=warriors" -AccountPassword "502"
	Write-Output "The password for the next level is the SID of the only Totally-Legit service. Example  S-1-5-80-159957745-2084983471-2137709666-960844832-[1182961511]" -n > C:\Users\Paladin04\Desktop\challenge.txt
	# no prep necessary
	
Set-ADUser -Identity "CN=Paladin05,OU=Paladin,OU=WARRIORS,DC=army,DC=warriors" -AccountPassword "$(((cmd.exe /c "sc showsid Legit") -split "-")[10])"
	Write-Output "The password for the next level is the name of the program that is set to start at logon." -n > C:\Users\Paladin05\Desktop\challenge.txt
	cmd.exe /c "sc create Legit binpath= C:\windows\system32\kbd101f.cmd start= auto DisplayName= Totally-Legit type= own"
	
Set-ADUser -Identity "CN=Paladin06,OU=Paladin,OU=WARRIORS,DC=army,DC=warriors" -AccountPassword "yes"
	Write-Output "The password for the next level is in the zip file." -n > C:\Users\Paladin06\Desktop\challenge.txt
	Write-Output "$A = (((wmic useraccount list brief | select-string 'Paladin05') -split "\\")[1] -split " ")[0]" > C:\windows\system32\schd.ps1
	Write-Output "if ( $A -match ('Paladin05') ) { New-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run" -Name yes -Value "C:\Users\Paladin05\Desktop\no.exe" -PropertyType String | Out-Null}" >> C:\windows\system32\schd.ps1
	$tr = New-JobTrigger -AtLogon -User army\Paladin05
	$opts = New-ScheduledJobOption -HideInTaskScheduler -RunElevated -StartIfOnBattery -ContinueIfGoingOnBattery
	Register-ScheduledJob -Name Paladin05 -FilePath  C:\windows\system32\schd.ps1 -ScheduledJobOption $opts -Trigger $tr		
			
Set-ADUser -Identity "CN=Paladin07,OU=Paladin,OU=WARRIORS,DC=army,DC=warriors" -AccountPassword "kung-fu"
	Write-Output "The password for the next level is hidden in the users profile." -n > C:\Users\Paladin07\Desktop\challenge.txt
	# creates "password.txt" a smoke-screen
	1..500 | % { Write-Output " i, Paladin06, will not try to take the easy way out again ." -n >> C:\Users\Paladin06\Documents\password.txt }
	Write-Output "" >> C:\Users\Paladin06\Documents\password.txt
	Write-Output " Sincerely," -n >> C:\Users\Paladin06\Documents\password.txt 
	Write-Output " Paladin06" -n >> C:\Users\Paladin06\Documents\password.txt
	Write-Output "" >> C:\Users\Paladin06\Documents\password.txt
	# creates "Paladin1000.zip"
	New-Item -ItemType Directory -Path C:\Users\Paladin06\Documents\archive
	New-Item -ItemType File -Path C:\Users\Paladin06\Documents\Paladin1.txt
	Write-Output "kung-fu" -n > C:\Users\Paladin06\Documents\Paladin1.txt
	Compress-Archive -Path C:\Users\Paladin06\Documents\Paladin1.txt -DestinationPath C:\Users\Paladin06\Documents\Paladin1.zip; Remove-Item C:\Users\Paladin06\Documents\Paladin1.txt
	for ($i=1; $i -lt 1001; $i = $i + 1) { 
	Compress-Archive -Path C:\Users\Paladin06\Documents\Paladin*.zip -DestinationPath C:\Users\Paladin06\Documents\archive\Paladin$i.zip; Remove-Item C:\Users\Paladin06\Documents\Paladin*.zip; Move-Item C:\Users\Paladin06\Documents\archive\Paladin*.zip C:\Users\Paladin06\Documents\; 
	}
	Remove-Item C:\Users\Paladin06\Documents\archive -force
	icacls C:\Users\Paladin06 /grant Paladin06:F /T /C
	
Set-ADUser -Identity "CN=Paladin08,OU=Paladin,OU=WARRIORS,DC=army,DC=warriors" -AccountPassword "P455W0RD"
	Write-Output "Challenge Hint - its a crappie site, but someones gotta phish it.." -n > C:\Users\Paladin08\Desktop\challenge.txt
	$FILES = @("nothing_here","empty_file","completely_blank","bit_free")
	foreach ($FILE in $FILES) {
		New-Item -ItemType File -Path "C:\Users\Paladin07\Documents\$FILE" -Force
	}
	Add-Content -Path C:\Users\Paladin07\Documents\nothing_here -Value "P455W0RD" -Stream "hidden"	
	Write-Output "challenges from here on ... get bit more challenging" > C:\Users\Paladin07\Documents\NOTICE
	icacls C:\Users\Paladin07 /grant Paladin07:F /T /C
		
Set-ADUser -Identity "CN=Paladin09,OU=Paladin,OU=WARRIORS,DC=army,DC=warriors" -AccountPassword "phi5hy" 
	Write-Output "Challenge Hint - Beijing to deny any knowledge of injecting cookies onto our systems . ." -n > C:\Users\Paladin09\Desktop\challenge.txt
	Write-Output "" > C:\Windows\Web\crappie
	Write-Output " can not seem to remember where i put that darn lobster trap . . " -n >> C:\Windows\Web\crappie
	Write-Output "" >> C:\Windows\Web\crappie	
	Write-Output " i know it is around here somewhere . ." -n >> C:\Windows\Web\crappie
	Write-Output "" >> C:\Windows\Web\crappie
	New-Item -ItemType Directory "C:\Windows\Web\WWW" -Force
	New-Item -ItemType File "C:\Windows\Web\WWW" -name "getting warmer" -Force
	0..404 | % { New-Item -ItemType File -Path C:\Windows\Web\WWW\$_ -Force; attrib +h C:\Windows\Web\WWW\$_ }
	attrib -h C:\Windows\Web\WWW\200
	Write-Output "Passsword: phi5hy" > "C:\Windows\Web\WWW\200"
	attrib +h C:\Windows\Web\WWW\200
	
Set-ADUser -Identity "CN=Paladin10,OU=Paladin,OU=WARRIORS,DC=army,DC=warriors" -AccountPassword "fortune_cookie" 
	Write-Output "Challenge Hint - let it be logged ..  the password is somewhere on this system . ." -n > C:\Users\Paladin10\Desktop\challenge.txt
	Write-Output "Note: Next Level Login - ??????" -n >> C:\Users\Paladin10\Desktop\challenge.txt
	New-Item -ItemType Directory "C:\Windows\PLA\not_china" -Force
	New-Item -ItemType File "C:\Windows\PLA\not_china\Fortune Cookie Crumb" -Force
	Write-Output "find the hidden fortune cookie.s . . " -n > "C:\Windows\PLA\not_china\Fortune Cookie Crumb"
	Add-Content -Path "C:\windows\PLA\not_china\The Fortune Cookie" -Value "Password:  fortune_cookie" -Stream "none"
	Write-Output "The fortune you seek is inside the fortune cookie on this system." -n > "C:\Windows\PLA\not_china\The Fortune Cookie"
	Write-Output "out to lunch .. check back in 5 min." -n  > C:\Windows\SysWOW64\Com\"fortune cookie.txt"
	attrib +h "C:\Windows\SysWOW64\Com\fortune cookie.txt"
	Write-Output "I cannot help you, for I am just a cookie." -n  > "C:\Windows\System32\Com\fortune cookie.txt"
	attrib +h "C:\Windows\System32\Com\fortune cookie.txt"
	Write-Output "only listen to The Fortune Cookie, and disregard all other fortune telling units." -n  > "C:\Users\Paladin09\Documents\fortune cookie.txt"
	attrib +h "C:\Users\Paladin09\Documents\fortune cookie.txt"


Set-ADUser -Identity "CN=Wizard01,OU=Wizard,OU=WARRIORS,DC=army,DC=warriors" -AccountPassword "3v3nt_L0g"
	Write-Output "Challenge Hint - This Windows File System Filter finished dead last . ." -n > C:\Users\Wizard1\Desktop\challenge.txt
	Write-EventLog -LogName "Application" -Source "EventSystem" -EntryType Information -EventId "4625" -category 0 -Message "The description for Event ID '1073746449' in Source EventSystem cannot be found.  The local computer may not have the necessary registry information or message DLL files to display the message, or you may not have permission to access them.  The following information is part of the event:'86400', SuppressDuplicateDuration, Software\Microsoft\EventSystem\EventLog, password: NOT_LIKELY"
	Write-EventLog -LogName "Application" -Source "ESENT" -EntryType Information -EventId "326" -category 1 -Message "Congratulations! NO Password here!"
	Write-EventLog -LogName "System" -Source "Service Control Manager" -EntryType Information -EventId "7036" -category 0 -Message "Congratulations!  you STILL HAVE NOT found the Password"
	Write-EventLog -LogName "Application" -Source "ESENT" -EntryType Information -EventId "326" -category 1 -Message "The DNS Application Directory Partition DomainDnsZones.army.warriors was created. The distinguished name of the root of this Directory Partition is DC=DomainDnsZones,DC=army,DC=warriors ........................  the Password is: 3v3nt_L0g"

Set-ADUser -Identity "CN=Wizard02,OU=Wizard,OU=WARRIORS,DC=army,DC=warriors" -AccountPassword "Top" 
	Write-Output "Challenge Hint - It is a dirty job, but someone has gotta do it"	-n > C:\Users\Wizard02\Desktop\challenge.txt
	# solution: (((Get-ItemProperty -Path "hklm:\system\currentcontrolset\control\servicegrouporder").List) | select-string FSFilter) -last
				   	
Set-ADUser -Identity "CN=Wizard03,OU=Wizard,OU=WARRIORS,DC=army,DC=warriors" -AccountPassword "d1rty_j0b" 
	Write-Output "Challenge Hint - Arrr! thar be ΘΗΣΑΥΡΟΣ burried in the Share . ." -n > C:\Users\Wizard03\Desktop\challenge.txt
	Write-Output "$B = (((wmic useraccount list brief | select-string 'Wizard02') -split '\\')[1] -split ' ')[0]" > C:\Windows\Resources\system.ps1
	Write-Output "if ( $B -match ('Wizard02')) {write-output 'PASSWORD:  d1rty_j0b' > C:\Users\Wizard02\Desktop\PASSWORD.txt}" >> C:\Windows\Resources\system.ps1
		
	$username = army\Wizard02
	$password = ConvertTo-SecureString -String "Top" -AsPlainText -Force
	$Creds = New-Object System.Management.Automation.PSCredential -ArgumentList ($username,$password)
	
	$tr = New-JobTrigger -Once -RepeatIndefinitely -RepetitionInterval 00:01:05 -At $(date)
	$opts = New-ScheduledJobOption -StartIfOnBattery -ContinueIfGoingOnBattery
	Register-ScheduledJob -Name "RunMe" -FilePath C:\Windows\Resources\system.ps1 -RunNow -Credential $Creds
	Disable-ScheduledJob -Name "RunMe"
	cp C:\Users\Administrator\AppData\Local\Microsoft\Windows\PowerShell\ScheduledJobs\RunMe  C:\Users\Wizard02\AppData\Local\Microsoft\Windows\PowerShell\ScheduledJobs\
	icacls C:\Windows\System32\Tasks /grant Wizard02:RX /T /C
	icacls C:\Windows\System32\Tasks\Microsoft\Windows\PowerShell\ScheduledJobs /grant Wizard02:M /T /C

Set-ADUser -Identity "CN=Wizard04,OU=Wizard,OU=WARRIORS,DC=army,DC=warriors" -AccountPassword "b00ty"
	Write-Output "Arrgh!  fools gold!  Blast!  " -n > "C:\share\WARRIORS\OSsassin\2\HOME\1\HOME\8\B00ty"
	attrib +s +h C:\share\WARRIORS\OSsassin\2\HOME\1\HOME\8\B00ty
	Write-Output "Arrgh!  just some old boot!  " -n > "C:\share\WARRIORS\SYNmurai\8\HOME\3\HOME\7\booty"
	attrib +s +h C:\share\WARRIORS\SYNmurai\8\HOME\3\HOME\7\booty
	Write-Output "Arrgh!  just some old boot!  " -n > "C:\share\WARRIORS\CodeSlinger\3\HOME\4\HOME\5\BOOTY"
	attrib +s +h C:\share\WARRIORS\CodeSlinger\3\HOME\4\HOME\5\BOOTY
	Write-Output "Arr!  Well Done Matey!  p@ss_w0rd - Gawld" -n > "C:\share\WARRIORS\Rang3r\8\HOME\3\HOME\9\ΒΘΘΤΨ"
	Write-Output "Congratulations! You have completed the exercise!" -n > "C:\share\WARRIORS\Rang3r\8\HOME\3\HOME\9\ΒΘΘΤΨ"
	attrib +s +h "C:\share\WARRIORS\Rang3r\8\HOME\3\HOME\9\ΒΘΘΤΨ"
	icacls "C:\share\WARRIORS" /grant Wizard03:R /T /C
	
attrib +h +s C:\Users\SYNmurai
attrib +h +s C:\Users\CodeSlinger
attrib +h +s C:\Users\Ranger
attrib +h +s C:\Users\OSsassin
attrib +h +s C:\Users\MASTER

attrib +h +s C:\share\WARRIORS\SYNmurai
attrib +h +s C:\share\WARRIORS\CodeSlinger
attrib +h +s C:\share\WARRIORS\Ranger
attrib +h +s C:\share\WARRIORS\OSsassin
attrib +h +s C:\share\WARRIORS\MASTER

Remove-Item C:\Windows\System32\setup1.ps1 -Force
Remove-Item C:\windows\system32\reg.ps1 -Force
Remove-Item C:\windows\system32\schd.ps1 -Force
UnRegister-ScheduledJob -Name Paladin05

New-Item $PROFILE.AllUsersAllHosts -ItemType File -Force
Write-Output '$ProfileRoot = (Split-Path -Parent $MyInvocation.MyCommand.Path)' > C:\Windows\System32\WindowsPowerShell\v1.0\profile.ps1
Write-Output '$env:path += "$ProfileRoot"' >> C:\Windows\System32\WindowsPowerShell\v1.0\profile.ps1
icacls C:\Windows\System32\Windows\PowerShell\v1.0\start.ps1 /grant Everyone:F /T /C
icacls C:\Windows\System32\setup2.ps1 /grant Everyone:F /T /C
icacls C:\Windows\System32\PsExec.exe /grant Everyone:F /T /C
Restart-Computer
