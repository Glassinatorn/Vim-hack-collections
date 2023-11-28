#! /bin/sh

# defining paths
CONFIGDIR="$HOME/.config"
ETCDIR="$HOME/etc"
SHAREDIR="$HOME/.local/share"
BINDIR="$HOME/.local/share/bin"
GITDIR="$HOME/git/git_project"
 
# defining targets and excludes
#
# Structure the paths for the github repo by the following structure:
# src-<file/folder> dst-folder explude-string
# ex: $CONFIGDIR/awesome $GITDIR/backup .secrets .gitignore .secrets
list=$(echo -e "$CONFIGDIR/awesome $GITDIR/tmp .gitignore")

# defining command
CMD="rsync -razzP --del"

while IFS= read -r line
do
    SRC=$(echo "$line" | cut -d ' ' -f 1)
    DST=$(echo "$line" | cut -d ' ' -f 2)
    EXCL=$(echo "$line" | cut -d ' ' -f 3-)

    CMD=$CMD" --exclude \"$EXCL\" $SRC $DST"
    $CMD

done <<< "$list"


# uploading to GitHub
DEFAULT='Y'
read -e -p "Upload to GitHub? [Y/n]:" CHOICE
CHOICE="${CHOICE:-${DEFAULT}}"

if [ $CHOICE = 'y' ] || [ $CHOICE = 'Y' ]; then
    cd $GITDIR
    git add *
    git commit
    git push
fi
