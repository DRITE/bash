#! /bin/bash


identify_interpritator (){
filename=$1
firstline=$(head -n 1 $filename)
start=${firstline:0:2}
if [[ $start == "#!" ]]
 then
  inter=${firstline#*bin/}
  ind=`expr index "$inter" " -"`
  if [[ $ind > 0 ]]
  then
   let ind=ind-1
   res=${inter:0:$ind}
   echo "$res ---> $filename"
   mv "$filename" "${filename%.*}.${res}" # rename file
   let map[$res]+=1
   
  else
   echo "$inter ---> $filename"
   mv "$filename" "${filename%.*}.${inter}" # rename file
   let map[$inter]+=1
  fi
 else
  echo "Bad file---> $filename"
  let map[bad]+=1
  #`rm $filename`
fi
}



a=( `find /usr/bin -type f -perm /111` )
a+=( `find /bin -type f -perm /111` )
#if ~/bin exist then remove it
if [ -d ~/bin/ ]; then
 `rm -rf ~/bin`
fi

`mkdir ~/bin`

declare -A map # associative array

for ((i=0; i <${#a[@]} ; i++))
do
 #echo "${a[$i]}"
 `cp ${a[$i]} ~/bin`
 #identify_interpritator ${a[$i]}
done
#now working with copies of files
b=( `find * ~/bin -type f -perm /111` )
for ((i=0; i <${#b[@]} ; i++))
do
 identify_interpritator ${b[$i]}
done
#show how much different files we have
echo "We have files of following types:"
for i in "${!map[@]}"; do
 echo "$i : ${map[$i]}"
done
#---------------------------------------------------
# which files we should save?
declare -a safe # array of choosed files
echo "Вводите через ENTER расширения файлов, которые хотите оставить"
echo "Введите stop для завершения ввода расширений"
while true
do
 read m
 if [[ "$m" == "stop" ]]
 then
 break
 fi
 safe+=( $m )
done
echo "Вы выбрали:"
for ((i=0; i <${#safe[@]} ; i++)); do
 echo "${safe[$i]}"
done
#------------------------------------------------------
# delete unlucky files
for f in $b; do
 end=${f#*.}
 for target in "${safe[@]}"; do
  if [[ $end == "$target" ]]; then
    




for target in "${safe[@]}"; do
 for i in "${!map[@]}"; do
 if [[ ${i} = "$target" ]]; then
  unset ${map[i]}
 fi
 done
done
#what in map now?
echo "what in map now?"
for i in "${!map[@]}"; do
 echo "$i : ${map[$i]}"
done
