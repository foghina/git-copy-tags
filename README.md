This is a small utility that copies matching tags from one git repository to another. And by "matching" I mean that there's a commit in the destination repository with the same SHA hash as the commit in the source repository that the tag points to.

#  Usage

    git-copy-tags <source-repo> <dest-repo> [-f]
    
By default, the script is in "dry run" mode, which means that it only prints out what it **would** do, without actually doing it. If you are happy with the result, add `-f`.

After running the command with `-f`, make sure to run `git push --tags` in the destination repository!
