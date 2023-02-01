function infer_remote
    set remotes (git remote)
    set remote_count (echo $remotes | wc -l)
    if test $remote_count -ne 1 
            return -1
    end
    echo $remotes
end
