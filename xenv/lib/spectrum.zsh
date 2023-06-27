# A script to make using 256 colors in zsh less painful.
# P.C. Shyamshankar <sykora@lucentbeing.com>
# Copied from https://github.com/sykora/etc/blob/master/zsh/functions/spectrum/

typeset -AHg FX FG BG

FX=(
  reset     "%{[00m%}"
  bold      "%{[01m%}" no-bold      "%{[22m%}"
  italic    "%{[03m%}" no-italic    "%{[23m%}"
  underline "%{[04m%}" no-underline "%{[24m%}"
  blink     "%{[05m%}" no-blink     "%{[25m%}"
  reverse   "%{[07m%}" no-reverse   "%{[27m%}"
)

for color in {000..255}; do
  FG[$color]="%{[38;5;${color}m%}"
  BG[$color]="%{[48;5;${color}m%}"
done

# Show all 256 colors with color number
function spectrum_ls() {
  setopt localoptions nopromptsubst
  local ZSH_SPECTRUM_TEXT=${ZSH_SPECTRUM_TEXT:-Arma virumque cano Troiae qui primus ab oris}
  for code in {000..255}; do
    print -P -- "$code: ${FG[$code]}${ZSH_SPECTRUM_TEXT}%{$reset_color%}"
  done
}

# Show all 256 colors where the background is set to specific color
function spectrum_bls() {
  setopt localoptions nopromptsubst
  local ZSH_SPECTRUM_TEXT=${ZSH_SPECTRUM_TEXT:-Arma virumque cano Troiae qui primus ab oris}
  for code in {000..255}; do
    print -P -- "$code: ${BG[$code]}${ZSH_SPECTRUM_TEXT}%{$reset_color%}"
  done
}

# Alternate array of specific colors to use.
#  8b        d8                                      
#   Y8,    ,8P                ,d                     
#    `8b  d8'                 88                     
#      Y88P      ,adPPYba,  MM88MMM  ,adPPYYba,      
#      d88b     a8P_____88    88     ""     `Y8      
#    ,8P  Y8,   8PP"""""""    88     ,adPPPPP88      
#   d8'    `8b  "8b,   ,aa    88,    88,    ,88      
#  8P        Y8  `"Ybbd8"'    "Y888  `"8bbdP"Y8
#           01011000 01100101 01110100 01100001

ESC=''
 

typeset -gA xcolors=(
            [black]=000               [red]=001             [green]=002            [yellow]=003
             [blue]=004           [magenta]=005              [cyan]=006             [white]=007
             [grey]=008            [maroon]=009              [lime]=010             [olive]=011
             [navy]=012           [fuchsia]=013              [aqua]=014              [teal]=014
           [silver]=015             [grey0]=016          [navyblue]=017          [darkblue]=018
            [blue3]=020             [blue1]=021         [darkgreen]=022      [deepskyblue4]=025
      [dodgerblue3]=026       [dodgerblue2]=027            [green4]=028      [springgreen4]=029
       [turquoise4]=030      [deepskyblue3]=032       [dodgerblue1]=033          [darkcyan]=036
    [lightseagreen]=037      [deepskyblue2]=038      [deepskyblue1]=039            [green3]=040
     [springgreen3]=041             [cyan3]=043     [darkturquoise]=044        [turquoise2]=045
           [green1]=046      [springgreen2]=047      [springgreen1]=048 [mediumspringgreen]=049
            [cyan2]=050             [cyan1]=051           [purple4]=055           [purple3]=056
       [blueviolet]=057            [grey37]=059     [mediumpurple4]=060        [slateblue3]=062
       [royalblue1]=063       [chartreuse4]=064    [paleturquoise4]=066         [steelblue]=067
       [steelblue3]=068    [cornflowerblue]=069     [darkseagreen4]=071         [cadetblue]=073
         [skyblue3]=074       [chartreuse3]=076         [seagreen3]=078       [aquamarine3]=079
  [mediumturquoise]=080        [steelblue1]=081         [seagreen2]=083         [seagreen1]=085
   [darkslategray2]=087           [darkred]=088       [darkmagenta]=091           [orange4]=094
       [lightpink4]=095             [plum4]=096     [mediumpurple3]=098        [slateblue1]=099
           [wheat4]=101            [grey53]=102    [lightslategrey]=103      [mediumpurple]=104
   [lightslateblue]=105           [yellow4]=106      [darkseagreen]=108     [lightskyblue3]=110
         [skyblue2]=111       [chartreuse2]=112        [palegreen3]=114    [darkslategray3]=116
         [skyblue1]=117       [chartreuse1]=118        [lightgreen]=120       [aquamarine1]=122
   [darkslategray1]=123         [deeppink4]=125   [mediumvioletred]=126        [darkviolet]=128
           [purple]=129     [mediumorchid3]=133      [mediumorchid]=134     [darkgoldenrod]=136
        [rosybrown]=138            [grey63]=139     [mediumpurple2]=140     [mediumpurple1]=141
        [darkkhaki]=143      [navajowhite3]=144            [grey69]=145   [lightsteelblue3]=146
   [lightsteelblue]=147   [darkolivegreen3]=149     [darkseagreen3]=150        [lightcyan3]=152
    [lightskyblue1]=153       [greenyellow]=154   [darkolivegreen2]=155        [palegreen1]=156
    [darkseagreen2]=157    [paleturquoise1]=159              [red3]=160           [deeppink3]=162
         [magenta3]=164       [darkorange3]=166         [indianred]=167          [hotpink3]=168
         [hotpink2]=169            [orchid]=170           [orange3]=172      [lightsalmon3]=173
       [lightpink3]=174             [pink3]=175             [plum3]=176            [violet]=177
            [gold3]=178   [lightgoldenrod3]=179               [tan]=180        [mistyrose3]=181
         [thistle3]=182             [plum2]=183           [yellow3]=184            [khaki3]=185
     [lightyellow3]=187            [grey84]=188   [lightsteelblue1]=189           [yellow2]=190
  [darkolivegreen1]=192     [darkseagreen1]=193         [honeydew2]=194        [lightcyan1]=195
             [red1]=96          [deeppink2]=197         [deeppink1]=199          [magenta2]=200
         [magenta1]=201        [orangered1]=202        [indianred1]=204           [hotpink]=206
    [mediumorchid1]=207        [darkorange]=208           [salmon1]=209        [lightcoral]=210
   [palevioletred1]=211           [orchid2]=212           [orchid1]=213           [orange1]=214
       [sandybrown]=215      [lightsalmon1]=216        [lightpink1]=217             [pink1]=218
            [plum1]=219             [gold1]=220   [lightgoldenrod2]=222      [navajowhite1]=223
       [mistyrose1]=224          [thistle1]=225           [yellow1]=226   [lightgoldenrod1]=227
           [khaki1]=228            [wheat1]=229         [cornsilk1]=230           [grey100]=231
            [grey3]=232             [grey7]=233            [grey11]=234            [grey15]=235
           [grey19]=236            [grey23]=237            [grey27]=238            [grey30]=239
           [grey35]=240            [grey39]=241            [grey42]=242            [grey46]=243
           [grey50]=244            [grey54]=245            [grey58]=246            [grey62]=247
           [grey66]=248            [grey70]=249            [grey74]=250            [grey78]=251
           [grey82]=252            [grey85]=253            [grey89]=254            [grey93]=255)

