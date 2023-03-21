#!/bin/bash



# user and computer
user="X"
computer="O"

# moves count ( right move count both computer and human ) 
count=0

# all positions
all_pos=( 1 2 3 4 5 6 7 8 9 ) 

# use positions
u_pos=( "_" "_" "_" "_" "_" "_" "_" "_" "_" ) 

# available positions
av_pos=(  $( echo ${all_pos[@]} ) ) 


# show the board
board () {
	# simple welcome message
	echo -e "\n##### TIC TAC TOE #####"

	# draw the board
	for i in {0..6..3}
	do
		echo -e "\t${u_pos[i]}|${u_pos[ $(( $i + 1 ))]}|${u_pos[ $(( $i+2 )) ]}"
	done

	echo  # empty line 
}


# then calcualte win or loose
# @params symbol
win_loose () {
	 
	symbol=$1

	# check rows
	for i in {0..6..3}
	do
		if [ ${u_pos[ $i ]} == $symbol ] && [ ${u_pos[ $(( $i+1 )) ]} == $symbol ] && [ ${u_pos[ $(( $i+2 )) ]} == $symbol ]
		then
			echo win
			return 0
		fi
	done

	# check columns
	for i in {0..2}
	do
		if [ ${u_pos[ $(( $i )) ]} == $symbol ] && [ ${u_pos[ $(( $i+3 )) ]} == $symbol ] && [ ${u_pos[ $(( $i+6 )) ]} == $symbol ]
		then
			echo win
			return 0
		fi
	done

	# check diagonals
	if [ ${u_pos[0]} == $symbol ] && [ ${u_pos[4]} == $symbol ] && [ ${u_pos[8]} == $symbol ]
	then
		echo win
		return 0
	fi

	if [ ${u_pos[2]} == $symbol ] && [ ${u_pos[4]} == $symbol ] && [ ${u_pos[6]} == $symbol ]
	then
		echo win
		return 0
	fi

	# if not match any of above things
	if [ $count -eq 9 ] 
	then
		echo loose
		return 0
	fi

	echo play
	return 0
}


# @params, item ,array elements
# remove the specific value from the array
remove_item_from_array () {
	local val=$1; shift
	previous_array=( $@ ) # create a array from array elements that pass to the function
	new_array=()

	for item in ${previous_array[@]} 
	do
		if [ "$val" != "$item" ]
		then
			new_array+=($item)
		fi
	done

	echo ${new_array[@]}
}


# get the user input ( get the position )
# then according to this user_input fill the board or echo the error msg
get_user_input () {
	# get the user input position
	read -p "Enter Position (1-9) > " user_input
	
	# check if that position is a valid position
	if [ $( echo ${all_pos[@]} | grep -oE "$user_input" ) ]
	then
		# check if that position is available 
		if [ $( echo ${av_pos[@]} | grep -oE "$user_input" ) ]
		then
			u_pos[ $(( $user_input -1 )) ]=$user # fill that position with the $user value
			av_pos=( $( remove_item_from_array $user_input ${av_pos[@]} ) ) # remove $user_input from the available array 

			(( count++ )) # increase the move count

			return 0
		else
			echo "THIS POSITION IS ALREADY USED, TRY WITH ANOTHER POSITION"
			return 1
		fi
	else
		echo "INVALID INPUT, VALUE SHOULD BE ( 1 - 9 ) INTERAGER"
		return 1
	fi
}


play_computer () {
	# check if av_pos array length is greater than o (if any position is available for next move)
	if [ ${#av_pos[@]} -gt 0 ]
	then
		local pos=$(( $RANDOM % ( ${#av_pos[@]} - 1 ) )) # select a random index in available position array 
		item=${av_pos[$pos]}  # then get the value according to the above index from av_pos array
		av_pos=( $( remove_item_from_array $item  ${av_pos[@]} ) ) # remove that value from the av_pos array

		# fill that position with $computer value in u_pos array
		# the reason to fill $item -1 not $item because av_pos array values are start with 1
		u_pos[ $(( $item -1 )) ]=$computer 

		(( count++ )) # move count increase by one

		return 0
	fi
}


# main game loop
while [ 1 ] 
do
	board  # show the baord in the screen
	get_user_input  # get the user input (position)

	# only if get_user_input function return value is 0 then play_computer function is called
	if [ $? -eq 0 ] ;then play_computer ; fi

	# check if human is win
	if [ $( win_loose $user ) == "win" ]
	then
		clear
		board
		echo "User is win (:"
		break
	fi

	# check if computer is win
	if [ $( win_loose $computer ) == "win" ]
	then
		clear
		board
		echo "Computer is Win (:"
		break
	fi

	# if every position is played then break the loop and exit the game
	if [ $count -eq 9 ] 
	then 
		echo -e "\n ##### GAME IS OVER (:"
		board

		break
	fi 
done

