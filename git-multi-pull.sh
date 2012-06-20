#!/bin/bash

# Name: Git multi pull
#
# Brief: Fetches updates and merges remote branches and local branches.
#
# Flags:
#
#   p - Checks out all branches of the specified remote.
#
#   h - Prints usage information.
#
# Arguments:
#
#   <branch>... - the repository to checkout branches from.

# Get current branch.
initial_branch="$(git symbolic-ref HEAD 2>/dev/null)"
initial_branch=${initial_branch##refs/heads/}

# Branches to merge into.
remote=

all=
usage=

function usage()
{
  echo "Usage:"
  echo "    $0 [-p] <remote> <branch>..."
  return 0
}

# Reading flags.
while getopts ph name
do
  case $name in
    p) pretend=1;;
    h) usage=1;;
  esac
done

# Print usage and exit.
if [ -n "$usage" ]
then
  usage
  exit 0
fi

# Discarding flags from arguments.
shift $(($OPTIND - 1))

if [ $# -le 1 ]
then
  usage
  exit 2
fi

remote="$1"
echo $remote

if [ -z "$remote" ]
then
  echo "Please, specify a remote repository"
  echo
  usage
  exit 2
fi

shift

for nname in $*
do
  if [ -n "$pretend" ]
  then
    echo "git co" $nname "&& git merge" ${remote}"/"${nname}
  else
    git co $nname && git merge $remote/$nname
  fi
done

if [ -n "$pretend" ]
then
  echo "git co" $initial_branch
else
  git co $initial_branch
fi

