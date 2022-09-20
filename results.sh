#! /bin/bash
matches_played=$1
matches=0
teams_total=0
home=()
away=()
home_goals=()
away_goals=()
points=()
teams=()

while IFS='-,:' read -r hometeam awayteam homescore awayscore
do
    home+=($hometeam)
    away+=($awayteam)
    home_goals+=($homescore)
    away_goals+=($awayscore)
    let "matches = matches+1"
done < $matches_played

#Creating an array with the unique names of the teams playing the matches
#Finding the number of teams
teams=($(echo "${home[@]}" | tr ' ' '\n' | sort -u))
teams_total=${#teams[*]}
#Initializing goals and points for all teams
for ((i=0; i<$teams_total; i++))
do
	points+=("0")
	sum_goals_given+=("0")
	sum_goals_taken+=("0")
done

 #Comparing Home team and Away team scores
for ((i=0; i<$matches; i++))
do
	if [[ "${home_goals[$i]}" -gt "${away_goals[$i]}" ]] #If HOME team won
	then
		k=0

		while [[ "$k" -lt "$teams_total" ]]
		do
			if [[ "${teams[$k]}" ==  "${home[$i]}" ]] #Find the team that won
			then
				#Add 3 points to that team
				points[$k]=$((${points[$k]} + 3))
				#Add the goals scored to the sum of the team's goals scored
				sum_goals_given[$k]=$((${sum_goals_given[$k]} + ${home_goals[$i]})) 
				#Add the goals taken to the sum of the team's goals taken
				sum_goals_taken[$k]=$((${sum_goals_taken[$k]} + ${away_goals[$i]}))
				break
			else
    			let "k = k+1" #move index
			fi
		done

		z=0

		while [[ "$z" -lt "$teams_total" ]]
		do
			if [[ "${teams[$z]}" ==  "${away[$i]}" ]] #Find the team that lost
			then
				#Add the goals scored to the sum of the team's goals scored
				sum_goals_given[$z]=$((${sum_goals_given[$z]} + ${away_goals[$i]}))
				#Add the goals taken to the sum of the team's goals taken
				sum_goals_taken[$z]=$((${sum_goals_taken[$z]} + ${home_goals[$i]}))
				break
			else
    			let "z = z+1" #move index
			fi
		done

	elif [[ "${home_goals[$i]}" -lt "${away_goals[$i]}" ]] #If AWAY team won
	then
		k=0

		while [[ "$k" -lt "$teams_total" ]]
		do
			if [[ "${teams[$k]}" ==  "${away[$i]}" ]] # Find team that won
			then
				#Add 3 points to that team
				points[$k]=$((${points[$k]} + 3))
				#Add the goals scored to the sum of the team's goals scored
				sum_goals_given[$k]=$((${sum_goals_given[$k]} + ${away_goals[$i]}))
				#Add the goals taken to the sum of the team's goals taken
				sum_goals_taken[$k]=$((${sum_goals_taken[$k]} + ${home_goals[$i]}))
				break
			else
    			let "k = k+1" #move index
			fi
		done

		z=0

		while [[ "$z" -lt "$teams_total" ]]
		do 
			if [[ "${teams[$z]}" ==  "${home[$i]}" ]] #Find the team that lost
			then
				#Add the goals scored to the sum of the team's goals scored
				sum_goals_given[$z]=$((${sum_goals_given[$z]} + ${home_goals[$i]}))
				#Add the goals taken to the sum of the team's goals taken
				sum_goals_taken[$z]=$((${sum_goals_taken[$z]} + ${away_goals[$i]}))
				break
			else
    			let "z = z+1" #move index
			fi
		done
	else #If NOBODY won - TIE MATCH

		k=0
		while [[ "$k" -lt "$teams_total" ]]
		do
			if [[ "${teams[$k]}" ==  "${home[$i]}" ]] #Find Home team
			then
				#Add 1 point to that team
				points[$k]=$((${points[$k]} + 1)) 
				#Add the goals scored to the sum of the team's goals scored
				sum_goals_given[$k]=$((${sum_goals_given[$k]} + ${home_goals[$i]}))
				#Add the goals taken to the sum of the team's goals taken
				sum_goals_taken[$k]=$((${sum_goals_taken[$k]} + ${away_goals[$i]}))
				break
			else
    			let "k = k+1" #move index
			fi
		done

		z=0

		while [[ "$z" -lt "$teams_total" ]]
		do
			if [[ "${teams[$z]}" ==  "${away[$i]}" ]] #Find Away team
			then
				#Add 1 point to that team
				points[$z]=$((${points[$z]} + 1))
				#Add the goals scored to the sum of the team's goals scored
				sum_goals_given[$z]=$((${sum_goals_given[$z]} + ${away_goals[$i]}))
				#Add the goals taken to the sum of the team's goals taken
				sum_goals_taken[$z]=$((${sum_goals_taken[$z]} + ${home_goals[$i]}))
				break
			else
    			let "z = z+1" #move index
			fi
		done
	fi
done


for (( i=0; i<$teams_total; i++ ))
do
	echo -e '\t' ${teams[$i]} '\t' ${points[$i]} '\t' ${sum_goals_given[$i]}"-"${sum_goals_taken[$i]}  >> standings.txt
	
done

sort -r -k 2,2 standings.txt

rm standings.txt