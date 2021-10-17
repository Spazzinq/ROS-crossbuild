#!/bin/bash

# constants used for build
export TOOLCHAIN=$(pwd)/rio_toolchain.cmake
export COLCON_META=$(pwd)/colcon.meta
export YEAR=2021
export ARM_PREFIX=arm-frc${YEAR}-linux-gnueabi
export CROSS_ROOT=${HOME}/wpilib/${YEAR}/roborio/${ARM_PREFIX}
export DDS_IMPL=FastRTPS

# pull in cross root deps and compilier
echo "Confirguring cross compile sysroot"
# source ./download_deps.sh

if [[ "$DDS_IMPL" == *FastRTPS* ]]; then
	# build tinyxml2 for the target and copy to sysroot
	source ./build_target_tinyxml.sh 
else
	# Build the host copy of cyclonedds to allow for config and message generation
	source ./build_host_cyclone.sh
fi

echo "Configuring the installation"
./mark_ignore_deps.sh

# clean the last build if it exists
echo "Cleaning prior build artifacts"
rm -rf build install log

# build it!
# echo "Executing build"
colcon build --merge-install --metas ${COLCON_META} --cmake-args "--no-warn-unused-cli" \
	-DBUILD_TESTING=OFF -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN} \
	-DCMAKE_VERBOSE_MAKEFILE=ON \
	

#tar cf rclcpp_rio.tar ./install