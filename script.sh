#!/bin/bash



sciezka="/usr/share/dict/words"

nie_wypisuj_niepoprawnych=false

nie_zliczaj_pkt=false

nie_zliczaj_pkt_wartosc=0



# Sprawdzenie, czy skrypt został uruchomiony bez argumentów

if [ $# -eq 0 ]; then

    echo "Sposób użycia: ./skryptdwa [przełącznik] slowo1 slowo2 slowo3…"

    echo "Przełączniki:"

    echo "  -d  Użyj innego słownika niż domyślny"

    echo "  -w  Nie wyświetlaj niepoprawnych słów"

    echo "  -l  Nie wyliczaj wartości punktowej niepoprawnych słów"

    echo "  -h  Wyświetl pomoc"

    exit 0

fi



while [ $# -gt 0 ]; do

  case "$1" in

    -h)

      echo "Sposób użycia: ./skryptdwa [przełącznik] slowo1 slowo2 slowo3…"

      echo "Przełączniki:"

      echo "  -d  Użyj innego słownika niż domyślny"

      echo "  -w  Nie wyświetlaj niepoprawnych słów"

      echo "  -l  Nie wyliczaj wartości punktowej niepoprawnych słów"

      echo "  -h  Wyświetl pomoc"

      exit 0

      ;;

    -d)

      if [ -n "$2" ]; then

        sciezka="$2"

        shift

      else

        echo "Podaj ścieżkę do słownika!"

        exit 1

      fi

      ;;

    -w)

      nie_wypisuj_niepoprawnych=true

      ;;

    -l)

      nie_zliczaj_pkt=true

      ;;

    *)

      break

      ;;

  esac

  shift

done



if [ $# -eq 0 ]; then

  words=$(cat)

else

  words="$@"

fi



slownik=$(tr 'A-Z' 'a-z' < "$sciezka")



declare -A pkt_litery

pkt_litery=( ['a']=1 ['b']=3 ['c']=3 ['d']=2 ['e']=1 ['f']=4 ['g']=2 ['h']=4 ['i']=1 ['j']=8 ['k']=5 

             ['l']=1 ['m']=3 ['n']=1 ['o']=1 ['p']=3 ['q']=10 ['r']=1 ['s']=1 ['t']=1 ['u']=1 ['v']=4 

             ['w']=4 ['x']=8 ['y']=4 ['z']=10 )



for word in $words; do

  przeksztalcone_slowo="${word,,}"

  

  if [ -z "$przeksztalcone_slowo" ]; then

    continue

  fi



  if grep -qw "$przeksztalcone_slowo" <<< "$slownik"; then

    wynik=0

    for ((i=0; i<${#przeksztalcone_slowo}; i++)); do

      litera="${przeksztalcone_slowo:i:1}"

      wynik=$((wynik + pkt_litery["$litera"]))

    done

    echo -e "$word\tPoprawne\t$wynik"

  elif [ "$nie_wypisuj_niepoprawnych" = false ]; then

    if [ "$nie_zliczaj_pkt" = true ]; then

        echo -e "$word\tNiepoprawne\t$nie_zliczaj_pkt_wartosc"

    else

        wynik=0

        for ((i=0; i<${#przeksztalcone_slowo}; i++)); do

            litera="${przeksztalcone_slowo:i:1}"

            wynik=$((wynik + pkt_litery["$litera"]))

        done

        echo -e "$word\tNiepoprawne\t$wynik"

    fi

  fi

done
