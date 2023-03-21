#!/bin/bash




: '

Author : dilush hashen
Email : dilushhashen11@gmail.com
Fiverr: https://www.fiverr.com/share/RxZXwR

'


# echo a random word with given length
# get the specific length as the arguement
random_word () {
	# word length
	available_lengths=( 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 )
	length=${available_lengths[ $(( $RANDOM % ${#available_lengths[@]} - 1 )) ]} # get a random length from above array

	# path to word list file (you can change this path with your own list)
	# when you use this script in any other location rather than this content folder (word_guess_game folder) 
	# make sure to use the absolute path to the word list file
	word_list_path="./word_list.txt"

	# get a random words array (with specific length)
	words=( $( cat $word_list_path | grep -oE "^[a-z]{$length}$" ) )

	# word length
	length=${#words[@]}

	# get a random number between $length - 1 and 0
	rand=$(( $RANDOM % ($length -1) ))

	# random word
	local rword=${words[$rand]}

	echo $rword
}


# make a string with concatinate all elements of the array 
# then echo it
array_to_string () {
	local result=""

	for value in $@
 	do
		result+="$value "
	done

	echo $result
}


# show the status to the user
# @params, tries and output array
show_status() {
	local tries=$1; shift
	local output_array=( $@ )

	# show status to user  
	echo "YOU HAVE ${tries} TRIES"
	echo -e "YOUR WORD IS : $( array_to_string ${output_array[@]} )\n"
}


# main logic
main () {
	# original word
	local word=$1

	# number of guesses player have
	local tries=${#word}

	# character array of the given word
	local arr=( $( echo $word | grep -oE "[a-z]" ) )
	
	# replace the all characters of the above array with "_"
	local output=( $( for value in ${arr[@]}; do echo "_" ; done ) )


	# show the welcome screen message
	clear
	echo -e "
    ######################
### RANDOM WORD GUESS GAME ###
    ######################
	"

	# show status to user  
	show_status $tries ${output[@]}


	# guess character
	while [ 1 ] 
	do
		decrease=1 # 0 mean don't decrease 1 mean decrease

		read -p "> " guess

		# if guess character is not valid then programme will exit
		if [ ! $guess ]
		then 
			echo "INVALID INPUT"
			exit 1
		fi

		# check if guess character in the guess array (output array)
		for char in ${arr[@]}
		do
			if [ $char == $guess ]
			then
				# only decrease should happend when your guess is wrong
				decrease=0

				for c in ${output[@]}
				do
					# if guess character is already in the output array then set decrease to 0 , that mean tries are not decreases
					if [ $c == $guess ] 
					then
						echo -e "\nTHE CHARACTER YOU GUESS IS ALREADY IN THE LIST, PLEASE TRY ANOTHER ONE (: --"
						break 2
					fi
				done
			fi
		done


		for index in ${!arr[@]}
		do
			if [ ${arr[$index]} == $guess ] # check what characters are right then replace them with actual character
			then
				output[$index]=${arr[$index]}
			fi

			# check whether win or loose
			# check if output and arr array are equal
			local count=0
			for j in ${!arr[@]} 
			do
				if [ ${arr[$j]} == ${output[$j]} ]; then
					(( count++ ))
				fi

			done

			if [ $count -eq ${#arr[@]} ] ; then
				echo -e "\n#### YOU ARE WIN (:"
				echo "THE WORD IS : $word"
				return 0
			fi
		done


		# only if decrease = 1 then tries decrease by one
		if [ $decrease -eq 1 ] 
		then
			(( tries-- )) # decrease tries by one in every wrong guess
		fi


		# if tries are over game is over
		if [ $tries -lt 1 ]; then 
			echo -e "\n### YOU ARE LOST ):"
			echo "THE WORD IS : $word"
			echo "TRY AGAIN (:"
			break 
		fi

		# show status to user  
		show_status $tries ${output[@]}
	done
}


main $( random_word $1 )



