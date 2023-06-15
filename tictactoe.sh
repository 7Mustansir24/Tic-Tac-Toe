#!/bin/bash


# Function to print the game board
print_board() {
    local board=("$@")
    echo " ${board[0]} | ${board[1]} | ${board[2]}"
    echo "-----------"
    echo " ${board[3]} | ${board[4]} | ${board[5]}"
    echo "-----------"
    echo " ${board[6]} | ${board[7]} | ${board[8]}"
}

# Function to check if a player has won
check_winner() {
    local board=("$@")
    local winner=""

    # Check rows
    for i in 0 3 6; do
        if [[ ${board[$i]} == ${board[$i+1]} && ${board[$i]} == ${board[$i+2]} ]]; then
            winner=${board[$i]}
        fi
    done

    # Check columns
    for i in 0 1 2; do
        if [[ ${board[$i]} == ${board[$i+3]} && ${board[$i]} == ${board[$i+6]} ]]; then
            winner=${board[$i]}
        fi
    done

    # Check diagonals
    if [[ ${board[0]} == ${board[4]} && ${board[0]} == ${board[8]} ]] || [[ ${board[2]} == ${board[4]} && ${board[2]} == ${board[6]} ]]; then
        winner=${board[4]}
    fi

    echo $winner
}

# Validate the arguments
if [[ $1 != "X" && $1 != "O" ]]; then
    echo "Arg 1: must be X or O" >&2
    exit 1
fi

if [[ ! -r $2 ]]; then
    echo "Arg 2: Must be a readable file" >&2
    exit 2
fi

if ! grep -qP "^(?=.*1)(?=.*2)(?=.*3)(?=.*4)(?=.*5)(?=.*6)(?=.*7)(?=.*8)(?=.*9).*$" "$2"; then

    echo "Arg 2: File must contain integers 1-9" >&2
    exit 3
fi

# Read the moves from the input file
moves=($(cat "$2"))

# Initialize the game board
board=(" " " " " " " " " " " " " " " " " " " ")

# Play the game
player=$1
for move in "${moves[@]}"; do
    if [[ ${board[$move-1]} == " " ]]; then
        board[$move-1]=$player
    fi

    winner=$(check_winner "${board[@]}")

    if [[ -n $winner ]]; then
        print_board "${board[@]}"
        if [[ $winner == "X" ]]; then
            echo "X is the winner!"
            exit 4
        elif [[ $winner == "O" ]]; then
            echo "O is the winner!"
            exit 5
        fi
    fi

    # Switch player
    if [[ $player == "X" ]]; then
        player="O"
    else
        player="X"
    fi
done

print_board "${board[@]}"
echo "The game ends in a tie."
exit 6
