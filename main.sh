#!/bin/sh

[ ! -d .git ] && echo "Not a git repository" && exit 1

branch=`git for-each-ref --format='%(refname:short)' refs/heads/`
IFS=' '
workingBranch=`git rev-parse --abbrev-ref HEAD`

from=`echo $branch | gum filter --header "Choose the branch from which to merge" --placeholder "Branch..." --header.foreground="#aaa" --height 20 --value $workingBranch`

to=`echo $branch | gum filter --header "Choose the branch towards which to merge" --placeholder "Branch..." --header.foreground="#aaa" --height 20 --value "main"`

commandsTxt=`gum format -t code -- "
git checkout $to
git fetch --all
git checkout $from
git rebase origin/$to
git push --force-with-lease
git checkout $to
git merge $from --ff-only
git push
"`

gum confirm "Merging branch $from into $to
The following commands will be run:

$commandsTxt
" && echo "Running commands" \
&& gum spin --show-output --spinner jump --title "git checkout $to" -- git checkout $to \
&& gum spin --show-output --spinner jump --title "git fetch --all" -- git fetch --all \
&& gum spin --show-output --spinner jump --title "git checkout $from" -- git checkout $from \
&& gum spin --show-output --spinner jump --title "git rebase origin/$to" -- git rebase origin/$to \
&& gum spin --show-output --spinner jump --title "git push --force-with-lease" -- git push --force-with-lease \
&& gum spin --show-output --spinner jump --title "git checkout $to" -- git checkout $to \
&& gum spin --show-output --spinner jump --title "git merge $from --ff-only" -- git merge $from --ff-only \
&& gum spin --show-output --spinner jump --title "git push" -- git push

echo "Done"
