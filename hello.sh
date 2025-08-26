#!/bin/bash
#this is my world




<< comment


this is my world
good



   name="shery"

   echo "Name is $name", and date $(date)


   echo "Enter the name : "

   read username

   echo "You enter the user $username"

   sudo useradd -m $username

   echo "New User Added"
comment

   read -p "enter the name " name
  read -p "enter the level of love " love


   if [[ $name == "minahil" ]];
   then

	   echo "your lover is wrong"
   elif [[ $name != "minahil" ]];
   then
	   echo "Your lover can be loyal"
   elif [[ $love -ge 100 ]];
   then
	   echo "but shery ka pyar anmol hy "
   else 
	   echo "your lover is not wrong"
   fi

