#!/bin/sh

cd $(dirname "$0") # set directory to hook/

#create the file if it doesn't exist
touch ../.git/hooks/pre-commit 
#delete the file
rm ../.git/hooks/pre-commit 
#create a file link
ln -s pre-commit-hook.sh ../.git/hooks/pre-commit 
#copy paste the code in the hook folder
cp pre-commit-hook.sh ../.git/hooks/pre-commit-hook.sh

#give permissions to scripts
chmod +x ../.git/hooks/pre-commit
chmod +x ../.git/hooks/pre-commit-hook.sh

echo "hook instalado correctamente"

