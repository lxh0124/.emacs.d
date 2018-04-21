# Setup emacs configuraiton

1, setup Javascript development

2, add helm config


# how to use magit
1, `magit-status` to check git status

(global-set-key (kbd "C-x g") 'magit-status)  

2, move the cursor to *Unstaged changes* and then key "s", the status will be changed to "Staged changes"

3, in same window, type "c" will redirect to commit window.

4, type "c" again and will ask to add the comments.

5, C-c C-c will commit the changes

6, type "P" will push the change to remote branch

7, 2 options:

- choose 'u' to push to origin/master branch
- choose 'p' will list the branch

# js2-refactor link:

https://github.com/magnars/js2-refactor.el