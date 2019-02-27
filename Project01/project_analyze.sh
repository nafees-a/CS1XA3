echo Enter 1 for File Type Count, Enter 2 for TODO Log, Enter 3 for Commit Message Word Search and Normal Search
read input

if [ $input -eq 1 ]; then
    echo -n HTML:
    find ~/CS1XA3 -name "*.html" -type f | wc -l
    echo -n JavaScript:
    find ~/CS1XA3 -name "*.js" -type f | wc -l
    echo -n CSS:
    find ~/CS1XA3 -name "*.css" -type f | wc -l
    echo -n Python:
    find ~/CS1XA3 -name "*.py" -type f | wc -l
    echo -n Haskell:
    find ~/CS1XA3 -name "*.hs" -type f | wc -l
    echo -n Bash Script:
    find ~/CS1XA3 -name "*.sh" -type f | wc -l
fi

if [ $input -eq 2 ]; then
   #TODO see if this works
   grep -n -r --exclude="todo.log" "#TODO" ~/CS1XA3 > todo.log
fi

if [ $input -eq 3 ]; then
   echo Enter an word to search for in commit messages
   read input2
   git log --grep="$input2"
   echo -------------------------------------------
   grep -r --exclude-dir=".git*" "$input2" ~/CS1XA3
fi
