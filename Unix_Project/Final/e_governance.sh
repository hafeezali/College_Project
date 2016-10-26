#!/bin/bash

#Welcome Dialog
zenity --info \
	--title="E-governance" \
	--text="Welcome to the E-governance System!" \
	--width=300 \
	--height=100 \
	--timeout=5 
#initially input = 1 to start the loop
input=1
while [ $input -ne 4 ]
do
	#Menu Dialog
	#The option chosen is stored in the variable input
	input=$(zenity --list \
		--title="Menu:" \
		--text="Choose an Option:" \
		--column="Choise" \
		--column="Description" \
		1 Add \
		2 Delete \
		3 Display \
		4 Exit )
	#If cancel is pressed then the zenity command returns 1
	if [ $? -eq 1 ]
	then
		input=0
	fi
	case $input in
		1)
			zenity --forms --title="Add Member" \
				--text="Enter information about the member:" \
				--separator="|" \
				--add-entry="First Name" \
				--add-entry="Middle Name" \
				--add-entry="Last Name" \
				--add-entry="Email" \
				--add-entry="Address-Line 1" \
				--add-entry="Address-Line 2" \
			 	--add-entry="Address-Line 3" \
				--add-entry="Address-Line 4" \
				--add-entry="Phone number +91" \
				--add-entry="Father's Name" \
				--add-entry="Mother's Name" \
				--add-entry="Nationality" \
				--add-entry="Blood Group" \
				--add-entry="Branch" \
				--add-calendar="Date-of-birth" >> file.txt

			case $? in
				0) 
					flag=0
       					while [ $flag == 0 ]
       					do
						#$RANDOM function generates a random number which ranges from 0 to 32,767
     				        	id=$(echo "$RANDOM+1" | bc)
						#count is used to check if the generated id is already present in the file
 				                count=$(cut -d \| -f 1 id_file | grep $id |wc -l)
                		 		if [ $count == 0 ]
               					then
                			        	flag=1
             					fi
        				done
					echo $id >> id_file
					zenity --info \
						--title="Member added!" \
						--text="Member I.D. : $id" \
						--width=300 \
						--height=100 \
						--timeout=5
					;;
				1)
					zenity --warning \
						--title="WARNING!" \
						--text="No member was added!" \
						--timeout=5
					;;
				-1)
					zenity --error \
						--title="ERROR!" \
						--text="An unexpected error has occurred!" \
						--timeout=5
					;;
			esac
			;;
		2)
			#deleting the older file if it exists
			for FILE in *
			do
				if [ $FILE == id_name.csv ]
				then
					rm id_name.csv
				fi
			done
			cut -d \| -f 1 file.txt | paste id_file - >> id_name.csv
			id=$(zenity --list \
					--title="Delete Member" \
					--text="Choose the member whose data must be deleted:" \
					--column="I.D." \
					--column="Name" \
					$(tr '\n\t' '  ' < id_name.csv))
			x=$(zenity --question \
					--title="WARNING!" \
					--text="Are you sure you want to delete details of the member whose I.D. is $id" \
					--width=300 \
					--height=100 \
					--timeout=5)
			if
			;;
		3)
			;;
		4)
			zenity --info \
				--title="Bye!" \
				--text="Thank You for using the E-governance system" \
				--width=300 \
				--height=100 \
				--timeout=5
			;;
		*)
			zenity --error \
				--title="ERROR!" \
				--text="Select option 4 to exit!" \
				--timeout=5
			;;
	esac
done
