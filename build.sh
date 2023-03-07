#!/bin/bash

num=$#
fast1="-f"
fast2="--fast"
normal1="-n"
normal2="--normal"
help1="-h"
help2="--help"

normal_build()
{
	echo "Configuring and building ORB_SLAM2 ..."

	rm -rf build
	mkdir build
	cd build

	cmake .. -DCMAKE_BUILD_TYPE=Release

	make -j12

	cd ..

	echo "normal build finished!"
}

fast_build()
{
	if [ ! -d "build" ]; then
		echo "WARNING: build folder does not exist, normal build will start！"
		normal_build
	else
		echo "Configuring and building ORB_SLAM2 ..."

		cd build

		make -j12

		cd ..

		echo "fast build finished!"
	fi
}

run_help()
{
	echo "build.sh: 以指定的形式编译cmake工程"
	echo "usage: ./build.sh [选项]"
	echo "选项："
	echo "-h, --help		显示帮助信息"
	echo "-f, --fast		快速编译"
	echo "-n, --normal		正常编译"
}

if [ $num == 0 ]; then
    fast_build
elif [ $num == 1 ]; then
	cmd=$1
	if [ $cmd == $help1 ] || [ $cmd == $help2 ]; then
		run_help
	elif [ $cmd == $fast1 ] || [ $cmd == $fast2 ]; then
		fast_build
	elif [ $cmd == $normal1 ] || [ $cmd == $normal2 ]; then
		normal_build
	else
		echo "ERROR: unknown param: $cmd!"
	fi
elif (( $num >= 2 )); then
    echo "ERROR: too many arguments!"
fi

