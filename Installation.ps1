Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy AllSigned -Force

# Downloading Java ( Can be used only if required) 
#$url = "http://download.oracle.com/otn-pub/java/jdk/8u181-b13/96a7b8442fe848ef90c96a2fad6ed6d1/jdk-8u181-windows-x64.exe"
#$output = "D:\Software_Automation\jdk-8u181-windows-x64.exe"
#$WebClient = New-Object System.Net.WebClient
#$WebClient.DownloadFile($url,$output)



# Downloading NSSM
$url = "https://www.nssm.cc/release/nssm-2.24.zip"
$output = "D:\Software_Automation\nssm-2.24.zip"
$WebClient = New-Object System.Net.WebClient
$WebClient.DownloadFile($url,$output)
Expand-Archive -Path D:\Software_Automation\nssm-2.24.zip -DestinationPath D:\Software_Automation\ -Force 




# Downloading Jetty 
$url = "http://repo1.maven.org/maven2/org/eclipse/jetty/jetty-distribution/9.4.5.v20170502/jetty-distribution-9.4.5.v20170502.zip"
$output = "D:\Software_Automation\jetty-distribution-9.4.5.v20170502.zip"
$WebClient = New-Object System.Net.WebClient
$WebClient.DownloadFile($url,$output)
Expand-Archive -Path D:\Software_Automation\jetty-distribution-9.4.5.v20170502.zip -DestinationPath D:\Software_Automation\ -Force


#Function for UnTar
function Expand-Tar($tarFile, $dest) {

    if (-not (Get-Command Expand-7Zip -ErrorAction Ignore)) {
        Install-Package -Scope CurrentUser -Force 7Zip4PowerShell > $null
    }

    Expand-7Zip $tarFile $dest
}



#Downloading Zookeeper
$url = "http://www.eu.apache.org/dist/zookeeper/zookeeper-3.4.10/zookeeper-3.4.10.tar.gz"
$output = "D:\Software_Automation\zookeeper-3.4.10.tar.gz"
$WebClient = New-Object System.Net.WebClient
$WebClient.DownloadFile($url,$output)
Expand-Tar D:\Software_Automation\zookeeper-3.4.10.tar.gz D:\Software_Automation\
Expand-Tar D:\Software_Automation\zookeeper-3.4.10.tar D:\Software_Automation\


 # Downloading ActiveMQ 
$url = "http://archive.apache.org/dist/activemq/5.11.1/apache-activemq-5.11.1-bin.zip"
$output = "D:\Software_Automation\apache-activemq-5.11.1-bin.zip"
$WebClient = New-Object System.Net.WebClient
$WebClient.DownloadFile($url,$output)
Expand-Archive -Path D:\Software_Automation\apache-activemq-5.11.1-bin.zip -DestinationPath D:\Software_Automation\ -Force



#Installing and Starting Zookeeper as windows service 
cd D:\Software_Automation\nssm-2.24\win64
ren "D:\Software_Automation\zookeeper-3.4.10\conf\zoo_sample.cfg" "D:\Software_Automation\zookeeper-3.4.10\conf\zoo.cfg"
cmd /c "nssm install Zookeeper Application D:\Software_Automation\zookeeper-3.4.10\bin\zkServer.cmd" -Force
#Start-Service Zookeeper


#Installing and Configuring Jetty 
$Jetty_Home = "D:\Software_Automation\jetty-distribution-9.4.5.v20170502" 
$path = "$Jetty_Home\start.ini"
$word = "# jetty.http.port=8080"
$replacement = "jetty.http.port=3002"
$text = get-content $path 
$newText = $text -replace $word,$replacement
$newText > $path


$path = "$Jetty_Home\etc\webdefault.xml"
$word = "<param-name>useFileMappedBuffer</param-name>
         <param-value>true</param-value>"
$replacement = "<param-name>useFileMappedBuffer</param-name>
                <param-value>false</param-value>"
$text = get-content $path 
$newText = $text -replace $word,$replacement
$newText > $path

$Jetty_Installation = 'java -Duser.timezone=GMT -Djava.library.path= ".\opt\eka-gui.war\WEB-INF\lib" -Xms2g -Xmx4g -jar start.jar'
$Jetty_Installation | Out-File $Jetty_Home\Install_Jetty.bat
Invoke-Item "$Jetty_Home\Install_Jetty.bat" 
cmd /c "nssm install Jetty_Local Application $Jetty_Home\Install_Jetty.bat" -Force
#Start-Service Jetty_Local



#Installing and Configuring ActiveMQ
$path = "D:\Software_Automation\apache-activemq-5.11.1\bin\win64\wrapper.conf"
$word = "#wrapper.java.initmemory=3"
$replacement = "wrapper.java.initmemory=2048"
$text = get-content $path 
$newText = $text -replace $word,$replacement
$newText > $path

$path = "D:\Software_Automation\apache-activemq-5.11.1\bin\win64\wrapper.conf"
$word = "wrapper.java.maxmemory=1024"
$replacement = "wrapper.java.maxmemory=2048"
$text = get-content $path 
$newText = $text -replace $word,$replacement
$newText > $path
Invoke-Item "D:\Software_Automation\apache-activemq-5.11.1\bin\win64\InstallService.bat" 
#Start-Service ActiveMQ