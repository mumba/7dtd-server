#!/usr/bin/env bash

pid=0

trap 'exit_handler' SIGHUP SIGINT SIGQUIT SIGTERM
exit_handler()
{
	echo "Shut down signal received"
	expect /shutdown.sh
	sleep 6
	kill $pid
	exit
}

# Create the necessary folder structure
if [ ! -d "/steamcmd/7dtd/server_data" ]; then
	echo "Creating folder structure.."
	mkdir -p /steamcmd/7dtd/server_data
	echo "Copying default server configuration.."
	cp /serverconfig.xml /steamcmd/7dtd/server_data/serverconfig.xml
	echo "Creating an empty log file.."
	touch /steamcmd/7dtd/server_data/7dtd.log
fi

# Install/update steamcmd
echo "Installing/updating steamcmd.."
curl -s http://media.steampowered.com/installer/steamcmd_linux.tar.gz | tar -v -C /steamcmd -zx

# Install/update 7 Days to Die from install.txt
echo "Installing/updating 7 Days to Die.."
bash /steamcmd/steamcmd.sh +runscript /install.txt

# Set the working directory
cd /steamcmd/7dtd

# Run the server
echo "Starting 7 Days to Die.."
/steamcmd/7dtd/7DaysToDieServer.x86_64 ${SEVEN_DAYS_TO_DIE_SERVER_STARTUP_ARGUMENTS} &
pid="$!"

wait
