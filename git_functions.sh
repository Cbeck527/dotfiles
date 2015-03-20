# issue pull request
ipr() {
    REPO_URL="$(git remote -v | grep fetch | head -1 | cut -f2 | cut -d' ' -f1 | sed -e's/git@/http:\/\//' -e's/\.git$//' | sed -E 's/(\/\/[^:]*):/\1\//')"
    ON_BRANCH=$(git branch | grep '^* ' | sed 's/^* //')
    if [[ $REPO_URL == *"gitlab"* ]]
    then
      open "$REPO_URL/compare/master...$ON_BRANCH" > /dev/null 2>&1
    else
      open "$REPO_URL/compare/$ON_BRANCH" > /dev/null 2>&1
    fi
}

# random recent committer
rrc() {
    git status >/dev/null 2>&1
    if [[ $? -ne 0 ]]; then
      echo "Not a git repo"
    return 128
    fi
    git log --since="-1 month" | sed -n -e "/^Author: /s/Author: //p;" \
      | grep -v "Chris Becker" | sort -u | gshuf | tail -n 1
}
