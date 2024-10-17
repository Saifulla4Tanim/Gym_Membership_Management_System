#!/bin/bash

# Array to store members
declare -a members
declare -a packages=("Basic" "Premium" "VIP")
declare -a package_details=("Access to gym only" "Access to gym + classes" "All access + personal trainer")
declare -a monthly_prices=("1000" "2000" "3000")
declare -a yearly_prices=("10000" "20000" "30000")
member_count=0

# Function to display a header with ASCII art
show_header() {
    echo "========================================"
    echo "     Gym Membership Management System    "
    echo "========================================"
}

# Function to display available packages with prices
show_packages() {
    echo "Available Membership Packages (Monthly/Yearly in Taka):"
    for i in "${!packages[@]}"; do
        echo "$((i + 1)). ${packages[i]}: ${package_details[i]}"
        echo "   Monthly: ${monthly_prices[i]} Taka, Yearly: ${yearly_prices[i]} Taka"
        echo "----------------------------------------"
    done
}

# Function to add a new member with package
add_member() {
    read -p "Enter member name: " name
    show_packages
    read -p "Choose a package (1-${#packages[@]}): " package_choice

    if (( package_choice < 1 || package_choice > ${#packages[@]} )); then
        echo "Invalid package choice. Member not added."
        return
    fi

    read -p "Choose payment type: 1. Monthly 2. Yearly: " payment_type

    if (( payment_type == 1 )); then
        price="${monthly_prices[$((package_choice - 1))]}"
        payment="Monthly"
    elif (( payment_type == 2 )); then
        price="${yearly_prices[$((package_choice - 1))]}"
        payment="Yearly"
    else
        echo "Invalid payment choice. Member not added."
        return
    fi

    members[member_count]="$name - ${packages[$((package_choice - 1))]} - $payment - ${price} Taka"
    ((member_count++))
    echo "========================================"
    echo "$name has been added with ${packages[$((package_choice - 1))]} package ($payment: ${price} Taka)."
    echo "========================================"
}

# Function to view all members
view_members() {
    if [ $member_count -eq 0 ]; then
        echo "No members found."
    else
        echo "Current Members:"
        echo "----------------------------------------"
        for member in "${members[@]}"; do
            echo "- $member"
        done
        echo "----------------------------------------"
    fi
}

# Function to remove a member
remove_member() {
    read -p "Enter member name to remove: " name
    for i in "${!members[@]}"; do
        if [[ "${members[i]}" == "$name - "* ]]; then
            unset 'members[i]'
            members=("${members[@]}")  # Re-index the array
            ((member_count--))
            echo "========================================"
            echo "$name has been removed."
            echo "========================================"
            return
        fi
    done
    echo "Member not found."
}

# Function to search for a member
search_member() {
    read -p "Enter member name to search: " name
    for member in "${members[@]}"; do
        if [[ "$member" == "$name - "* ]]; then
            echo "========================================"
            echo "$name is a member with details: ${member#*- }"
            echo "========================================"
            return
        fi
    done
    echo "Member not found."
}

# Main menu loop
while true; do
    show_header
    echo "1. Add Member"
    echo "2. View Members"
    echo "3. Remove Member"
    echo "4. Search Member"
    echo "5. Exit"
    read -p "Choose an option: " choice

    case $choice in
        1) add_member ;;
        2) view_members ;;
        3) remove_member ;;
        4) search_member ;;
        5) echo "Exiting..."; exit 0 ;;
        *) echo "Invalid option. Please try again." ;;
    esac

    echo ""  # Add an empty line for better readability
done


