# solution_jh1662

## Description
A solution to a variety of tasks from coursework (U10814)
## Functionality
Solved the following:
* Generates valid UUID 4 and stores it as a file
* Generates valid UUID 5 and stores it as a file
* Analyse sizes and names in a directory and store them as a file
* shows PIDs and PPID
* shows logs of users using the script
## Usage
The script can be run by using the following command in either Git Bash or Linux terminal:
### Synopsis
```sh
$ bash solution_jh1662.sh arg1 [arg2]
```
### Description
* `bash` denotes that it is a bash file.
* `solution_jh1662.sh` is the name of the file.
* `arg1` is a required argument placeholder where options will be explored later
* `arg2` is an optional argument placeholder where options will be explored later
### Options for `arg1` (some require `arg2`)
* `help` - shows all possible options for both arguments.
* `uuid` - generates either uuid version 4 or 5.
* `analyse` - generates a comprehensive report of subjected directory.
* anything else (or nothing) - user will be suggested to use `help` for arg1.
### Options for `arg2`
* `4` or `5` when `arg1` is `uuid`.
* relative path/address for the subjected directory when `arg1` is `analyse`. The address must use `/` instead of `\` (if used at all). Multiple slashes in a row are tolerated in the address (like `///`).
## Files
As previously mentioned, some results/outputs will be stored in named files. If the wanted file does not, it will then be created.
Files:
* `UUID4.txt` - stores a version 4 UUID and gets overwritten.
* `UUID5.txt` - stores a version 5 UUID and gets overwritten.
* `user_activity.log` - stores logs and appends to existing ones.
* `directory_analysis.txt` - stores analysis infomation of subjected directory and child directories inside it.
## Temporary Storage
As an indirect, but simple, form of multiplexing, a directory (called `cache`) may be created and deleted with cache text files inside it.
## Author
made my CCCU student James Haddad in 2024 (student username: jh1662).