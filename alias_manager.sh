#!/bin/bash

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Define functions
list_aliases() {
  dialog --title "Custom Aliases" \
         --msgbox "$(grep '^alias' ~/.zshrc)" 20 60
}

add_alias() {
  dialog --title "Add Alias" --inputbox "Enter alias name:" 8 40 2> /tmp/alias_name
  dialog --title "Add Alias" --inputbox "Enter alias command:" 8 40 2> /tmp/alias_command
  local alias_name=$(cat /tmp/alias_name)
  local alias_command=$(cat /tmp/alias_command)
  echo "alias $alias_name=\"$alias_command\"" >> ~/.zshrc
  source ~/.zshrc
  dialog --title "Success" --msgbox "Alias added: ${GREEN}$alias_name=$alias_command${NC}" 8 40
}

remove_alias() {
  dialog --title "Remove Alias" --inputbox "Enter alias name to remove:" 8 40 2> /tmp/alias_name
  local alias_name=$(cat /tmp/alias_name)
  sed -i "/^alias $alias_name=/d" ~/.zshrc
  source ~/.zshrc
  dialog --title "Success" --msgbox "Alias removed: ${RED}$alias_name${NC}" 8 40
}

# Main menu
while true; do
  dialog --clear --title "Alias Manager" \
         --menu "Choose an option:" 15 40 4 \
         "1" "List Aliases" \
         "2" "Add Alias" \
         "3" "Remove Alias" \
         "4" "Exit" 2> /tmp/menu_choice

  menu_choice=$(cat /tmp/menu_choice)

  case $menu_choice in
    1) list_aliases ;;
    2) add_alias ;;
    3) remove_alias ;;
    4) break ;;
    *) dialog --title "Error" --msgbox "Invalid option" 8 40 ;;
  esac
done

# Cleanup temporary files
rm /tmp/menu_choice /tmp/alias_name /tmp/alias_command 2> /dev/null

# Clear dialog
clear

