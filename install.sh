#!/bin/bash

set -eu

#if [[ $EUID -ne 0 ]]; then
#  echo "This script must be run as root"
#  exit 1
#fi
# Check dependencies
if type curl &>/dev/null; then
  echo "" &>/dev/null
else
  echo "You need to install 'curl' to use the chatgpt script."
  exit
fi
if type jq &>/dev/null; then
  echo "" &>/dev/null
else
  echo "You need to install 'jq' to use the chatgpt script."
  exit
fi

# Installing imgcat if using iTerm
if [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
  if [[ ! $(which imgcat) ]]; then
    curl -sS https://iterm2.com/utilities/imgcat -o /usr/local/bin/imgcat
    chmod +x /usr/local/bin/imgcat
    echo "Installed imgcat"
  fi
fi

# Installing chatgpt script
curl -sS https://raw.githubusercontent.com/0xacx/chatGPT-shell-cli/main/chatgpt.sh -o "$HOME/bin/chatgpt"
chmod +x "$HOME/bin/chatgpt"
echo "Installed chatgpt script to /usr/local/bin/chatgpt"

if [ -z "${OPENAI_KEY:-}" ]; then
	read -p "Please enter your OpenAI API key: " OPENAI_KEY
fi

# Adding OpenAI key to shell profile
# zsh profile
if [ -f ~/.zprofile ]; then
  echo "export OPENAI_KEY=$OPENAI_KEY" >>~/.zprofile
  echo 'export PATH=$PATH:$HOME/bin' >>~/.zprofile
  echo "OpenAI key and chatgpt path added to ~/.zprofile"
  source ~/.zprofile
# bash profile mac
elif [ -f ~/.bash_profile ]; then
  echo "export OPENAI_KEY=$OPENAI_KEY" >>~/.bash_profile
  echo 'export PATH=$PATH:$HOME/bin' >>~/.bash_profile
  echo "OpenAI key and chatgpt path added to ~/.bash_profile"
  source ~/.bash_profile
# profile ubuntu
elif [ -f ~/.profile ]; then
  echo "export OPENAI_KEY=$OPENAI_KEY" >>~/.profile
  echo 'export PATH=$PATH:$HOME/bin' >>~/.profile
  echo "OpenAI key and chatgpt path added to ~/.profile"
  source ~/.profile
else
  export OPENAI_KEY=$OPENAI_KEY
  echo "You need to add this to your shell profile: export OPENAI_KEY=$OPENAI_KEY and have $HOME/bin on your PATH"
fi
echo "Installation complete"
