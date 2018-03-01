#!/bin/bash -x
MAVEN_SRC_TARBALL='http://www-us.apache.org/dist/maven/maven-3/3.5.2/binaries/apache-maven-3.5.2-bin.tar.gz'
MAVEN_SRC_SIGNATURE='https://www.apache.org/dist/maven/maven-3/3.5.2/binaries/apache-maven-3.5.2-bin.tar.gz.asc'
MAVEN_DIR='/opt/maven'
MAVEN_DEST_TARBALL="${MAVEN_DIR}/apache-maven-bin.tar.gz"
MAVEN_DEST_SIGNATURE="${MAVEN_DIR}/apache-maven-bin.tar.gz.asc"
if [ -z $JAVA_HOME ]; then
	echo 'JAVA_HOME not set, cannot continue'
	exit 1
fi
java -version 2>&1 | grep 1.8
if [ $? -ne 0 ]; then
	echo 'Java version is not 1.8'
	yum list java-1.8.0-openjdk-devel 2>/dev/null
	if [ $? -ne 0 ]; then
		echo 'Installing Java 1.8'
		sudo yum install -y java-1.8.0
		sudo yum install -y java-1.8.0-openjdk-devel
	fi
fi
java -version 2>&1 | grep 1.8
if [ $? -ne 0 ]; then
	echo 'Could not confiure Java version 1.8, exiting'
	exit 1
fi
export JAVA_HOME=`find /usr/lib/jvm/ -type d -name java-1.8.0-openjdk*.x86_64 2>/dev/null`
export JRE_HOME=${JAVA_HOME}/jre
update-alternatives --install /usr/bin/java_home java_home "${JAVA_HOME}" 999 \
        --slave /usr/bin/java java "${JAVA_HOME}/bin/java" \
        --slave /usr/bin/javac javac "${JAVA_HOME}/bin/javac" \
        --slave /usr/bin/jar jar "${JAVA_HOME}/bin/jar"
update-alternatives --set java_home "${JAVA_HOME}"

sudo mkdir -p $MAVEN_DIR
sudo wget $MAVEN_SRC_TARBALL -O $MAVEN_DEST_TARBALL
#sudo wget $MAVEN_SRC_SIGNATURE -O $MAVEN_DEST_SIGNATURE
#gpg --import KEYS
#gpg --verify $MAVEN_DEST_SIGNATURE $MAVEN_DEST_TARBALL
if [ $? -eq 0 ]; then
	cd $MAVEN_DIR
	sudo tar xvzf `basename ${MAVEN_DEST_TARBALL}`
else
	echo 'Could not verify GPG signature, exiting'
	exit 1
fi
MAVEN_BIN="${MAVEN_DIR}/apache-maven-3.5.2/bin"
echo "export JAVA_HOME=${JAVA8_SDK_HOME}" >> ${HOME}/.bashrc
echo 'export PATH=$PATH:'${MAVEN_BIN} >> ${HOME}/.bashrc
source $HOME/.bashrc
mvn -v