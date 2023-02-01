if status is-interactive
    # Commands to run in interactive sessions can go here
    export COLORTERM="truecolor"

    export PATH=$PATH:$HOME/.local/bin
    export PATH=$PATH:/usr/local/go/bin
    export GOPATH=$HOME/go
    export PATH=$PATH:$GOPATH/bin
    # Set the GOPROXY environment variable
    export GOPROXY=https://goproxy.io,direct
    # Set environment variable allow bypassing the proxy for specified repos (optional)
    export GOPRIVATE=github.com/immutable
    export PATH=$PATH:$HOME/.cargo/bin
    
    # Start docker
    if docker ps 2>&1 >> /dev/null; then
    else
        echo "Starting docker server..."
        sudo service docker start
    fi

    # NVM setup
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh"  ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion"  ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
    NVM_DEFAULT="16"
    nvm use $NVM_DEFAULT
end
