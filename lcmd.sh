#!/bin/bash

# Define version
VERSION="0.1.0"

# Function to display help
display_help() {
    echo "Usage: command1 [OPTION]"
    echo "This is command1 version $VERSION, demonstrating functionality."
    echo ""
    echo "Options:"
    echo "  -C, --cpuinfo      Show cpu info"
    echo "  -M  --memoryinfo   Show memory info"
    echo "  -u, --uptime       Show system uptime"
    echo "  -c, --current-user Show current user"
    echo "  -d, --documentation Display full documentation"
    echo "  -h, --help         Display this help and exit"
    echo "  -v, --version      Display version information"
    echo ""
    echo "For more detailed information, run 'command1 --documentation'"
}

display_documentation() {
    echo "COMMAND1 DOCUMENTATION"
    echo "----------------------"
    echo "This command demonstrates various functionalities."
    echo ""
    echo "Options and Functionalities:"
    echo " -C, --cpuinfo      Show cpu info"
    echo " -M, --memoryinfo   Show memory info"
    echo "-u, --uptime:   Show system uptime"
    echo "-c, --current-user: Show current user"
    echo "-h, --help:     Display help message"
    echo "-d, --documentation: Display full documentation (this message)"
    echo "-v, --version:  Display version information"
    echo ""
    echo "Usage Examples:"
    echo "  command1 -u            # Show system uptime"
    echo "  command1 -c            # Show current user"
    echo "  command1 --help        # Displays help message"
}

get_file_info() {
    local file=$1

    # Check if the file exists
    if [ ! -e "$file" ]; then
        echo "Error: File '$file' not found."
        exit 1
    fi

    # Get file information
    file_info=$(stat -c "File: %n\nAccess: %a\nSize(B): %s\nOwner: %U\nModify: %y" "$file")

    echo -e "$file_info"
}


if [ "$#" -lt 3 ]; then
    echo "Error: Insufficient arguments."
    echo "Usage: internsctl file getinfo <file-name>"
    exit 1
fi

command=$1
subcommand=$2
file_name=$3

case "$subcommand" in
    getinfo)
        get_file_info "$file_name"
        ;;
    *)
        echo "Error: Invalid subcommand '$subcommand'."
        echo "Usage: internsctl file getinfo <file-name>"
        exit 1
        ;;
esac


get_file_info() {
    local file=$1
    local size_option=$2
    local permissions_option=$3
    local owner_option=$4
    local last_modified_option=$5

    # Check if the file exists
    if [ ! -e "$file" ]; then
        echo "Error: File '$file' not found."
        exit 1
    fi

    # Initialize the format string
    format_string="File: %n"

    # Check options and modify the format string accordingly
    if [ "$size_option" = true ]; then
        format_string="$format_string\nSize(B): %s"
    fi

    if [ "$permissions_option" = true ]; then
        format_string="$format_string\nAccess: %a"
    fi

    if [ "$owner_option" = true ]; then
        format_string="$format_string\nOwner: %U"
    fi

    if [ "$last_modified_option" = true ]; then
        format_string="$format_string\nModify: %y"
    fi

    # Get file information
    file_info=$(stat -c "$format_string" "$file")

    echo -e "$file_info"
}

# Check for command line arguments
if [ "$#" -lt 3 ]; then
    echo "Error: Insufficient arguments."
    echo "Usage: internsctl file getinfo [options] <file-name>"
    exit 1
fi

# Parse command line options
file_name=${!#}  # Get the last argument, which is the file name
size_option=false
permissions_option=false
owner_option=false
last_modified_option=false

while [ "$#" -gt 0 ]; do
    case "$1" in
        -s|--size)
            size_option=true
            ;;
        -p|--permissions)
            permissions_option=true
            ;;
        -o|--owner)
            owner_option=true
            ;;
        -m|--last-modified)
            last_modified_option=true
            ;;
        *)
            ;;
    esac
    shift
done


get_file_info "$file_name" "$size_option" "$permissions_option" "$owner_option" "$last_modified_option"



show_memoryinfo(){
    echo "Memory Info:"
    free
}
show_cpuinfo()
{
    echo "CPU Info:"
    lscpu
}
show_uptime() {
    echo "System uptime:"
    uptime
}


show_current_user() {
    echo "Current user:"
    whoami
}


if [[ $# -eq 0 ]]; then
    display_help
    exit 1
fi

# Parse command line options
while [[ $# -gt 0 ]]; do
    case "$1" in
        -u|--uptime)
            show_uptime
            exit 0
            ;;
        -M|--memoryinfo)
            show_memoryinfo
            exit 0
            ;;
        -C|--cpuinfo)
            show_cpuinfo
            exit 0
            ;;
        -c|--current-user)
            show_current_user
            exit 0
            ;;
        -d|--documentation)
            display_documentation
            exit 0
            ;;
        -h|--help)
            display_help
            exit 0
            ;;
        -v|--version)
            echo "command1 version $VERSION"
            exit 0
            ;;
        *)
            echo "Invalid option: $1"
            display_help
            exit 1
            ;;
    esac
    shift
done