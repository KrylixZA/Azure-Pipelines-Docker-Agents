FROM mcr.microsoft.com/dotnet/framework/runtime:4.8-windowsservercore-ltsc2019

SHELL ["cmd", "/S", "/C"]

WORKDIR /TEMP
 
# Add installers
ADD https://aka.ms/vs/16/release/vs_BuildTools.exe vs_BuildTools2019.exe
ADD https://aka.ms/vs/16/release/vs_TestAgent.exe vs_TestAgent2019.exe
ADD https://aka.ms/vs/17/release/vs_BuildTools.exe vs_BuildTools2022.exe
ADD https://aka.ms/vs/17/release/vs_TestAgent.exe vs_TestAgent2022.exe
ADD https://github.com/ojdkbuild/ojdkbuild/releases/download/java-11-openjdk-11.0.13.8-1/java-11-openjdk-11.0.13.8-1.windows.ojdkbuild.x86_64.zip javajdk.zip
ADD https://github.com/ojdkbuild/ojdkbuild/releases/download/java-11-openjdk-11.0.13.8-1/java-11-openjdk-jre-11.0.13.8-1.windows.ojdkbuild.x86_64.zip javajre.zip

# Visual Studio 2019 Build Tools
RUN .\vs_BuildTools2019.exe \
    --quiet \
    --wait \
    --norestart \
    --nocache \
    --add Microsoft.VisualStudio.Workload.DataBuildTools \
    --add Microsoft.VisualStudio.Workload.ManagedDesktopBuildTools \
    --add Microsoft.VisualStudio.Workload.MSBuildTools \
    --add Microsoft.VisualStudio.Workload.NetCoreBuildTools \
    --add Microsoft.VisualStudio.Workload.NodeBuildTools \
    --add Microsoft.VisualStudio.Workload.WebBuildTools \
    --add Microsoft.Net.Component.4.5.TargetingPack \
    --add Microsoft.Net.Component.4.6.TargetingPack \
    --add Microsoft.Net.Component.4.7.TargetingPack \
    --add Microsoft.Net.Component.4.8.TargetingPack \
    --includeRecommended \
    --includeOptional \
    --remove Microsoft.VisualStudio.Component.Windows10SDK.10240 \
    --remove Microsoft.VisualStudio.Component.Windows10SDK.10586 \
    --remove Microsoft.VisualStudio.Component.Windows10SDK.14393 \
    --remove Microsoft.VisualStudio.Component.Windows81SDK \
    || IF "%ERRORLEVEL%"=="3010" EXIT 0;
RUN .\vs_TestAgent2019.exe --quiet --wait --norestart --nocache || IF "%ERRORLEVEL%"=="3010" EXIT 0;

# Visual Studio 2022 Build Tools
RUN .\vs_BuildTools2022.exe \
    --quiet \
    --wait \
    --norestart \
    --nocache \
    --add Microsoft.VisualStudio.Workload.DataBuildTools \
    --add Microsoft.VisualStudio.Workload.ManagedDesktopBuildTools \
    --add Microsoft.VisualStudio.Workload.MSBuildTools \
    --add Microsoft.VisualStudio.Workload.NetCoreBuildTools \
    --add Microsoft.VisualStudio.Workload.NodeBuildTools \
    --add Microsoft.VisualStudio.Workload.WebBuildTools \
    --add Microsoft.Net.Component.4.5.TargetingPack \
    --add Microsoft.Net.Component.4.6.TargetingPack \
    --add Microsoft.Net.Component.4.7.TargetingPack \
    --add Microsoft.Net.Component.4.8.TargetingPack \
    --includeRecommended \
    --includeOptional \
    --remove Microsoft.VisualStudio.Component.Windows10SDK.10240 \
    --remove Microsoft.VisualStudio.Component.Windows10SDK.10586 \
    --remove Microsoft.VisualStudio.Component.Windows10SDK.14393 \
    --remove Microsoft.VisualStudio.Component.Windows81SDK \
    || IF "%ERRORLEVEL%"=="3010" EXIT 0;
RUN .\vs_TestAgent2022.exe --quiet --wait --norestart --nocache || IF "%ERRORLEVEL%"=="3010" EXIT 0;

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'Continue'; $verbosePreference='Continue';"]

# Install Java
RUN Expand-Archive javajdk.zip; \
    Move-Item .\javajdk\java-11-openjdk-11.0.13.8-1.windows.ojdkbuild.x86_64 "${Env:ProgramFiles}\Java"; \
    Expand-Archive javajre.zip; \
    Move-Item .\javajre\java-11-openjdk-jre-11.0.13.8-1.windows.ojdkbuild.x86_64 "${Env:ProgramFiles(x86)}\Java";

WORKDIR /

# Add fonts for headless browser tests
ADD FontsToAdd.tar /Fonts/
COPY Add-Font.ps1   /Fonts/
WORKDIR /Fonts/
RUN .\Add-Font.ps1 Fonts
WORKDIR /

# Install Chocolatey
RUN Add-WindowsFeature Web-WebSockets; \
    Set-ExecutionPolicy Bypass -Scope Process -Force; \
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'));

# Install tools for builds through Chocolatey
RUN choco install git -y; \
    choco install nodejs -y; \
    choco install nuget.commandline -y; \
    choco install googlechrome -y; \
    choco install python -y;

# Set environment variables
RUN setx /M PATH $(${Env:PATH} + ';' + "${Env:ProgramFiles}\Java\bin"); \
    setx /M PATH $(${Env:PATH} + ';' + "${Env:ProgramFiles(x86)}\Java"); \
    setx /M PATH $(${Env:PATH} + ';' + "${Env:ProgramFiles}\Docker"); \
    setx /M JAVA_HOME $("${Env:ProgramFiles}\Java"); \
    setx /M java $("${Env:ProgramFiles(x86)}\Java");

# Cleanup after installs
RUN Remove-Item C:\TEMP -Recurse;
 
# Copy & run Azure Pipelines Agent startup script
COPY start.ps1 .
ENTRYPOINT .\start.ps1