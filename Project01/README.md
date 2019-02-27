Run project_analyze.sh script by doing ./project_analyze.sh , no input required when doing so.

User is then prompted for an input.
Input 1 for "File Type Count".
Input 2 for "TODO Log".
Input 3 for "Commit Message Word Search and Normal Search"

"File Type Count"
-Searches through the repository, CS1XA3.
-Finds HTML, JavaScript, CSS, Python, Haskell and Bash Script files.
-Displays how many of each file type there are in the repository.

"TODO Log"
-Searches through the repository, CS1XA3.
-Finds files that contain "#TODO".
-Copies the line and line number where #TODO occurs to a file todo.log.

"Commit Message Word Search and Normal Search"
-Prompts user for an input
-Uses input to find Commit Messages with the input
-Also find alls files that contain the input
-Displays both out to the screen
