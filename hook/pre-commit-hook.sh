#!/bin/sh

#COLOR CODES:
#tput setaf 3 = yellow -> Info
#tput setaf 1 = red -> warning/not allowed commit
#tput setaf 2 = green -> all good!/allowed commit


# Check for non-staged changes
git diff --quiet
hadNoNonStagedChanges=$?
if ! [ $hadNoNonStagedChanges -eq 0 ]
then
   tput setaf 3; echo "* Stashing non-staged changes"
   git stash --keep-index -u > /dev/null
fi

(cd $DIR/; find . -name '*.tex' -exec latexindent -y="onlyOneBackUp:1" -s -w {} \;)
git diff --quiet
formatted=$?

tput setaf 3; echo "* Properly formatted?"

if [ $formatted -eq 0 ]
then
   tput setaf 2; echo "* Yes"
else
    tput setaf 1; echo "* No"
    tput setaf 3; echo "The following files need formatting (in stage or commited):"; tput sgr0
    git diff --name-only
     echo ""
    tput setaf 3; echo "Please run 'find . -name '*.tex' -exec latexindent -y=\"onlyOneBackUp:1\" -s -w {} \;' from the root directory to format the code."; tput sgr0
    echo ""
fi

# undo formatting
git stash --keep-index > /dev/null
git stash drop > /dev/null

# pop stashed unstaged changes 
if ! [ $hadNoNonStagedChanges -eq 0 ]
then
   tput setaf 3; echo "* Scheduling stash pop of previously stashed non-staged changes for 1 second after commit."
   sleep 1 && git stash pop --index > /dev/null & # sleep and & otherwise commit fails when this leads to a merge conflict
fi

# if the code is properly formatted exit
if [ $formatted -eq 0 ]
then
   tput setaf 2; echo "... done. Proceeding with commit."; tput sgr0
   echo ""
   exit 0

else
   tput setaf 1; echo "... done."
   tput setaf 1; echo "CANCELLING commit due to NON-FORMATTED CODE."; tput sgr0
    echo ""
   exit 1
fi