#!/bin/bash
# Author: Yevgeniy Goncharov aka xck, http://sys-adm.in
# Wrapping command script for ossec / fast searching security incident in the logs
#
PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
SCRIPT_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
ME=`basename "$0"`

#
_ALERTS=()
_MESSAGES=()
_START=()
_NET_STATUS=()
_SERVER_STATUS=()
_CLIENT_STATUS=()
_SHOW_AGENTS=()

#
usage(){
	echo "You can use arguments:
    --net-status [show]
	--server-status [stop|start|status]
	--client-status [stop|start|status]"
}

if [[ -z $1 ]]; then
	#statements
	usage
	exit 1
fi

net-status(){
    netstat -tulpn
}

show-agents(){
    /var/ossec/bin/agent_control -l
}

server-status(){
	/var/ossec/bin/ossec-control $_SERVER_STATUS
}

client-status(){
	/var/ossec/ossec-agent/bin/ossec-control $_CLIENT_STATUS
}

while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -l|--list-agents)
    _SHOW_AGENTS="$2"
    shift # past argument
    shift # past value
    ;;
    -m|--messages)
    _MESSAGES="$2"
    shift # past argument
    shift # past value
    ;;
    -n|--net-status)
    _NET_STATUS="$2"
    shift # past argument
    shift # past value
    ;;
    -c|--client-status)
    _CLIENT_STATUS=("$2")
    shift # past argument
    shift # past value
    ;;
    -s|--server-status)
    _SERVER_STATUS="$2"
    shift # past argument
    shift # past value
    ;;
    -e|--extension)
    EXTENSION="$2"
    shift # past argument
    shift # past value
    ;;
    -s|--searchpath)
    SEARCHPATH="$2"
    shift # past argument
    shift # past value
    ;;
    -l|--lib)
    LIBPATH="$2"
    shift # past argument
    shift # past value
    ;;
    --default)
    DEFAULT=YES
    shift # past argument
    ;;
    *)    # unknown option
    _START+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done

set -- "${_SHOW_AGENTS[@]}"
set -- "${_MESSAGES[@]}"
set -- "${_NET_STATUS[@]}"
set -- "${_SERVER_STATUS[@]}"
set -- "${_CLIENT_STATUS[@]}"
set -- "${_START[@]}" # restore positional parameters

#
if [[ ! -z $_SHOW_AGENTS ]]; then
    show-agents
fi

if [[ ! -z $_NET_STATUS ]]; then
    net-status
fi

if [[ ! -z $_SERVER_STATUS ]]; then
	server-status
fi

if [[ ! -z $_CLIENT_STATUS ]]; then
	client-status
fi

if [[ ! -z $_START ]]; then
	#statements
	usage
fi