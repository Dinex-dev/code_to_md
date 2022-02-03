#!/bin/bash
# Get information from the user
echo "Path To the Directory : "
read path 
echo "Name of save file : "
read file
echo "Heading of the file : "
read heading

# function to read type of list 
typeoffun(){
echo -e "Type of list :\n 1. Bulleted\n 2. Ordered"
read listtype
if [ $listtype == "bullet" ] || [ $listtype == "bulleted" ] || [ $listtype == "b" ] || [ $listtype == 1 ]
then
  echo "list will be bulleted"
  listtype="b"
elif [ $listtype == 'order' ] || [ $listtype == 'ordered' ] || [ $listtype == 'o' ] || [ $listtype == 2 ]
then
  echo -e "Sort by : \n 1. Date \n 2. Name \n 3. Size \n 4. Type \n 5. Permissions"
  read sortby
  if [ $sortby == 1 ]
  then
    echo "list will be ordered by date"
    sortby="-t"
  elif [ $sortby == 2 ]
  then
    echo "list will be ordered by name"
    sortby="-k"
  elif [ $sortby == 3 ]
  then
    echo "list will be ordered by size"
    sortby="-S"
  elif [ $sortby == 4 ]
  then
    echo "list will be ordered by type"
    sortby="-T"
  elif [ $sortby == 5 ]
  then
    echo "list will be ordered by permissions"
    sortby="-p"
  else
    echo "list will be ordered by name"
    sortby="-k"
    exit
  fi
  listtype="o"
else
  echo -e "list type not recognized \n accepted values are : \n For bulleted list : [bullet, bulleted, b] \n For Ordered List : [order, ordered, o])"
  typeoffun
  exit
fi
}

#calling function to read list
typeoffun

#saving names of files in .list.csv file
ls $sortby $path >> .list.csv
echo "# $heading " > $file
declare -i x=1

while read line
do
    echo -e "\n" >> $file
    if [[ $listtype == "b" ]]
    then
      echo -e "- $line" >> $file
    else
      echo -e "$x. $line" >> $file
    fi
    echo -e "\n" >> $file
    echo "\`\`\` ${line##*.} " >> $file  
    cat "$path/$line" >> ./$file
    echo -e "\n" >> $file
    echo "\`\`\`" >> $file
    x=x+1
done < .list.csv

#removing .list.csv file
rm .list.csv