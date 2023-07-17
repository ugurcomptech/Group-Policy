# Group Policy'yi Atlamak için PowerShell Komutları

# 1. Registry Düzenlemeleriyle Group Policy Ayarlarını Değiştirme
# Örnek: DisableTaskMgr DWORD değerini 0 yerine 1 yaparak Görev Yöneticisi'ni etkinleştirme
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name "DisableTaskMgr" -Value 1

# 2. Group Policy'yi Yerel Düzenleyici ile Geçersiz Kılma
# Örnek: Windows Update politikalarını devre dışı bırakma
Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate" -Name "DisableWindowsUpdateAccess" -Value 1
Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoUpdate" -Value 1

# 3. WMI (Windows Management Instrumentation) Kullanarak Group Policy'yi Geçersiz Kılma
# Örnek: Firewall politikasını devre dışı bırakma
$firewallPolicy = Get-WmiObject -Namespace "root/StandardCimv2" -Class "MSFT_NetFirewallProfile"
$firewallPolicy.EnableFirewall = $false
$firewallPolicy.Put()

# 4. LocalGPO cmdlet'leri kullanarak Group Policy'yi Geçersiz Kılma
# Örnek: Belirli bir GPO'yu devre dışı bırakma
Import-Module "C:\Windows\System32\WindowsPowerShell\v1.0\Modules\GroupPolicy\GroupPolicy.psd1"
Set-GPRegistryValue -Name "GPO1" -Key "HKCU\Software\Policies\Microsoft\Windows\Explorer" -ValueName "NoDrives" -Type DWORD -Value 0

# 5. Group Policy'yi Uzak Bir Bilgisayar Üzerinde Geçersiz Kılma
# Örnek: Uzaktaki bir bilgisayardaki belirli bir GPO'yu devre dışı bırakma
Invoke-Command -ComputerName "RemoteComputer" -ScriptBlock {
    Import-Module "C:\Windows\System32\WindowsPowerShell\v1.0\Modules\GroupPolicy\GroupPolicy.psd1"
    Set-GPRegistryValue -Name "GPO1" -Key "HKCU\Software\Policies\Microsoft\Windows\Explorer" -ValueName "NoDrives" -Type DWORD -Value 0
}

# Dikkat: Group Policy'yi atlamak veya geçersiz kılmak, ağ politikalarını ihlal edebilir ve ağ güvenliğini tehlikeye atabilir. Bu tür eylemleri gerçekleştirmeden önce, sistem yöneticinizle iletişime geçmeniz önemlidir.
