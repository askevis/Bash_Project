#!/bin/bash
files=$@

#re='^[0-9]+([.][0-9]+)?$'

for ((i=0;i<${#files[@]}; i++))
do
	sumX=0
	sumY=0
	sumXY=0
	sumX2=0
	length=0
	while IFS=':' read -r X Y 
	#if ! [[ "$X" =~ "^[0-9]+$" ]]  then               #check mistakes in input
   	#	echo "error: Not a number" >&2; exit 1
   # fi
	#if ! [[ "$Y" =~ "^[0-9]+$" ]]  then			      #check mistakes in input
   #		echo "error: Not a number" >&2; exit 1
	#fi

	do
    	sumX=$(echo "scale = 2; $sumX + $X" |bc) #bc epitrepei dekadika,use echo to call bc
    	sumY=$(echo "scale = 2; $sumY + $Y" |bc)
    	temp1=$(echo "scale = 2; $X * $Y" |bc)
        sumXY=$(echo "scale = 2; $sumXY + $temp1" |bc)
    	temp=$(echo "scale = 2; $X * $X" |bc )
    	sumX2=$(echo "scale = 2; $sumX2 + $temp" |bc )
    	length=$(($length + 1))


	done < ${files[i]}
    


    t1=$(echo "scale=2; $length * $sumXY" |bc)
    t2=$(echo "scale=2; $sumX * $sumY" |bc)
    t3=$(echo "scale=2; $t1 - $t2" |bc) #ari8mhths a
    t4=$(echo "scale=2; $length * $sumX2" |bc)
    t5=$(echo "scale = 2; $sumX * $sumX" |bc )
    t6=$(echo "scale=2; $t4 - $t5" |bc) #paronomasths a
    a=$(echo "scale=2; $t3 / $t6" |bc)
    t7=$(echo "scale=2; $a * $sumX" |bc) #ari8mhths b
    t8=$(echo "scale=2; $sumY - $t7" |bc) #paronomasths b
    b=$(echo "scale=2; $t8 / $length" |bc)
    
    

    err=0
    while IFS=':' read -r X Y 
    do
       t9=$(echo "scale = 2; $a * $X" |bc)
       t10=$(echo "scale = 2; $t9 + $b" |bc)
       t11=$(echo "scale = 2; $Y - $t10" |bc)
       t12=$(echo "scale = 2; $t11 * $t11" |bc)
       err=$(echo "scale = 2; $err + $t12" |bc)

    done < ${files[i]}
    
    echo "FILE:" $files", a="$a "b="$b "c=1" "err="$err
done






