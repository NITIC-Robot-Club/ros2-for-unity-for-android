#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPTPATH=$(dirname "$SCRIPT")

if [ -z "${ROS_DISTRO}" ]; then
    echo "Can't detect ROS2 version. Source your ros2 distro first. Foxy and Galactic are supported"
    exit 1
fi

echo "========================================="
echo "* Pulling ros2cs repository:"
vcs import < "ros2cs.repos"

echo ""
echo "========================================="
echo "Pulling custom repositories:"
vcs import < "ros2_for_unity_custom_messages.repos"

echo ""
echo "========================================="
echo "Pulling ros2cs dependencies:"
cd "$SCRIPTPATH/src/ros2cs"
./get_repos.sh
source android_patch.sh
cd -

echo ""
echo "========================================="
echo "Removing lttngpy from ros2_tracing if exists (Jazzy workaround):"
LTTNGPY_PATH="$SCRIPTPATH/src/ros2cs/src/ros2/ros2_tracing/lttngpy"
if [ -d "$LTTNGPY_PATH" ]; then
    echo "Removing $LTTNGPY_PATH"
    rm -rf "$LTTNGPY_PATH"
else
    echo "No lttngpy directory found at $LTTNGPY_PATH — skipping."
fi
