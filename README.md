# appium-stf-OSX-script
Shell script for installing Appium and its dependencies for iOS Automation on macOS. It also includes installing additional dependencies for STF usage. The setup is to be used on a new and clean machine but I will try adding some checks to skip installation and setup of already available dependencies. The setup requires minimum intervention - typing the password for some sudo commands.
Requirements before running the script:
*Install Xcode*
*Open terminal and run "xcode-select --install" and install the command line tools*
*Open terminal and navigate to the folder with the script and run "chmod 700 dependencies.sh"*
*In the script change the values for LOCALUSER(the name of the user on the machine), APPIUM_VERSION(the version of appium you want to install) and APPIUMNODEVERSION(the Node.js version to use for Appium, I am using 10.16.2 as I know it is being stable for me)*
*To run the script "./dependencies.sh" in Terminal*

Script description:
1. Creates a folder for each dependency installation logs in the same folder the script is located.
2. installNVM
   *Checks if NVM is installed and if not - installs it
   *Checks if Node.js 8.16.0 is installed and if not - installs it with nvm(8.16.0 is needed for STF)
   *Checks if Node.js 10.16.2 is installed and if not - installs it with nvm(10.16.2 is used for Appium)
   *Sets nvm alias default for Node.js 8.16.0
3. installHomebrew - checks if Homebrew is installed and if not -installs it
4. installJavaOpenJDK - checks if there is Java installed and if not installs openjdk8 and sets environment variables
5. installAppium - checks if Appium 1.16.0 is installed for Node.js 10.16.2 and if not - installs it
6. installCarthage - checks if Carthage is installed and if not - installs it with brew
7. installLibimobiledevice - checks if libimobiledevice is installed and if not - installs it with brew
8. installIdeviceinstaller - checks if ideviceinstaller is installed and if not - installs it with brew
9. installIosWebKitDebugProxy - checks if ios-webkit-debug-proxy is installed and if not - installs it with brew
10. installAppiumDoctor - checks if appium-doctor is installed and if not - installs it with npm
11. installRethinkDB - checks if rethinkdb is installed and if not - installs it with brew
12. installGraphicsMagick - checks if graphicsmagick is installed and if not - installs it with brew
13. installZeroMQ - checks if zeromq is installed and if not - installs it with brew
14. installProtobuf - checks if protobuf is installed and if not - installs it with brew
15. installYasm - checks if yasm is installed and if not - installs it with brew
16. installPkgConfig - checks if pkg-config is installed and if not - installs it with brew
17. installPromise - installs promise with npm
18. installRequestPromise - installs request-promise with npm
19. installWebSocketStream - installs websocket-stream with npm
20. installMjpegConsumer - installs mjpeg-consumer with npm
21. installUdid - installs udid with npm
