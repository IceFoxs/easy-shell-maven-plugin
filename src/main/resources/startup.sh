#!/bin/bash
cygwin=false
darwin=false
os400=false
case "$(uname)" in
CYGWIN*) cygwin=true ;;
Darwin*) darwin=true ;;
OS400*) os400=true ;;
esac
error_exit() {
  echo "ERROR: $1 !!"
  exit 1
}
[ ! -e "$JAVA_HOME/bin/java" ] && JAVA_HOME=$HOME/jdk/java
[ ! -e "$JAVA_HOME/bin/java" ] && JAVA_HOME=/usr/java
[ ! -e "$JAVA_HOME/bin/java" ] && JAVA_HOME=/opt/taobao/java
[ ! -e "$JAVA_HOME/bin/java" ] && unset JAVA_HOME

if [ -z "$JAVA_HOME" ]; then
  if $darwin; then

    if [ -x '/usr/libexec/java_home' ]; then
      export JAVA_HOME=$(/usr/libexec/java_home)

    elif [ -d "/System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK/Home" ]; then
      export JAVA_HOME="/System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK/Home"
    fi
  else
    JAVA_PATH=$(dirname $(readlink -f $(which javac)))
    if [ "x$JAVA_PATH" != "x" ]; then
      export JAVA_HOME=$(dirname $JAVA_PATH 2>/dev/null)
    fi
  fi
  if [ -z "$JAVA_HOME" ]; then
    error_exit "Please set the JAVA_HOME variable in your environment, We need java(x64)! jdk11 or later is better!"
  fi
fi
export DEBUG=""
while getopts ":d" opt; do
  case $opt in
  d)
    DEBUG="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5005"
    JAVA_OPT="${JAVA_OPT} ${DEBUG}"
    ;;
  esac
done
export SERVER="${appNameJar}"
export JAVA="$JAVA_HOME/bin/java"
export BASE_DIR=$(
  cd $(dirname $0)/..
  pwd
)
JAVA_OPT="${JAVA_OPT} -Dapp.home=${BASE_DIR}"
JAVA_OPT="${JAVA_OPT} -Dfile.encoding=utf-8"
JAVA_OPT="${JAVA_OPT} -jar ${BASE_DIR}/target/${SERVER}.jar"
JAVA_OPT="${JAVA_OPT} --logging.config=${BASE_DIR}/config/logback-spring.xml"
JAVA_OPT="${JAVA_OPT} --logging.file.path=${BASE_DIR}/logs"
JAVA_OPT="${JAVA_OPT} --spring.config.location=${BASE_DIR}/config/application.yml"
if [ ! -d "${BASE_DIR}/logs" ]; then
  mkdir ${BASE_DIR}/logs
fi
echo "$JAVA ${JAVA_OPT}"
nohup $JAVA ${JAVA_OPT} ${appIdentityId} >>/dev/null 2>&1 &
