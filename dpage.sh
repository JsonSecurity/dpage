#!/bin/bash

#colores
W="\e[38;2;255;255;255m"
N="\e[38;2;86;101;115m"
R="\e[38;2;232;24;10m"
G="\e[38;2;232;24;10m"
Y="\e[38;2;255;167;2m"
B="\e[38;2;2;75;255m"
P="\e[38;2;251;17;187m"
C="\e[38;2;17;251;248m"
L="\e[38;2;255;167;2m"
M="\e[38;2;178;151;240m"


#salidas/entradas
cent=$M
bord=$N
excr=$W
info=$cent

T="$bord [${cent}+${W}${bord}]$excr"
F="$bord [${cent}-${W}${bord}]$excr"

A="${W}$bord [${bol}${Y}!${W}${bord}]$excr"
E="${W}$bord [${bol}${R}✘${W}${bord}]$excr"
S="${W}$bord [${bol}${G}✓${W}${bord}]$excr"

I="$bord [${cent}\$${bord}]${cent}❯$excr"
U="$bord [${cent}${bord}]${cent}❯$excr"

YN="$bord[${cent}Y${bord}/${cent}N${bord}]${excr}"

#info
autor="${bol}$bord [$W ${info}Json Security${bord} ]"
script="${bol}$bord [$W ${info}dpage${bord} ]"

name="web"

banner() {
	echo -e """$M
   |\                           
    \\\\\\          _     _         
   / \\\\\\ -_-_   < \,  / \\\\\\  _-_  
  || || || \\\\\\  /-|| || || || \\\\\\ 
  || || || || (( || || || ||/   
   \\\\\\/  ||-'   \\\\/\\\\\\ \\\\\\_-| \\\\\\,/  
        |/           /  \       
        '           '----\`   
$autor $script   
	"""	
}

verify() {
	if [[ ! -d webs ]];then
		mkdir webs
	fi
}

cloning() {
	#curl -sN $url -o index.html
	if [[ $start == "true" ]];then
		echo -e "$cent cloning...\n"
		wget -r -p $url -P webs -q --show-progress
		sleep 1
		clear
		banner
	fi
}

dpage() {
	echo -e "$cent dpage...\n"
	
	#rand=$(tr -dc 'a-z' < /dev/urandom | fold -w 3 | head -n 1)

	#mkdir "webs/${name}_${rand}"
	
	#cd "webs/${name}_${rand}"
	#mv ../../index.html .

	name=$(ls webs/ -t | head -n 1)

	cd "webs/${name}"

	

	#wp=$(cat index.html | grep wp-)

	#if [[ ! -n $wp ]];then
	sed -i -e 's!https://redneck.media/!/!g' index.html
	#else
		#echo -e "$A Warning$cent WordPress$excr detected\n"
	#fi

	port="8080"
	ip=$(ifconfig | grep 192.168 | grep inet | awk '{print $2}')

	echo > data.txt

	php -S "0.0.0.0:${port}" > data.txt 2>&1 &

	if [[ $web ]];then
		echo -e "$cent opening web...\n"
		xdg-open "http://${ip}:8080"
	else
		echo -e "$A Open web in$cent http://${ip}:${port}\n"
	fi
	
	while true;do
		notfound=$(cat data.txt | grep 404 | tr '?' ' ' | tr ' ' '\n' | grep /)
		#echo $notfound
		if [[ -n $notfound ]];then
			while read line;do
				wget "${url}$line" > /dev/null 2>&1

				echo -e "$A $line"
				
				fname=$(echo $line | tr '/' '\n' | tail -n 1)
				dname=$(echo $line | sed 's!/!!' | sed 's!'"$fname"'!!')

				echo -e "$T Move:$W $fname $dname\n"
				mkdir $dname &>/dev/null
				
				mv $fname $dname
				
				sleep 5
				
			done <<< $notfound
			echo ""
			echo "" > data.txt
			if [[ $web ]];then
				echo -e "$cent opening web...\n"
				xdg-open "http://${ip}:8080"
			else
				echo -e "$A Open web in$cent http://${ip}:${port}\n"
			fi
		fi
		sleep 5
	done
}

help() {
	echo -e "\n[+] Usage: 
	
 $0 -u <url>    # page url
 $0 -f <file>   # index.html
 $0 -w          # open web
 $0 -s          # start
 $0 -h          # help
	"
	exit 1
}

if [[ ! $1 ]];then
	help
fi

banner
verify

while getopts h,u:,f:,w,s arg;do
	case $arg in
		h) help;;
		u) url=$OPTARG;cloning;;
		f) file=$OPTARG;fclon;;
		w) web=$OPTARG;;
		s) start=true;;
	esac
done

dpage
