#!/bin/bash

#function to draw a line
draw_line() {
	for((i=0;i<50;i++))
	do
		printf "-"
	done
	printf "\n"
}

#function to delete the older file if it exists
del_disp_sel() {
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
}

#Welcome Dialog
zenity --info \
	--title="E-governance" \
	--text="Welcome to the E-governance System!" \
	--width=300 \
	--height=100 \
	--timeout=5 

#initially input = 1 to start the loop
input=1
while [ $input -ne 6 ]
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
		4 Modify \
		5 Tasks \
		6 Exit )
	#If cancel is pressed then the zenity command returns 1
	#$? has the last status code of a command
	if [ $? -eq 1 ]
	then
		input=0
	fi
	case $input in
		1)
			zenity --forms --title="Add Member" \
				--text="Enter information about the member:" \
				--separator="|" \
				--add-entry="First Name:" \
				--add-entry="Last Name:" \
				--add-entry="Father's Name:" \
				--add-entry="Mother's Name:" \
				--add-entry="E-mail:" \
				--add-entry="Home Town:" \
				--add-entry="Nationality:" \
				--add-entry="Phone number: +91" \
				--add-entry="Blood Group:" \
				--add-calendar="Date-of-birth:" >> file.txt

			case $? in
				0) 
					flag=0
       					while [ $flag == 0 ]
       					do
						#$RANDOM function generates a random number which ranges from 0 to 32,767
     				        	id=$(echo "$RANDOM+1" | bc)
						#count is used to check if the generated id is already present in the file
 				                count=$(cut -d \| -f 1 id_file | grep $id | wc -l)
                		 		if [ $count == 0 ]
               					then
                			        	flag=1
             					fi
        				done
					echo $id >> id_file
					num=$(grep -n $id id_file | cut -d : -f1)
					name=$(sed -n ""$num"p" file.txt | cut -d \| -f2 )
					zenity --info \
						--title="Member added!" \
						--text="Member I.D. : $id" \
						--width=300 \
						--height=100 \
						--timeout=5
					mkdir "$id $name"
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
			#for FILE in *
			#do
			#	if [ $FILE == id_name.csv ]
			#	then
			#		rm id_name.csv
			#	fi
			#done
			#cut -d \| -f 1 file.txt | paste id_file - >> id_name.csv
			#id=$(zenity --list \
			#		--title="Delete Member" \
			#		--text="Choose the member whose data must be deleted:" \
			#		--column="I.D." \
			#		--column="Name" \
			#		$(tr '\n\t' '  ' < id_name.csv))
			del_disp_sel
			if [ $? == 0 ]
			then
				zenity --question \
					--title="WARNING!" \
					--text="Are you sure you want to delete details of the member whose I.D. is $id" \
					--width=300 \
					--height=100 \
					--timeout=5
				#$?=1 if replied no to the above question and $?=0 if replied yes
				if [ $? == 0 ]
				then
					#del_line is the line number to be deleted
					del_line=$(cut -d \| -f 1 id_file | grep -n $id | cut -d : -f1)
					#'$del_line d' won't work since we're trying to retrieve the value of del_line inside(' ' cancels the special behaviour of $)
					sed -i "$del_line d" id_file
					sed -i "$del_line d" file.txt
					zenity --info \
						--title="DELETED!" \
						--text="Member data deleted from the database!" \
						--width=300 \
						--height=100 \
						--timeout=5
				elif [ $? == 1 ]
				then
					zenity --info \
						--title="INFORMATION!" \
						--text="Member data of $id not deleted" \
						--width=300 \
						--height=100 \
						--timeout=5
				else
					zenity --error \
						--title="ERROR!" \
						--text="An error has occured!" \
						--width=300 \
						--height=100 \
						--timeout=5
				fi
			elif [ $? == 1 ]
			then
				zenity --error \
					--title="ERROR!" \
					--text="No member selected!" \
					--width=300 \
					--height=100 \
					--timeout=5
			else
				zenity --error \
					--title="ERROR!" \
					--text="An error has occurred!" \
					--width=300 \
					--height=100 \
					--timeout=5
			fi
			;;
		3)
			del_disp_sel
			disp_line=$(cut -d \| -f 1 id_file | grep -n $id | cut -d : -f1)
			tput clear
			draw_line
			#name=$(
			printf "Name: "
			draw_line	
			;;
		4)
			;;
		5)
			task_input=1
			while [ $task_input -ne 4 ]
			do
				task_input=$(zenity --list \
						--title="Tasks Menu:" \
						--text="Choose an Option:" \
						--column="Choise" \
						--column="Description" \
						1 Load \
						2 Search \
						3 List \
						4 Exit )
				if [ $? -eq 1 ]
				then
					task_input=0
				fi
				case $task_input in
					1)
						for FILE in *
						do
							if [ $FILE == id_name.csv ]
							then
								rm id_name.csv
							fi
						done
						cut -d \| -f 1 file.txt | paste id_file - >> id_name.csv
						id=$(zenity --list \
								--title="Load Member" \
								--text="Choose the member whose tasks must be updated:" \
								--column="I.D." \
								--column="Name" \
								$(tr '\n\t' '  ' < id_name.csv))
						cd $id*
						task_load_input=1
						while [ $task_load_input -ne 6 ]
						do
							task_load_input=$(zenity --list \
										--title="Tasks Load Menu:" \
										--text="Choose an option:" \
										--column="Choise" \
										--column="Option" \
										1 Add_task \
										2 Edit_task \
										3 Remove_task \
										4 List \
										5 Search \
										6 Go_back )
							if [ $? -eq 1 ]
							then
								task_load_input=0
							fi
							case $task_load_input in
								1)
									name=$(zenity --entry \
											--title="Add New Task" \
											--text="Enter Task Name:" \
											--width="300" \
											--height="300" )

									zenity --forms --title="$name" \
											--text="Enter information about the task:" \
											--separator="|" \
											--add-entry="Description in few words:" \
											--add-calendar="Start Date:" \
											--add-entry="Status:" \
											--add-entry="Priority:" \
											--add-calendar="Due Date:" >> $name.txt
									;;
								2)
									name=$(zenity --entry \
											--title="Edit" \
											--text="Enter Task Name:" \
											--width="300" \
											--height="300" )
									
									ls $name.txt
									if [ $? -eq 0 ]
									then
										task_edit_input=1
										while [ $task_edit_input -ne 6 ]
										do
											task_edit_input=$(zenity --list \
													--title="Tasks Edit Menu:" \
													--text="Choose an option:" \
													--column="Choice" \
													--column="Option" \
													1 Edit_Description \
													2 Edit_Start_Date \
													3 Edit_Status \
													4 Edit_Priority \
													5 Edit_Due_Date \
													6 Go_back )
											case $task_edit_input in
												1|2|3|4|5)
													if [ $task_edit_input -eq 1 || $task_edit_input -eq 3 || $task_edit_input -eq 4 ]
													then
														replace=$(zenity --entry \
															--title="Replace Text" \
															--text="Enter replacing text:" \
															--width="300" )
													else
														replace=$(zenity --calendar \
															--title="Replace Start Date" \
															--text="Choose replacing date:" \
															--width="300" )
													fi
													for((i=1;i<=5;i++))
													do
														if [ $i -eq $task_edit_input ]
														then
															echo $replace >> temp.txt
														fi
														cut -d \| -f $i $name.txt >> temp.txt
													done
													tr '\n' '|' < temp.txt | cat > $name.txt
													rm temp.txt
													;;
												6)
													zenity --info \
															--title="Exiting" \
															--text="Thank You!" \
															--width=300 \
															--height=100 \
															--timeout=5
													;;
												*)
													zenity --error \
														--title="ERROR!" \
														--text="No option selected!" \
														--width=300 \
														--height=100 \
														--timeout=5
													#if no option is selected then white space is stored in input
													task_edit_input=0
													;;
										done
									else
										zenity --error \
											--title="ERROR!" \
											--text="$name task does not exist!" \
											--width=300 \
											--height=100 \
											--timeout=5
									fi
									;;
								3)
									name=$(zenity --entry \
											--title="Add New Task" \
											--text="Enter Task Name:" \
											--width="300" \
											--height="300" )
									
									ls $name.txt
									if [ $? -eq 0 ]
									then
										rm $name.txt
									else
										zenity --error \
												--title="ERROR!" \
												--text="$name task does not exist!" \
												--width=300 \
												--height=100 \
												--timeout=5
									fi
									;;
								4)
									ls | cat > list
									zenity --list \
											--title="List" \
											--text="The list of tasks" \
											--column="Number" \
											--column="Task" \
											$(nl list)
									;;
								5)
									name=$(zenity --entry \
										--title="Search Task" \
										--text="Enter Task Name:" \
										--width="300" \
										--height="300" )

									ls $name.txt
									if [ $? -eq 0 ]
									then
										zenity --info \
												--title="Searching Task" \
												--text="$name task exists!" \
												--width=300 \
												--height=100 \
												--timeout=5
									else
										zenity --info \
												--title="Searching Task" \
												--text="$name task does not exist!" \
												--width=300 \
												--height=100 \
												--timeout=5
									fi 
									;;
								6)
									zenity --info \
											--title="Exiting" \
											--text="Thank You!" \
											--width=300 \
											--height=100 \
											--timeout=5
									;;
								*)
									zenity --error \
										--title="ERROR!" \
										--text="No option selected!" \
										--width=300 \
										--height=100 \
										--timeout=5
									#if no option is selected then white space is stored in input
									task_load_input=0
									;;
							esac
						done
						cd ..
						;;
					2)
						name=$(zenity --entry \
									--title="Search Member" \
									--text="Enter Member Name:" \
									--width="300" \
									--height="300" )
						num=$(cut -d \| -f 1 file.txt | grep $name | wc -l)
						if [ $num -eq 0 ]
						then
							zenity --info \
									--title="Searching Task" \
									--text="$name task does not exist!" \
									--width=300 \
									--height=100 \
									--timeout=5
						else
							zenity --info \
									--title="Searching Task" \
									--text="$name task exists!" \
									--width=300 \
									--height=100 \
									--timeout=5
						fi 
						;;
					3)
						ls -l | grep "^d" | tr -s " " | cut -d " " -f 9 | cat > list
						zenity --list \
								--title="List" \
								--text="The list of tasks" \
								--column="Number" \
								--column="Task" \
								$(nl list)
						;;
					4)
						zenity --info \
							--title="Exiting Tasks Menu" \
							--text="Thank You for using the Tasks Manager!" \
							--width=300 \
							--height=100 \
							--timeout=5
						;;
					*)
						zenity --error \
							--title="ERROR!" \
							--text="No option selected!" \
							--width=300 \
							--height=100 \
							--timeout=5
						#if no option is selected then white space is stored in input
						task_input=0
						;;
				esac
			done
			;;
		6)
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
				--text="No option selected!" \
				--width=300 \
				--height=100 \
				--timeout=5
			#if no option is selected then white space is stored in input
			input=0
			;;
	esac
done
