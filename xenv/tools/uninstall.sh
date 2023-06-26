
PRE_XETA_FILE="$HOME/.shell.pre-xeta"

if hash chsh >/dev/null 2>&1 && [ -f "$PRE_XETA_FILE" ]; then
    old_shell=$(cat $PRE_XETA_FILE)
    echo "Switching your shell back to '$old_shell':"
    if chsh -s "$old_shell"; then
        rm -f "$PRE_XETA_FILE"
    else
        echo "Could not change default shell. Change it manually by running chsh"
        echo "or editing the /etc/passwd file."
        exit
    fi
fi

read -r -p "Are you sure you want to remove Xeta? [y/N] " confirmation
if [ "$confirmation" != y ] && [ "$confirmation" != Y ]; then
    echo "Uninstall cancelled"
    exit
fi

echo "Removing ~/.xeta"
if [ -d "$XETA" ]; then
    sudo rm -rf "$XETA"
fi

if [ -e "$ZSHRC" ]; then
    ZSHRC_SAVE=~/.zshrc.xeta-uninstalled-$(date +%Y-%m-%d_%H-%M-%S)
    echo "Found ~/.zshrc -- Renaming to ${ZSHRC_SAVE}"
    mv "$ZSHRC" "${ZSHRC_SAVE}"
fi

echo "Looking for original zsh config..."
ZSHRC_ORIG=~/.zshrc.pre-xeta
if [ -e "$ZSHRC_ORIG" ]; then
    echo "Found $ZSHRC_ORIG -- Restoring to ~/.zshrc"
    mv "$ZSHRC_ORIG" "$ZSHRC"
    echo "Your original zsh config was restored."
else
    echo "No original zsh config found"
fi

echo "Thanks for trying out Xeta. It's been uninstalled."
echo "Don't forget to restart your terminal or enter 'Y' to do it now!"
read -p "Close your terminal (y/n): " restart

if [[ -z "$restart" ]]; then
    echo "Bye..."
fi

if [[ "$restart" == "y" ]]; then
    exit 0
fi

