#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

function ctrl_c () {
  echo -e "\n[!] Saliendo...\n"
}

# Ctrl + C
trap ctrl_c INT

function helpPanel () {
  echo -e "\n[!] Panel de Ayuda:\n"
  echo -e "\t-m) Dinero con el que desea jugar"
  echo -e "\t-t) Técnica a utilizar (martingala/ilabrouchere)"
  exit 1
}

function martingala () {
  echo -e "[+] Dinero actual: ${greenColour}$money€${endColour}"
  echo -n "[?] ¿Cuánto dinero tienes pensado apostar? -> " && read initial_bet
  echo -n "[?] ¿A qué deseas apostar continuamente (par/impar)?" && read par_impar

  echo -e "[+] Vamos a jugar ${greenColour}$initial_bet€${endColour} a $par_impar por el método $tech"
  backup_bet=$initial_bet
  play_counter=0
  max_money=0
  max_lose=0
  nowlose=0
while true; do

   money=$(($money-$initial_bet))
   if [ ! "$money" -le 0 ]; then
    echo -e "\n[+] Acabas de apostar ${purpleColour}$initial_bet€${endColour} y tienes ${yellowColour}$money€${endColour}"
    random_number="$(($RANDOM % 37))"
    echo -e "Ha salido el número: ${redColour}$random_number${endColour}"
    let play_counter+=1

   if [ "$par_impar" == "par" ]; then
    if [ "$(($random_number % 2))" -eq 0 ]; then
        if [ "$random_number" -eq 0 ]; then
          echo -e "[+] Ha salido el 0, ${redColour}has perdido.${endColour}"
          initial_bet=$(($initial_bet*2))
          let nowlose+=1
          if [ $nowlose -gt $max_lose ]; then
            max_lose=$(($nowlose))
          fi
        else
          echo -e "[+] El numero que ha salido es par, ${greenColour}has ganado!${endColour}"
          reward=$(($initial_bet*2))
          echo -e "[+] Ganas $reward€"                                                                                  
          money=$(($money+$reward))
          echo -e "[+] Ahora tienes $money"
          initial_bet=$backup_bet
          if [ $money -gt $max_money ]; then
                max_money=$(($money))
          fi
          nowlose=0
        fi
    else
        echo -e "[+] El numero que ha salido es impar, ${redColour}has perdido.${endColour}"
        initial_bet=$(($initial_bet*2))
        let nowlose+=1
        if [ $nowlose -gt $max_lose ]; then
           max_lose=$(($nowlose))
        fi
    fi

#    sleep 0.05
   fi
  else
    echo -e "\n${redColour}[!] Te has quedado sin pasta cabrón${endColour}"
    echo -e "[+] Has jugado un total de $play_counter veces, tu peak ha sido de $max_money€, has perdido un máximo de $max_lose veces seguidas."
    exit 0
  fi
done
}

while getopts "m:t:h" arg; do
  case $arg in
    m) money=$OPTARG;;
    t) tech=$OPTARG;;
    h) helpPanel;;
  esac
done

if [ $money ] && [ $tech ]; then
  if [ "$tech" == "martingala" ]; then
    martingala
  else
    echo -e "[!] Técnica desconocida."
  fi
else
  helpPanel
fi                                                             
          
