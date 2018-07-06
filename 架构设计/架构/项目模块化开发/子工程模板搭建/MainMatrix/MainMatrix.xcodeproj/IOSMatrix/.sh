#!/bin/bash

if [ $# != 1 ] ; then
	echo 'Invalid parameters'
	exit;
fi

if [ -d $1 ]; then
	echo "The directory $1 already exists, do you want to replect the it?(Y/N)"
	while read var
	do
    	if [ $var == 'Y' ]; then
			rm -rf $1
			break
		elif [ $var == 'N' ]; then
			exit
		else
			echo "Unknown command: $var"
		fi
	done
fi

appname=$1

function proc_file_content() {
	sed "s/IOSMatrix/${appname}/g" $1 > $1'.tmp'
	rm -f $1
	mv $1'.tmp' $1
}

function make_target() {
	target=`echo $1 | sed "s/IOSMatrix/${appname}/g"`
	target_length=${#target}
	proj='./IOSMatrix.xcodeproj'
	proj_length=${#proj}+1
	target_length=$target_length-$proj_length
	target=${target:proj_length:target_length}
	echo $target
}

function replace_filename() {

	source=$1
	target=`make_target "$1"`
	echo $target
	if [ -d "$source" ] ; then
		mkdir -p $target
	else
		cp $source $target
	fi

	proj='project.pbxproj'
	position=${#target}-${#proj}
	length=${#proj}
	if [ ${target:position:length} == $proj ] ; then
		proc_file_content $target
	fi

	proj='xcscheme'
	position=${#target}-${#proj}
	length=${#proj}
	if [ ${target:position:length} == $proj ] ; then
		proc_file_content $target
	fi

	proj='Aggregate.xcscheme'
	position=${#target}-${#proj}
	length=${#proj}
	if [ ${target:position:length} == $proj ] ; then
		proc_file_content $target
	fi
}

function list() {
	for file in `ls $1` 
	do

		replace_filename $1/$file

		if [ -d "$1/$file" ] ; then
			list "$1/$file";
		fi

	done
}

#cp -rf ./Portal.xcodeproj/Demo/ ./Demo
list ../IOSMatrix
#rm -rf ./Demo

