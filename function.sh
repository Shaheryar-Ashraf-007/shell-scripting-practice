#!/bin/bash


<<comment

pracice of functions

comment

   create_directory(){
	   mkdir demo



}



if ! create_directory;
then
	echo "this repository already exist"
	exit 1
fi

echo "this should not working because code is intrupted"