# Prints a table of ansi color code reference.
function print_ansi_color_map() {
    cat <<'EOF'
    |-------------------------------------------------------------------------------
    | Sequences:
    | fg-color: "\033[0;<1-256>m      | bg-color: "\033[<1-256>m
    | uline-color: "\033[4;<1-256>m   | bold-color: "\033[1;<1-256>m
    |-------------------------------------------------------------------------------
    | Reset Colors:
    | Color_Off='\033[0m'       # Text Reset
    |-------------------------------------------------------------------------------
    |             Regular Colors:                        Background Colors:
    |  Black='\033[0;30m'        # Black   |  On_Black='\033[40m'       # Black
    |  Red='\033[0;31m'          # Red     |  On_Red='\033[41m'         # Red
    |  Green='\033[0;32m'        # Green   |  On_Green='\033[42m'       # Green
    |  Yellow='\033[0;33m'       # Yellow  |  On_Yellow='\033[43m'      # Yellow
    |  Blue='\033[0;34m'         # Blue    |  On_Blue='\033[44m'        # Blue
    |  Purple='\033[0;35m'       # Purple  |  On_Purple='\033[45m'      # Purple
    |  Cyan='\033[0;36m'         # Cyan    |  On_Cyan='\033[46m'        # Cyan
    |  White='\033[0;37m'        # White   |  On_White='\033[47m'       # White
    |-------------------------------------------------------------------------------
    |              Underline Colors:                      Bold Colors:
    |  UBlack='\033[4;30m'       # Black   |  BBlack='\033[1;30m'       # Black
    |  URed='\033[4;31m'         # Red     |  BRed='\033[1;31m'         # Red
    |  UGreen='\033[4;32m'       # Green   |  BGreen='\033[1;32m'       # Green
    |  UYellow='\033[4;33m'      # Yellow  |  BYellow='\033[1;33m'      # Yellow
    |  UBlue='\033[4;34m'        # Blue    |  BBlue='\033[1;34m'        # Blue
    |  UPurple='\033[4;35m'      # Purple  |  BPurple='\033[1;35m'      # Purple
    |  UCyan='\033[4;36m'        # Cyan    |  BCyan='\033[1;36m'        # Cyan
    |  UWhite='\033[4;37m'       # White   |  BWhite='\033[1;37m'       # White
    |-------------------------------------------------------------------------------
    |  High Intensity:                        Bold High Intensity:
    |  IBlack='\033[0;90m'       # Black   |  BIBlack='\033[1;90m'      # Black
    |  IRed='\033[0;91m'         # Red     |  BIRed='\033[1;91m'        # Red
    |  IGreen='\033[0;92m'       # Green   |  BIGreen='\033[1;92m'      # Green
    |  IYellow='\033[0;93m'      # Yellow  |  BIYellow='\033[1;93m'     # Yellow
    |  IBlue='\033[0;94m'        # Blue    |  BIBlue='\033[1;94m'       # Blue
    |  IPurple='\033[0;95m'      # Purple  |  BIPurple='\033[1;95m'     # Purple
    |  ICyan='\033[0;96m'        # Cyan    |  BICyan='\033[1;96m'       # Cyan
    |  IWhite='\033[0;97m'       # White   |  BIWhite='\033[1;97m'      # White
    |-------------------------------------------------------------------------------
    |  High Intensity backgrounds
    |  On_IBlack='\033[0;100m'   # Black   |
    |  On_IRed='\033[0;101m'     # Red     |
    |  On_IGreen='\033[0;102m'   # Green   | 
    |  On_IYellow='\033[0;103m'  # Yellow  |
    |  On_IBlue='\033[0;104m'    # Blue    | 
    |  On_IPurple='\033[0;105m'  # Purple  |
    |  On_ICyan='\033[0;106m'    # Cyan    |
    |  On_IWhite='\033[0;107m'   # White   |
    |-------------------------------------------------------------------------------

EOF
}

function print_color_map() {
    for i in {0..255}; do 
        print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}; 
    done
}

#-------------------
