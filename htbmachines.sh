#!/bin/bash


#     dMMMMb  dMP     .aMMMb  .aMMMb  dMP dMP         .aMMMb  .aMMMb dMMMMMP    This Script was made by : Black ACZ
#    dMP"dMP dMP     dMP"dMP dMP"VMP dMP.dMP         dMP"dMP dMP"VMP  .dMP"     ig : @https_acz
#   dMMMMK" dMP     dMMMMMP dMP     dMMMMK"         dMMMMMP dMP     .dMP"       github : https://github.com/BlackACZ 
#  dMP.aMF dMP     dMP dMP dMP.aMP dMP"AMF         dMP dMP dMP.aMP.dMP"         -> Hack The Box Machines 
# dMMMMP" dMMMMMP dMP dMP  VMMMP" dMP dMP         dMP dMP  VMMMP"dMMMMMP        Provided by : hack4u Academy - https://hack4u.io


#----------// Colours //-----------#
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"
#----------------------------------#

#-----------// Exit //-------------#
function ctrl_c()
{
  echo -e "\n\n${redColour}[!] -> Saliendo...${endColour}\n "
  tput cnorm $$ exit 1

}
# Ctrl_C
trap ctrl_c  INT
#----------------------------------#

#------// Global functions //------#
main_url="https://htbmachines.github.io/bundle.js"
#----------------------------------#


#----------------------------------#
#            Functions             #
#----------------------------------#
#//Help Panel
function helpPanel()
{
  echo -e "${yellowColour}|-|${endColour} How do i use it?"
  echo -e "\t-h   Show help panel"
  echo -e "\t-u   Update files"
  echo -e "\t-m   Search by name"
  echo -e "\t-y   Search the machine's resolution on Youtube"
  echo -e "\t-o   Search by OS"
  echo -e "\t-i   Seatch by ip"
  echo -e "\t-d   Search by difficulty"
  echo -e "\t-s   Search by skills"
  echo -e "\t-o -d  Search by OS and difficulty"
}
#//Search Machine
function searchMachine()
{
  machineName="$1"
  echo -e "${blueColour}|-|${endColour} Listing the properties of the machine ${blueColour}$machineName${endColour}\n"
  Machine="$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta:" | tr -d '"' | tr -d ',' | sed 's/^ *//')"
  if [ "$Machine" ]; then
    cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta:" | tr -d '"' | tr -d ',' | sed 's/^ *//'
  else
    echo -e "${redColour}|!|This machine doesn't exist${endColour}"
  fi
  echo -e "\n"
}
#//Update 
function updateFiles()
{
  if [ ! -f bundle.js ]; then
    tput civis
    echo -e "\n${yellowColour}|-|${endColour} Downloading necessary files..."
    curl -s $main_url > bundle.js
    js-beautify bundle.js | sponge bundle.js
    echo -e "${greenColour}|-|${endColour} The files have been downloaded\n"
    tput cnorm
  else
    tput civis
    #echo -e "\n${redColour}The file already exists${endColour}\n"   
    echo -e "\n${yellowColour}|-|${endColour} Checking for updates..."
    curl -s $main_url > bundle_temp.js
    js-beautify bundle_temp.js | sponge bundle_temp.js
    bundle1="$( ( md5sum bundle.js | awk '{print $1}' ) 2>/dev/null)"
    bundle2="$( ( md5sum bundle_temp.js | awk '{print $1}' ) 2>/dev/null)"
      if [ "$bundle1" == "$bundle2" ]; then
        echo -e "${redColour}|-|${endColour} The tool is updated to the latest version\n"
        rm bundle_temp.js
      else
        rm bundle.js 
        mv bundle_temp.js bundle.js
        #cat bundle_temp.js > bundle.js
        echo -e "${greenColour}|-|${endColour} Updates have been applied successfully\n"
      fi
    tput cnorm
  fi
}

function searchIP()
{
  ipAddress="$1"
  echo -e "${purpleColour}|-|${endColour} Searching for the ip: ${purpleColour}$ipAddress${endColour}"
  sourceMachine=$(grep "ip: \"$ipAddress\"" bundle.js -B 5 | grep "name:" | awk '{print $NF}' | tr -d '"' | tr -d ',')
  if [ $sourceMachine ]; then 
    echo -e "${yellowColour}|-|${endColour} Machine ${blueColour}$sourceMachine${endColour} found"
    searchMachine $sourceMachine 
  else
    echo -e "\n${redColour}|!| This machine doesn't exit${endColour}\n"
  fi
}

function YoutubeLink()
{
  sourceMachine=$1
  echo -e "${redColour}|-|${endColour} Looking for the ${redColour}$sourceMachine${endColour} resolution on ${redColour}Youtube${endColour}"
  cat bundle.js | awk "/name: \"$sourceMachine\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta:" | tr -d '"' | tr -d ',' | sed 's/^ *//' | grep youtube || echo -e "\n${redColour}|!| This machine doesn't exist${endColour}\n"
}

