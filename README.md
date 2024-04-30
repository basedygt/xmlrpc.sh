## Usage

```
Usage: ./xmlrpc.sh <endpoint> <username> <wordlist> <threads>

Recommended threads: Less than 15 or you'll face false positives
Cracked Passwords Location: success.log
Attempted Passwords Location: attempts.log

Example:
  ./xmlrpc.sh http://example.com/xmlrpc.php admin passwords.txt 10
``` 
## Note

it uses `wp.getCategories` method to bruteforce edit line 14 to change also make sure you have explicit permission from the website owner before using this script on any WordPress site.
