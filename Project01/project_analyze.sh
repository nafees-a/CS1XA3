echo Enter 1 for File Type Count
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
