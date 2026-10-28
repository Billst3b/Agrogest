@echo off
set "JAVA_HOME=C:\Program Files\Microsoft\jdk-25.0.4.101-hotspot"
set "CATALINA_HOME=C:\Users\Shahin\tools\apache-tomcat-10.1.61"
set "MAVEN_HOME=C:\Users\Shahin\tools\apache-maven-3.9.9"

echo [1/3] A compilar o AgroGest com Maven...
call "%MAVEN_HOME%\bin\mvn.cmd" package -DskipTests
if errorlevel 1 (
    echo Erro ao compilar o projeto.
    pause
    exit /b %errorlevel%
)

echo [2/3] A copiar agrogest.war para o Tomcat...
copy /Y "%~dp0target\agrogest.war" "%CATALINA_HOME%\webapps\agrogest.war"

echo [3/3] A iniciar o Apache Tomcat...
echo Abrindo em: http://localhost:8080/agrogest/
call "%CATALINA_HOME%\bin\catalina.bat" run

