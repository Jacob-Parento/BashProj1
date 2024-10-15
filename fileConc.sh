#!/bin/bash

# Function to display script usage/help information
function display_usage() {
  echo "This script removes all "filler words" in a file to allow for a keyword search. "
  echo "Usage: ./fileConc.sh -f <filename> -o <output_name>"
  echo "Options: "
  echo "  -f <filename>: Specify the input filename."
  echo "  -o <output_name>: Specify the filename where the results will be stored."
  echo "  -h: Display this help information."
}

# Check if no arguments are provided.
# If so, display usage information and exit
if [[ $# -eq 0 || "$1" == "-h" ]]; then
    display_usage
    exit 0
fi

filename=""
output_name=""
filler_words="and|but|or|yet|for|nor|so|the|a|an|in|on|at|by|this|that|which|he|she|they|we|you|to|from|with|of|is|was|are|were|be"

while getopts ":f:o:h" opt; do
    case $opt in
        f) # option f
            filename=$OPTARG
            ;;
        o) # option o
            output_name=$OPTARG
            ;;
        h) # option h
            # display usage and exit
            display_usage
            exit 0
            ;;
        \?) # any other option
            echo "Invalid option: -$OPTARG"
            # display usage and exit
            display_usage
            exit 0
            ;;
        :) # no argument
            echo "Option -$OPTARG requires an argument."
            # display usage and exit
            display_usage
            exit 1
            ;;
    esac
done

   if [[ -z $filename || -z $output_name ]]; then
        echo "Error: Missing required options."
        # display usage and exit
        display_usage
        exit 1
    fi

# Check if the specified input filename exists and is a regular file
    if [[ ! -f $filename ]]; then
        echo "Error: Input file '$filename' does not exist or is not a regular file."
        # exit
        exit 1
    fi

    #Found a cool way to do it on stack exchange: https://unix.stackexchange.com/questions/692160/how-do-you-remove-all-punctuation-using-the-sed-command so I used that.
    cleaned_content=$(sed 's/[[:punct:]]//g' "$filename")
    cleaned_content=$(echo "$cleaned_content" | sed -E "s/\b($filler_words)\b//gI")
    # Append to output file
    echo "$cleaned_content" >> "$output_name"

    echo "Processed files concatenated into $output_name."