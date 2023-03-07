#!/bin/bash

num=$#
mono1="-m"
mono2="--mono"
stereo1="-s"
stereo2="--stereo"
rgbd1="-r"
rgbd2="--rgbd"

V102="v102"
MH50="mh50"

test_mono()
{
	if [ ${1} == $V102 ]; then
		echo "testing Monocular with Dataset: V1_02_medium..."
		./Examples/Monocular/mono_euroc Vocabulary/ORBvoc.txt Examples/Monocular/EuRoC.yaml Dataset/EuRoC/V1_02_medium/mav0/cam0/data Examples/Monocular/EuRoC_TimeStamps/V102.txt 
	elif [ ${1} == $MH50 ]; then
		echo "testing Monocular with Dataset: MH_05_difficult..."
		./Examples/Monocular/mono_euroc Vocabulary/ORBvoc.txt Examples/Monocular/EuRoC.yaml Dataset/EuRoC/MH_05_difficult/mav0/cam0/data Examples/Monocular/EuRoC_TimeStamps/MH05.txt 
	else
		echo "ERROR: unknown dataset: ${1}!"
	fi
}

test_stereo()
{
	if [ ${1} == $V102 ]; then
		echo "testing Stereo with Dataset: V1_02_medium..."
		./Examples/Stereo/stereo_euroc Vocabulary/ORBvoc.txt Examples/Stereo/EuRoC.yaml Dataset/EuRoC/V1_02_medium/mav0/cam0/data Dataset/EuRoC/V1_02_medium/mav0/cam1/data Examples/Stereo/EuRoC_TimeStamps/V102.txt
	elif [ ${1} == $MH50 ]; then
		echo "testing Stereo with Dataset: MH_05_difficult..."
		./Examples/Stereo/stereo_euroc Vocabulary/ORBvoc.txt Examples/Stereo/EuRoC.yaml Dataset/EuRoC/MH_05_difficult/mav0/cam0/data Dataset/EuRoC/MH_05_difficult/mav0/cam1/data Examples/Stereo/EuRoC_TimeStamps/MH05.txt
	else
		echo "ERROR: unknown dataset: ${1}!"
	fi
}

test_rgbd()
{
	echo "testing RGB-D with Dataset: fr2_large_with_loop..."
	./Examples/RGB-D/rgbd_tum Vocabulary/ORBvoc.txt Examples/RGB-D/TUM2.yaml Dataset/TUM/rgbd_dataset_freiburg2_large_with_loop Examples/RGB-D/associations/fr2_large_with_loop.txt
}


if [ $num == 1 ]; then
    cmd=$1
    if [ $cmd == $rgbd1 ] || [ $cmd == $rgbd2 ]; then
		test_rgbd
	else
		echo "ERROR: unknown param: $cmd!"
	fi
elif [ $num == 2 ]; then
	cmd=$1
	dataset=$2
	if [ $cmd == $mono1 ] || [ $cmd == $mono2 ]; then
		test_mono $dataset
	elif [ $cmd == $stereo1 ] || [ $cmd == $stereo2 ]; then
		test_stereo $dataset
	else
		echo "ERROR: unknown param: $cmd!"
	fi
elif (( $num >= 2 )); then
	echo "ERROR: too many arguments!"
else
	echo "ERROR: no arguments!"
fi
