
function io::out() {
    if [[ $# -eq 0 || -z "$1" ]]; then
        printf "$0(): Empty or no argument/s passed." | cut -d'%' -f1
        return 1
    fi
    printf "$@\n" | cut -d'%' -f1
}

function io::pf() {
    if [[ $# -eq 0 || -z "$1" ]]; then
        printf "$0(): Empty or no argument/s passed." | cut -d'%' -f1
        return 1
    fi
    printf "$@" | cut -d'%' -f1
}

function io::err() {
    if [[ $# -eq 0 || -z "$1" ]]; then
        printf "$0(): Empty or no argument/s passed." | cut -d'%' -f1
        return 1
    fi
    printf >&2 "$@\n" | cut -d'%' -f1
}

function io::banner() {
    cat <<'EOF'

  8b        d8                                      
   Y8,    ,8P                ,d                     
    `8b  d8'                 88                     
      Y88P      ,adPPYba,  MM88MMM  ,adPPYYba,      
      d88b     a8P_____88    88     ""     `Y8      
    ,8P  Y8,   8PP"""""""    88     ,adPPPPP88      
   d8'    `8b  "8b,   ,aa    88,    88,    ,88      
  8P        Y8  `"Ybbd8"'    "Y888  `"8bbdP"Y8
           01011000 01100101 01110100 01100001          
           
v1.0.0

EOF
}

function io::show_common_options() {
    printf "[::: google] [f1 bpytop] [f2 htop] [q exit]\n\n"
}

function io::notify() {
    if [[ $# -eq 0 || -z "$1" ]]; then
        printf "$0(): Empty or no argument/s passed." | cut -d'%' -f1
        return 1
    fi
    printf "[0;1;36;96m[[0;1;35;95mX[0;1;31;91mE[0;1;33;93mT[0;1;32;92mA[0;1;36;96m]: [0;1;36;96m$@" | cut -d'%' -f1
}

function io::notify_modified() {
    if [[ $# -eq 0 || -z "$1" ]]; then
        printf "$0(): Empty or no argument/s passed." | cut -d'%' -f1
        return 1
    fi
    printf "[0;1;35;95mM[0;1;31;91mo[0;1;33;93md[0;1;32;92mi[0;1;36;96mf[0;1;35;95mi[0;1; 31;91me[0;1;33;93md [0;1;35;95mb[0;1;31;91my [0;1;31;91mX[0;1;33;93mE[0;1;32;92mT[0;1;36;96mA [0;1;35;95mF[0;1;31;91mr[0;1;33;93ma[0;1;32;92mm[0;1;36;96me[0;1;35;95mw[0;1;31;91mo[0;1;33;93mr[0;1;32;92mk [0;1;36;96mv[0;1;35;95m1[0;1;31;91m.[0;1;33;93m0[0;1;32;92m.[0;1;36;96m0[0;1;35;95m.[0m\n" | cut -d'%' -f1
}

function io::yesno() {
    printf "[0;1;36;96m[[0;1;35;95mX[0;1;31;91mE[0;1;33;93mT[0;1;32;92mA[0;1;36;96m]: [0;1;36;96m"
    read "a?$1 [y/N] ${reset_color}"
    if [[ $a == "N" || $a == "n" || $a = "" ]]; then
        return 1
    fi
    return 0
}

autoload -Uz io::out io::pf io::err io::notify io::notify_modified
 