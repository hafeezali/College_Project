#!/bin/bash

#function to delete the older file if it exists and creating the updated file
del_disp_sel() {
	for FILE in *
	do
		if [ "$FILE" == id_name.csv ]
		then
			rm id_name.csv
		fi
	done
	cut -d \| -f 1 file.txt | paste id_file - >> id_name.csv
}

#function to print all errors
z_err() {
	zenity --error \
		--title="$1" \
		--text="$2" \
		--width=300 \
		--height=100 \
		--timeout=5
}

#function to print all warnings
z_war() {
	zenity --warning \
		--title="$1" \
		--text="$2" \
		--width=300 \
		--height=100 \
		--timeout=5
}

#function to print all infos
z_info() {
	zenity --info \
		--title="$1" \
		--text="$2" \
		--width=300 \
		--height=100 \
		--timeout=5
}

#function to print all questions
z_ques() {
	zenity --question \
		--title="$1" \
		--text="$2" \
		--width=300 \
		--height=100
}

#function for all entries
z_entr() {
	zenity --entry \
		--title="$1" \
		--text="$2" \
		--width=300 \
		--height=100
}

#Welcome Dialog
z_info "E-governance" "Welcome to the E-governance System!"

#initially input = 1 to start the loop
input=1
while [ $input -ne 5 ]
do
	#Menu Dialog
	#The option chosen is stored in the variable input
	input=$(zenity --list \
		--title="Menu:" \
		--text="Choose an Option:" \
		--width=300 \
		--height=250 \
		--column="Choice" \
		--column="Description" \
		1 Add \
		2 Delete \
		3 Display \
		4 Tasks \
		5 Exit )
	#If cancel is pressed then the zenity command returns 1
	#$? has the last status code of a command
	if [ $? -eq 1 ]
	then
		#making input=0 in order to prevent error while checking condition back in the while loop
		input=0
	fi
	case $input in
		1)
			#Form to read information about the member
			zenity --forms --title="Add Member" \
				--text="Enter information about the member:" \
				--separator="|" \
				--forms-date-format="%d/%m/%y" \
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
			#checking the exit status of the form command
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
            	#flag set to 1 so as to end the while loop
            	flag=1
   					fi
       		done
       		#adding the id to the id_file
					echo $id >> id_file
					#retrieving the name of the member
					num=$(grep -n $id id_file | cut -d : -f1)
					name=$(sed -n ""$num"p" file.txt | cut -d \| -f1 )
					z_info "Member added!" "Member I.D. : $id"
					#Making the Member folder which holds the various tasks to be done by the member
					mkdir "$id $name"
					;;
				1)
					z_war "WARNING!" "No member was added!"
					;;
				-1)
					z_err "ERROR!" "An unexpected error has occurred!"
					;;
			esac
			;;
		2)
			del_disp_sel
			#Taking the input for id
			id=$(zenity --list \
				--title="Delete Member" \
				--text="Choose the member whose data must be deleted:" \
				--width=300 \
				--height=250 \
				--column="I.D." \
				--column="Name" \
				$(tr '\n\t' '  ' < id_name.csv))
			#checking the exit status of the command
			if [ $? == 0 -a ${#id} -ne 0 ]
			then
				z_ques "WARNING!" "Are you sure you want to delete details of the member whose I.D. is $id"
				#$?=1 if replied no to the above question and $?=0 if replied yes
				if [ $? == 0 ]
				then
					#del_line is the line number to be deleted
					del_line=$(cut -d \| -f 1 id_file | grep -n $id | cut -d : -f1)
					#Deleting the details of the member from the files
					sed -i "$del_line d" id_file
					sed -i "$del_line d" file.txt
					z_info "DELETED!" "Member data deleted from the database!"
					#Deleting the corresponding folder containing the details of the tasks of the member
					rm -rf $id*
				elif [ $? == 1 ]
				then
					z_info "INFORMATION!" "Member data of $id not deleted"
				else
					z_err "ERROR!" "An error has occured!"
				fi
			elif [ $? == 1 ]
			then
				z_err "ERROR!" "No member selected!"
			else
				z_err "ERROR!" "An error has occurred!"
			fi
			;;
		3)
			del_disp_sel
			#Reading value for id
			id=$(zenity --list \
			--title="Select Member" \
			--text="Choose the member you want to select:" \
			--width=300 \
			--height=250 \
			--column="I.D." \
			--column="Name" \
			$(tr '\n\t' '  ' < id_name.csv))
			if [ $? -eq 0 -a ${#id} -ne 0 ]
			then
				#Selecting the corresponding line in the file, and displaying it in a proper format
				disp_line=$(cut -d \| -f 1 id_file | grep -n $id | cut -d : -f1)
				head -$disp_line file.txt | tail -1 | tr '| ' '\n_' > templist
				paste -d '\t' attributefile templist > templist1
				zenity --list \
					--title="Member Details" \
					--width=500 \
					--height=400 \
					--column="Attributes" \
					--column="Values" \
					$(tr '\n\t' ' ' < templist1)
			else
				z_err "ERROR!" "An error has occurred!"
			fi	
			;;
		4)
			task_input=1
			while [ $task_input -ne 4 ]
			do
				#Taking input for task_input variable
				task_input=$(zenity --list \
					--title="Tasks Menu:" \
					--text="Choose an Option:" \
					--width=300 \
					--height=250 \
					--column="Choice" \
					--column="Description" \
					1 Load \
					2 Search \
					3 List \
					4 Exit )
				#Checking the exit status of the command
				if [ $? -eq 1 ]
				then
					#task_input set to zero so as not break the while loop
					task_input=0
				fi
				case $task_input in
					1)
						flag=0
						del_disp_sel
						#Taking input for loading the tasks of a member
						id=$(zenity --list \
							--title="Load Member" \
							--text="Choose the member whose tasks must be updated:" \
							--width=300 \
							--height=250 \
							--column="I.D." \
							--column="Name" \
							$(tr '\n\t' '  ' < id_name.csv))
						#Checking the exit status of the previous command
						if [ $? -eq 0 -a ${#id} -ne 0 ]
						then
							#Moving into the corresponding folder
							cd $id*
							flag=1
							task_load_input=1
							while [ $task_load_input -ne 7 ]
							do
								#Reading input for task_load_input
								task_load_input=$(zenity --list \
									--title="Tasks Load Menu:" \
									--text="Choose an option:" \
									--width=300 \
									--height=300 \
									--column="Choice" \
									--column="Option" \
									1 Add_task \
									2 Edit_task \
									3 Remove_task \
									4 List \
									5 Search \
									6 Display \
									7 Go_back )
								#Checking the exit status
								if [ $? -eq 1 ]
								then
									task_load_input=0
								fi
								case $task_load_input in
									1)
										#Reading input for task name
										name=$(z_entr "Add New Task" "Enter Task Name:")
										#Checking exit status of the previous command
										if [ $? -eq 0 -a ${#name} -ne 0 ]
										then
											ls $name.txt
											if [ $? -ne 0 ]
											then
												#Form for Task info
												zenity --forms \
													--title="$name" \
													--text="Enter information about the task:" \
													--separator="|" \
													--add-entry="Description in few words:" \
													--add-calendar="Start Date:" \
													--add-entry="Status:" \
													--add-entry="Priority:" \
													--add-calendar="Due Date:" >> $name.txt
												#Checking the exit status
												case $? in
													0) 
														z_info "Task added!" "$name task has been added!"
														;;
													1)
														z_war "WARNING!" "No task was added!"
														;;
													-1)
														z_err "ERROR!" "An unexpected error has occurred!"
														;;
												esac
											else
												z_info "INFO" "$name task already exists!"
											fi
										else
											z_err "ERROR!" "An error has occurred!"
										fi
										;;
									2)
										#Taking input for name
										name=$(z_entr "Edit" "Enter Task Name:")
										#Checking exit status of previous command
										if [ $? -eq 0 -a ${#name} -ne 0 ]
										then
											#Checking if task exists
											ls $name.txt
											if [ $? -eq 0 ]
											then
												task_edit_input=1
												while [ $task_edit_input -ne 6 ]
												do
													#Reading input for task_edit_input
													task_edit_input=$(zenity --list \
														--title="Tasks Edit Menu:" \
														--text="Choose an option:" \
														--width=300 \
														--height=250 \
														--column="Choice" \
														--column="Option" \
														1 Edit_Description \
														2 Edit_Start_Date \
														3 Edit_Status \
														4 Edit_Priority \
														5 Edit_Due_Date \
														6 Go_back )
													#Checking the exit status of the previous command
													if [ $? -eq 0 ]
													then
														case $task_edit_input in
															1|2|3|4|5)
																if [ $task_edit_input -eq 1 -o $task_edit_input -eq 3 -o $task_edit_input -eq 4 ]
																then
																#Reading input for replace variable
																	replace=$(z_entr "Replace Text" "Enter replacing text:")
																else
																	replace=$(zenity --calendar \
																		--title="Replace Date" \
																		--text="Choose replacing date:" )
																fi
																#Performing the replace operation
																for((i=1;i<=5;i++))
																do
																	if [ $i -eq $task_edit_input ]
																	then
																		echo $replace >> temp.txt
																	else
																		cut -d \| -f $i $name.txt >> temp.txt
																	fi
																done
																tr '\n' '|' < temp.txt | cat > $name.txt
																rm temp.txt
																;;
															6)
																z_info "Exiting" "Thank You!"
																;;
															*)
																z_err "ERROR!" "No option selected!"
																#if no option is selected then white space is stored in input
																task_edit_input=0
																;;
														esac
													else
														task_edit_input=1
														z_err "ERROR!" "An error has occurred!"
													fi
												done
											else
												z_err "ERROR!" "$name task does not exist!"
											fi
										else
											z_err "ERROR!" "An error has occurred!"
										fi
									;;
									3)
										#Reading input for name
										name=$(z_entr "Remove Task" "Enter Task Name:")
										#Checking exit status of the previous command
										if [ $? -eq 0 -a ${#name} -ne 0 ]
										then
											#Checking if the corresponding task exists and deleting the task
											ls $name.txt
											if [ $? -eq 0 ]
											then
												rm $name.txt
											else
												z_err "ERROR!" "$name task does not exist!"
											fi
										else
											z_err "ERROR!" "An error has occurred!"
										fi
										;;
									4)
										#Checking if folder is empty
										if [ $(ls | wc -l) -eq 0 ]
										then
											z_err "ERROR!" "Task list empty!"
										else
											zenity --list \
												--title="List" \
												--text="The list of tasks" \
												--column="Number" \
												--column="Task" \
												$(ls | nl)
										fi
										;;
									5)
										#Reading input for name variable
										name=$(z_entr "Search Task" "Enter Task Name:")
										#Checking exit status code of the previous command
										if [ $? -eq 0 ]
										then	
											if [ ${#name} -ne 0 ]
											then
												#Checking if the corresponding task exists
												ls $name.txt
												if [ $? -eq 0 ]
												then
													z_info "Searching Task" "$name task exists!"
												else
													z_info "Searching Task" "$name task does not exist!"
												fi
											else
												z_err "Error" "No name entered"
											fi
										else
											z_err "Error!" "An error has occurred!"
										fi
										;;
									6)
										if [ $(ls | wc -l) -ne 0 ]
										then
											#Reading input for name variable
											name=$(zenity --list \
												--title="Display" \
												--text="Choose the task you want to display:" \
												--column="Task" \
												$(ls))
											#Checking exit status code of the previous command
											if [ $? -eq 0 -a ${#name} -ne 0 ]
											then
												#Performing the corresponding display operation
												tr '|' '\n' < $name | cat > temp.txt
												paste -d '\t' ./../taskattribute temp.txt > templist
												zenity --list \
													--title="Task Details" \
													--text="Details Of the Task" \
													--column="Attributes" \
													--column="Values" \
													--width=300 \
													--height=300 \
													$(tr '\t ' ' _' < templist)	 
												rm temp.txt
												rm templist
											else
												z_err "Error!" "An error has occurred!"
											fi
										else
											z_info "INFO!" "Chosen Member has no task to do!"
										fi
										;;
									7)
										z_info "Exiting" "Thank You!"
										;;
									*)
										z_err "ERROR!" "No option selected!"
										#if no option is selected then white space is stored in input
										task_load_input=0
										;;
								esac
							done
						else
							z_err "Error!" "An error has occurred!"
						fi
						if [ $flag = 1 ]
						then
							cd ..
							flag=0
						fi
						;;
					2)
						#Reading input for name variable
						name=$(z_entr "Search Member" "Enter Member Name:")
						#Checking exit status code of the previous command
						if [ $? -eq 0 -a ${#name} -ne 0 ]
						then
							#Checking if the Member exists
							num=$(cut -d \| -f 1 file.txt | grep $name | wc -l)
							if [ $num -eq 0 ]
							then
								z_info "Searching Member" "$name member does not exist!"
							else
								z_info "Searching Member" "$name member exists!"
							fi
						else
							z_err "Error!" "An error has occurred!"
						fi 
						;;
					3)
						#Performing operations to display Members along with their IDs
						ls -l | grep "^d" | tr -s " " | cut -d " " -f 9,10 | cat > list
						zenity --list \
								--title="List" \
								--text="The list of Members and their IDs:" \
								--width=300 \
								--height=250 \
								--column="Number" \
								--column="ID" \
								--column="Name" \
								$(nl list)
						;;
					4)
						z_info "Exiting Tasks Menu" "Thank You for using the Tasks Manager!"
						;;
					*)
						z_err "Error!" "No option selected!"
						#if no option is selected then white space is stored in input
						task_input=0
						;;
				esac
			done
			;;
		5)
			z_info "Bye!" "Thank You for using the E-governance system"
			;;
		*)
			z_err "Error!" "No option selected!"
			#if no option is selected then white space is stored in input
			input=0
			;;
	esac
done
