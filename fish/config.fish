if status is-interactive
    # Commands to run in interactive sessions can go here
    set -g fish_term24bit 1

    set PATH $PATH $HOME/.local/bin
    set PATH $PATH /usr/local/go/bin
    set -x GOPATH $HOME/go
    set PATH $PATH $GOPATH/bin
    # Set the GOPROXY environment variable
    set -x GOPROXY https://goproxy.io,direct
    # Set environment variable allow bypassing the proxy for specified repos (optional)
    set -x GOPRIVATE github.com/immutable
    set PATH $PATH $HOME/.cargo/bin
    
    # Start docker
    if docker ps 2>&1 >> /dev/null
    else
        echo "Starting docker server..."
        sudo service docker start
    end

    set NVM_DEFAULT "lts"
    nvm use $NVM_DEFAULT

    # Prompt
    set -g hydro_color_error red
    set -g hydro_color_pwd magenta
    set -g hydro_clor_git yellow
    set -g hydro_color_prompt green
end
