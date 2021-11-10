FROM mcr.microsoft.com/windows/servercore:1809

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'Continue'; $verbosePreference='Continue';"]

RUN mkdir -Force C:\TEMP
 
# Download & Install the Visual Studio Build Tools.
ADD https://aka.ms/vs/17/release/vs_BuildTools.exe C:\TEMP\vs_BuildTools.exe
RUN C:\TEMP\vs_BuildTools.exe --quiet --wait --norestart --nocache --noWeb --allWorkloads --includeRecommended --includeOptional || IF "%ERRORLEVEL%"=="3010" EXIT 0;
 
# Install Agents for Visual Studio
ADD https://aka.ms/vs/17/release/vs_TestAgent.exe C:\TEMP\vs_TestAgent.exe
RUN C:\TEMP\vs_TestAgent.exe --quiet --wait --norestart --nocache || IF "%ERRORLEVEL%"=="3010" EXIT 0;

# Install Chocolatey
RUN Add-WindowsFeature Web-WebSockets; \
    Set-ExecutionPolicy Bypass -Scope Process -Force; \
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'));

# Install Git
RUN choco install git;

# Install Java JDK
RUN choco install openjdk;

# Install NodeJS
RUN choco install nodejs;
 
# Allow Docker-in-Docker
RUN setx /M PATH $($Env:PATH + ';' + ${Env:ProgramFiles} + '\Docker');
 
# Download & install Chrome
ADD FontsToAdd.tar /Fonts/
COPY Add-Font.ps1   /Fonts/
WORKDIR /Fonts/
RUN .\Add-Font.ps1 Fonts
WORKDIR /
RUN choco install googlechrome -y;
 
# Cleanup after installs
RUN -Command Remove-Item C:\TEMP -Recurse;
 
# Copy & run Azure Pipelines Agent startup script
COPY start.ps1 .
CMD .\start.ps1