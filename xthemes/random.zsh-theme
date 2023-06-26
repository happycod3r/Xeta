# Deprecate XTHEME_RANDOM_BLACKLIST
if [[ -n "$XTHEME_RANDOM_BLACKLIST" ]]; then
  echo '[xeta] XTHEME_RANDOM_BLACKLIST is deprecated. Use `XTHEME_RANDOM_IGNORED` instead.'
  XTHEME_RANDOM_IGNORED=($XTHEME_RANDOM_BLACKLIST)
  unset XTHEME_RANDOM_BLACKLIST
fi

# Make themes a unique array
typeset -Ua themes

if [[ "${(t)XTHEME_RANDOM_CANDIDATES}" = array && ${#XTHEME_RANDOM_CANDIDATES[@]} -gt 0 ]]; then
  # Use XTHEME_RANDOM_CANDIDATES if properly defined
  themes=(${(@)XTHEME_RANDOM_CANDIDATES:#random})
else
  # Look for themes in $XCUSTOM and $XETA and add only the theme name
  themes=(
    "$XCUSTOM"/*.zsh-theme(N:t:r)
    "$XCUSTOM"/themes/*.zsh-theme(N:t:r)
    "$XTHEMES"/*.zsh-theme(N:t:r)
  )
  # Remove ignored themes from the list
  for theme in random ${XTHEME_RANDOM_IGNORED[@]}; do
    themes=("${(@)themes:#$theme}")
  done
fi

# Choose a theme out of the pool of candidates
N=${#themes[@]}
(( N = (RANDOM%N) + 1 ))
RANDOM_THEME="${themes[$N]}"
unset N themes theme

# Source theme
if [[ -f "$XCUSTOM/$RANDOM_THEME.zsh-theme" ]]; then
  source "$XCUSTOM/$RANDOM_THEME.zsh-theme"
elif [[ -f "$XCUSTOM/themes/$RANDOM_THEME.zsh-theme" ]]; then
  source "$XCUSTOM/themes/$RANDOM_THEME.zsh-theme"
elif [[ -f "$XTHEMES/$RANDOM_THEME.zsh-theme" ]]; then
  source "$XTHEMES/$RANDOM_THEME.zsh-theme"
else
  echo "[xeta] Random theme '${RANDOM_THEME}' not found"
  return 1
fi

if [[ "$XTHEME_RANDOM_QUIET" != true ]]; then
  echo "[xeta] Random theme '${RANDOM_THEME}' loaded"
fi
