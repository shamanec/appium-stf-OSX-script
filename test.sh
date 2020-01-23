#!/bin/bash

LOCALUSER="admin"
APPIUM_VERSION="1.16.0"
APPIUMNODEVERSION="10.16.2"

BASEDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
mkdir ${BASEDIR}/dependency-logs

installNVM(){
	echo "Installing NVM and required node versions"
	{
		#Check if NVM is installed and if not - install it for easier Node.js version management
		set +e
		$(nvm --version &> /dev/null)
		EXIT_CODE=$?
		set -e
		if [ $EXIT_CODE == 0 ]; then
			echo "NVM is already installed."
		else
			#Install nvm
			echo "Installing NVM"
			touch ~/.bash_profile
			curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash
			wait
		fi

		#Reload nvm to use it
		echo "Reloading nvm to keep using it in the same terminal"
		export NVM_DIR="/Users/admin/.nvm"
		[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

		#Check nvm version
		echo "Checking NVM version"
		nvm --version
		wait

		#Check if the required Node.js version for STF is installed and if not - install it
		set +e
		$(nvm ls | grep v8.16.0 &> /dev/null)
		EXIT_CODE=$?
		set -e
		if [ $EXIT_CODE == 0 ]; then
			echo "Node.js v8.16.0 is already installed."
		else
			#Install Node.js 8.16.0 with nvm
			echo "Installing Node.js 8.16.0 with nvm"
			nvm install 8.16.0
			wait
		fi

		#Check if the required Node.js version for Appium is installed and if not - install it
		set +e
		$(nvm ls | grep v$APPIUMNODEVERSION &> /dev/null)
		EXIT_CODE=$?
		set -e
		if [ $EXIT_CODE == 0 ]; then
			echo "Node.js v$APPIUMNODEVERSION is already installed."
		else
			#Install Node.js $APPIUMNODEVERSION with nvm
			echo "Installing Node.js $APPIUMNODEVERSION with nvm"
			nvm install $APPIUMNODEVERSION
			wait
		fi

		#Make Node.js 8.16.0 the default version on nvm
		echo "Setting Node.js 8.16.0 as default alias for nvm"
		nvm alias default 8.16.0
		wait

		#Switch to Node.js 8.16.0
		echo "Switching to default nvm alias - 8.16.0"
		nvm use alias default
		wait
	} >> "${BASEDIR}/dependency-logs/install_nvm.log" 2>&1 &
}

installHomebrew(){
	echo "Install Homebrew"
	{
		set +e
		$(brew -v &> /dev/null)
		EXIT_CODE=$?
		set -e
		if [ $EXIT_CODE == 0 ]; then
			echo "Homebrew is already installed."
		else
			#Install Homebrew
			echo "Installing Homebrew"
			/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
			wait
		fi
	} >> "${BASEDIR}/dependency-logs/install_homebrew.log" 2>&1 &
}

installJavaOpenJDK(){
	echo "Install Java OpenJDK8"
	{
		set +e
		$(java -version &> /dev/null)
		EXIT_CODE=$?
		set -e
		if [ $EXIT_CODE == 0 ]; then
			echo "There is Java already installed."
		else
			#Install java
			brew tap adoptopenjdk/openjdk
			wait
			echo "Installing openJDK8 with brew"
			brew cask install adoptopenjdk8
			wait
			echo "Exporting Java home"
			echo 'export JAVA_HOME=$(/usr/libexec/java_home)' >> ~/.bash_profile
			wait
			echo "Exporting Java home bin folder"
			echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.bash_profile
			wait
		fi
	} >> "${BASEDIR}/dependency-logs/install_java.log" 2>&1 &
}

installAppium(){
	echo "Install Appium 1.16.0"
	{
		#Switch to Node.js $APPIUMNODEVERSION
		echo "Switching to Node.js $APPIUMNODEVERSION for installing Appium"
		nvm use $APPIUMNODEVERSION
		wait

		#Add permissions for appium just in case
		echo "Adding permissions for appium in node_modules just in case"
		sudo chown -R $LOCALUSER /Users/$LOCALUSER/.nvm/versions/node/v$APPIUMNODEVERSION/lib/node_modules
		wait

		set +e
		$(appium -v | grep $APPIUM_VERSION &> /dev/null)
		EXIT_CODE=$?
		set -e
		if [ $EXIT_CODE == 0 ]; then
			echo "Appium@$APPIUM_VERSION found for this Node.js version."
		else
			#Install Appium 1.16.0 with npm
			echo "Installing Appium 1.16.0 with npm"
			npm install -g appium@$APPIUM_VERSION
			wait
		fi

		#Install appium wd with npm - not sure if this is needed
		echo "Installing Appium wd"
		npm install wd
		wait
	} >> "${BASEDIR}/dependency-logs/install_appium.log" 2>&1 &
}

installCarthage(){
	echo "Install Carthage"
	{
		set +e
		$(carthage help | grep bootstrap &> /dev/null)
		EXIT_CODE=$?
		set -e
		if [ $EXIT_CODE == 0 ]; then
			echo "Carthage is already installed."
		else
			echo "Failed to carthage! Carthage is not installed."
			echo "Installing Carthage with brew"
			wait
			#Install Carthage with brew
			echo "Installing Carthage"
			brew install carthage
			wait
		fi

		set +e
		$(carthage help | grep bootstrap &> /dev/null)
		EXIT_CODE=$?
		set -e
		if [ $EXIT_CODE == 0 ]; then
			echo "Carthage is installed."
		else
			echo "Failed to carthage!"
		fi
	} >> "${BASEDIR}/dependency-logs/install_carthage.log" 2>&1 &
}


installLibimobiledevice(){
	echo "Installing libimobiledevice"
	{
		set +e
		$(brew list | grep libimobiledevice &> /dev/null)
		EXIT_CODE=$?
		set -e
		if [ $EXIT_CODE == 0 ]; then
			echo "libimobiledevice is already installed."
		else
			#Install libimobiledevice
			echo "Installing libimobiledevice with brew"
			brew install libimobiledevice
			wait
			set +e
			$(brew list | grep libimobiledevice &> /dev/null)
			EXIT_CODE=$?
			set -e
			if [ $EXIT_CODE == 0 ]; then
				echo "libimobiledevice is installed"
			else
				echo "Failed to install libimobiledevice"
			fi
		fi
	} >> "${BASEDIR}/dependency-logs/install_libimobiledevice.log" 2>&1 &
}

installIdeviceinstaller(){
	echo "Installing ideviceinstaller"
	{
		set +e
		$(brew list | grep ideviceinstaller &> /dev/null)
		EXIT_CODE=$?
		set -e
		if [ $EXIT_CODE == 0 ]; then
			echo "ideviceinstaller is already installed."
		else
			#Install ideviceinstaller
			sudo xcode-select -r
			wait
			echo "Installing ideviceinstaller with brew"
			brew install ideviceinstaller
			wait
			set +e
			$(brew list | grep ideviceinstaller &> /dev/null)
			EXIT_CODE=$?
			set -e
			if [ $EXIT_CODE == 0 ]; then
				echo "ideviceinstaller is installed"
			else
				echo "Failed to install ideviceinstaller"
			fi
		fi
	} >> "${BASEDIR}/dependency-logs/install_ideviceinstaller.log" 2>&1 &
}

installIosWebKitDebugProxy(){
	echo "Installing ios-webkit-debug-proxy"
	{
		set +e
		$(brew list | grep ios-webkit-debug-proxy &> /dev/null)
		EXIT_CODE=$?
		set -e
		if [ $EXIT_CODE == 0 ]; then
			echo "ios-webkit-debug-proxy is already installed."
		else
			#Install ios_webkit_debug_proxy
			echo "Installing ios-webkit-debug-proxy with brew"
			brew install ios-webkit-debug-proxy
		wait
			set +e
			$(brew list | grep ios-webkit-debug-proxy &> /dev/null)
			EXIT_CODE=$?
			set -e
			if [ $EXIT_CODE == 0 ]; then
				echo "ios-webkit-debug-proxy is installed"
			else
				echo "Failed to install ios-webkit-debug-proxy"
			fi
		fi
	} >> "${BASEDIR}/dependency-logs/install_ios_webkit_debug_proxy.log" 2>&1 &
}


installAppiumDoctor(){
	nvm use $APPIUMNODEVERSION
	echo "Installing Appium Doctor with npm on node $APPIUMNODEVERSION"
	{
		set +e
		$(appium-doctor --version | grep 1.13.0 &> /dev/null)
		EXIT_CODE=$?
		set -e
		if [ $EXIT_CODE == 0 ]; then
			echo "appium-doctor is already installed for Node.js $APPIUMNODEVERSION."
		else
			#Install appium-doctor and run it
			echo "Installing appium-doctor with npm"
			npm install -g appium-doctor
			wait
		fi
	} >> "${BASEDIR}/dependency-logs/install_appium_doctor.log" 2>&1 &
}

installRethinkDB(){
	echo "Install RethinkDB"
	{
		set +e
		$(brew list | grep rethinkdb &> /dev/null)
		EXIT_CODE=$?
		set -e
		if [ $EXIT_CODE == 0 ]; then
			echo "RethinkDB is already installed."
		else
			#Install RethinkDB_proxy
			echo "Installing RethinkDB with brew"
			brew install rethinkdb
			wait
			set +e
			$(brew list | grep rethinkdb &> /dev/null)
			EXIT_CODE=$?
			set -e
			if [ $EXIT_CODE == 0 ]; then
				echo "RethinkDB is installed"
			else
				echo "Failed to install RethinkDB"
			fi
		fi
	} >> "${BASEDIR}/dependency-logs/install_additional_dependencies.log" 2>&1 &
}

installGraphicsmagick(){
	echo "Install graphicsmagick"
	{
		set +e
		$(brew list | grep graphicsmagick &> /dev/null)
		EXIT_CODE=$?
		set -e
		if [ $EXIT_CODE == 0 ]; then
			echo "graphicsmagick is already installed."
		else
			#Install graphicsmagick_proxy
			echo "Installing graphicsmagick with brew"
			brew install graphicsmagick
			wait
			set +e
			$(brew list | grep graphicsmagick &> /dev/null)
			EXIT_CODE=$?
			set -e
			if [ $EXIT_CODE == 0 ]; then
				echo "graphicsmagick is installed"
			else
				echo "Failed to install graphicsmagick"
			fi
		fi
	} >> "${BASEDIR}/dependency-logs/install_additional_dependencies.log" 2>&1 &
}

installZeromq(){
	echo "Install zeromq"
	{
		set +e
		$(brew list | grep zeromq &> /dev/null)
		EXIT_CODE=$?
		set -e
		if [ $EXIT_CODE == 0 ]; then
			echo "zeromq is already installed."
		else
			#Install zeromq
			echo "Installing zeromq with brew"
			brew install zeromq
			wait
			set +e
			$(brew list | grep zeromq &> /dev/null)
			EXIT_CODE=$?
			set -e
			if [ $EXIT_CODE == 0 ]; then
				echo "zeromq is installed"
			else
				echo "Failed to install zeromq"
			fi
		fi
	} >> "${BASEDIR}/dependency-logs/install_additional_dependencies.log" 2>&1 &
}

installProtobuf(){
	echo "Install protobuf"
	{
		set +e
		$(brew list | grep protobuf &> /dev/null)
		EXIT_CODE=$?
		set -e
		if [ $EXIT_CODE == 0 ]; then
			echo "protobuf is already installed."
		else
			#Install protobuf
			echo "Installing protobuf with brew"
			brew install protobuf
			wait
			set +e
			$(brew list | grep protobuf &> /dev/null)
			EXIT_CODE=$?
			set -e
			if [ $EXIT_CODE == 0 ]; then
				echo "protobuf is installed"
			else
				echo "Failed to install protobuf"
			fi
		fi
	} >> "${BASEDIR}/dependency-logs/install_additional_dependencies.log" 2>&1 &
}

installYasm(){
	echo "Install yasm"
	{
		set +e
		$(brew list | grep yasm &> /dev/null)
		EXIT_CODE=$?
		set -e
		if [ $EXIT_CODE == 0 ]; then
			echo "yasm is already installed."
		else
			#Install yasm
			echo "Installing yasm with brew"
			brew install yasm
			wait
			set +e
			$(brew list | grep yasm &> /dev/null)
			EXIT_CODE=$?
			set -e
			if [ $EXIT_CODE == 0 ]; then
				echo "yasm is installed"
			else
				echo "Failed to install yasm"
			fi
		fi
	} >> "${BASEDIR}/dependency-logs/install_additional_dependencies.log" 2>&1 &
}

installPkgConfig(){
	echo "Install pkg-config"
	{
		set +e
		$(brew list | grep pkg-config &> /dev/null)
		EXIT_CODE=$?
		set -e
		if [ $EXIT_CODE == 0 ]; then
			echo "pkg-config is already installed."
		else
			#Install pkg-config
			echo "Installing pkg-config with brew"
			brew install pkg-config
			wait
			set +e
			$(brew list | grep pkg-config &> /dev/null)
			EXIT_CODE=$?
			set -e
			if [ $EXIT_CODE == 0 ]; then
				echo "pkg-config is installed"
			else
				echo "Failed to install pkg-config"
			fi
		fi
	} >> "${BASEDIR}/dependency-logs/install_additional_dependencies.log" 2>&1 &
}

installPromise(){
	echo "Installing Promise with npm"
	{
		#Install Promise
		npm install promise
		wait
	} >> "${BASEDIR}/dependency-logs/install_promise.log" 2>&1 &
}

installRequestPromise(){
	echo "Installing request-promise with npm"
	{
		#Install request-promise
		npm install request-promise
		wait
	} >> "${BASEDIR}/dependency-logs/install_request_promise.log" 2>&1 &
}

installWebsocketStream(){
	echo "Installing websocket-stream with npm"
	{
		#Install websocket-stream
		npm install websocket-stream
		wait
	} >> "${BASEDIR}/dependency-logs/install_websocket_stream.log" 2>&1 &
}

installMjpegConsumer(){
	echo "Installing mjpeg-consumer with npm"
	{
		#Install mjpeg-consumer
		npm install mjpeg-consumer
		wait
	} >> "${BASEDIR}/dependency-logs/install_mjpeg_consumer.log" 2>&1 &
}

installUdid(){
	echo "Installing udid with npm"
	{
		#Install udid
		npm install udid
		wait
	} >> "${BASEDIR}/dependency-logs/install_udid.log" 2>&1 &
}

installNVM
wait
echo "Reloading nvm to keep using it in the same terminal"
export NVM_DIR="/Users/admin/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
wait
installHomebrew
wait
installJavaOpenJDK
wait
installAppium
wait
installCarthage
wait
installLibimobiledevice
wait
installIdeviceinstaller
wait
installIosWebKitDebugProxy
wait
installAppiumDoctor
wait
installRethinkDB
wait
installGraphicsmagick
wait
installZeromq
wait
installProtobuf
wait
installYasm
wait
installPkgConfig
wait
installPromise
wait
installRequestPromise
wait
installWebsocketStream
wait
installMjpegConsumer
wait
installUdid
#wait
#cd ${BASEDIR}/stf-master
#wait
#npm install
#wait
#npm link
#wait
echo "Finished installing dependencies"