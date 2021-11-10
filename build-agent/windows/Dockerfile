FROM mcr.microsoft.com/windows/servercore:1809
 
# Download & Install the Visual Studio Build Tools.
ADD https://aka.ms/vs/17/release/vs_BuildTools.exe C:\TEMP\vs_BuildTools.exe
RUN C:\TEMP\vs_BuildTools.exe --quiet --wait --norestart --nocache --noWeb --allWorkloads --includeRecommended --includeOptional || IF "%ERRORLEVEL%"=="3010" EXIT 0;
 
# Install Agents for Visual Studio
ADD https://aka.ms/vs/17/release/vs_TestAgent.exe C:\TEMP\vs_TestAgent.exe
RUN C:\TEMP\vs_TestAgent.exe --quiet --wait --norestart --nocache || IF "%ERRORLEVEL%"=="3010" EXIT 0;

# Install Chocolatey
RUN powershell -Command \
    Add-WindowsFeature Web-WebSockets; \
    Set-ExecutionPolicy Bypass -Scope Process -Force; \
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'));

# Install Git
RUN powershell -Command choco install git;

# Install Java JDK
RUN powershell -Command choco install openjdk;

# Install NodeJS
RUN powershell -Command choco install nodejs;
 
# Allow Docker-in-Docker
RUN powershell setx /M PATH $($Env:PATH + ';' + ${Env:ProgramFiles} + '\Docker');
 
# Download & install Chrome
ADD FontsToAdd.tar /Fonts/
COPY Add-Font.ps1   /Fonts/
WORKDIR /Fonts/
RUN powershell .\Add-Font.ps1 Fonts
WORKDIR /
RUN powershell -Command  hoco install googlechrome -y;
 
# Cleanup after installs
RUN powershell -Command Remove-Item C:\TEMP -Recurse;
 
# Copy & run Azure Pipelines Agent startup script
COPY start.ps1 .
CMD powershell .\start.ps1