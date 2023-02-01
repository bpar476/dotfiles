function pbcopy
    tee <&0 | clip.exe
end
