function gdr
    set current_branch (git branch --show-current)
    set remote (infer_remote)
    if test $status -eq -1 
        if test (count $argv) -ne 1
            echo "Multiple remotes detected, please specify a remote as arg1"
            return 1
        end
        git diff $1/$current_branch
    else
        git diff $remote/$current_branch
    end

    return $status
end