function Dificult()
{
  DificultM=$1
  difCheck="$(cat bundle.js| grep "dificultad: \"$DificultM\"" -B 5 | grep "name:" | awk '{print $NF}' | tr -d '"' | tr -d ',' | column)"


    if [ $DificultM == "Easy" ]; then
      DificultM="Fácil"
      difCheck="YES"
      echo -e "${greenColour}|-| List for Easy difficulty ${endColour}"
    elif [ $DificultM == Medium ]; then
      DificultM="Media"
      difCheck="YES"
      echo -e "${blueColour}|-| List for Medium difficulty ${endColour}"
    elif [ $DificultM == Hard ]; then
      DificultM="Difícil"
      difCheck="YES"
      echo -e "${redColour}|-| List for Hard difficulty ${endColour}"
    elif [ $DificultM == Insane ]; then
      echo -e "${purpleColour}|-| List for $DificultM difficulty ${endColour}"
      difCheck="YES"

    else
      echo -e "|-| Listing for $DificultM difficulty"
    fi
  
  if [ "$difCheck" ]; then
    cat bundle.js| grep "dificultad: \"$DificultM\"" -B 5 | grep "name:" | awk '{print $NF}' | tr -d '"' | tr -d ',' | column
  else
    echo -e "${redColour}|-| The Dificult $DificultM doesn't exist ${endColour}"
  fi
}

function getOS()
{
  os=$1
  os_results="$(cat bundle.js | grep "so: \"$os\"" -B 5 | grep "name:" | awk '{print $NF}' | tr -d '"' | tr -d ',' | column)"
  if [ "$os_results" ]; then
    echo -e "${blueColour}|-|${endColour} Searching for the operating system ${blueColour}$os${endColour}"
    cat bundle.js | grep "so: \"$os\"" -B 5 | grep "name:" | awk '{print $NF}' | tr -d '"' | tr -d ',' | column
  else
    echo -e "${redColour}|-| There are no machines available at the os $os ${endColour}${endColor}"
  fi
}

function Chivato_OSD()
{
  os=$1
  DificultM="$2" 
  difCheck="$(cat bundle.js| grep "dificultad: \"$DificultM\"" -B 5 | grep "name:" | awk '{print $NF}' | tr -d '"' | tr -d ',' | column)"
  os_results="$(cat bundle.js | grep "so: \"$os\"" -B 5 | grep "name:" | awk '{print $NF}' | tr -d '"' | tr -d ',' | column)"
 if [ "$os_results" ]; then
    if [ $DificultM == "Easy" ]; then
      DificultM="Fácil"
      difCheck="YES"
      echo -e "${greenColour}|-| Searching for difficulty Easy in operating system $os ${endColour}"
    elif [ $DificultM == Medium ]; then
      DificultM="Media"
      difCheck="YES"
      echo -e "${blueColour}|-| Searching for difficulty Medium in operating system $os ${endColour}"
    elif [ $DificultM == Hard ]; then
      DificultM="Difícil"
      difCheck="YES"
      echo -e "${redColour}|-| Searching for difficulty Hard in operating system $os ${endColour}"
    elif [ $DificultM == Insane ]; then
      echo -e "${purpleColour}|-| Searching for difficulty $DificultM in operating system $os ${endColour}"
      difCheck="YES"
    fi
if [ "$difCheck" ]; then
  cat bundle.js | grep "so: \"$os\"" -C 4 | grep "dificultad: \"$DificultM\"" -B 5 | grep "name:" | awk '{print $NF}' | tr -d '"' | tr -d ',' | column
else
  echo -e "${redColour}|!| There are no machines with those characteristics${endColour}"
fi
else
  echo -e "${redColour}|!| There are no machines with those characteristics${endColour}"
fi
}

function getSK()
{
  sk=$1 
  SK_chk="$(cat bundle.js | grep "skills" -B 8 | grep "$sk" -i -B6 | grep "name:" | awk '{print $NF}' | tr -d '"' | tr -d ',' | column)"
  if [ "$SK_chk" ]; then
    cat bundle.js | grep "skills" -B 6 | grep "$sk" -i -B6 | grep "name:" | awk '{print $NF}' | tr -d '"' | tr -d ',' | column
  else
    echo -e "${redColour}|!| There are no machines with those characteristics${endColour}"
  fi
}

#//indicators
declare -i pCounter=0
#//Chivato
declare -i chivato=0

#//Trap the argument
while getopts "m:y:ui:d:o:hs:" arg; do
  case $arg in 
    m) machineName=$OPTARG; let pCounter+=1;;
    u) let pCounter+=2;;
    i) ipAddress=$OPTARG; let pCounter+=3;;
    y) sourceMachine=$OPTARG; let pCounter+=4;;
    d) DificultM=$OPTARG; let chivato+=1; let pCounter+=5;;
    o) os=$OPTARG; let chivato+=1 ; let pCounter+=6;;
    s) sk=$OPTARG; let pCounter+=7;;
    h) ;;
  esac
done

if [ $pCounter -eq 1 ]; then
  searchMachine $machineName
elif [ $pCounter -eq 2 ]; then
  updateFiles
elif [ $pCounter -eq 3 ]; then
  searchIP $ipAddress
elif [ $pCounter -eq 4 ]; then
  YoutubeLink $sourceMachine
elif [ $pCounter -eq 5 ]; then
  Dificult $DificultM
elif [ $pCounter -eq 6 ]; then
  getOS $os
elif [ $chivato -eq 2 ]; then
  Chivato_OSD $os $DificultM
elif [ $pCounter -eq 7 ]; then
  getSK $sk
else
  helpPanel  
fi 








