#!/bin/bash

echoerr() { printf "%s\n" "$*" >&2; }

download_mff() {
    echoerr " [>>] Downloading..."

    curl -LJ0 https://github.com/OSITO326/firefox-gruvbox-css/archive/main.tar.gz | tar -xz -C /tmp/

    if [[ $? -eq 0 ]]; then
        echoerr " [>>] Copying..."

        USERCHROME="/tmp/minimal-gruvbox-dark/userChrome.css"
        USERCONTENT="/tmp/minimal-gruvbox-dark/userContent.css"
        cp -r --backup=simple -t $CHROME_DIRECTORY $USERCHROME $USERCONTENT
        rm -f USERCHROME USERCONTENT
        cp -r /tmp/minimal-gruvbox-dark/* $CHROME_DIRECTORY

        if [[ $? -eq 0 ]]; then
            rm -rf /tmp/minimal-gruvbox-dark
        else
            echoerr " [!!] There was a problem copying the files. Terminating..."
            return 1
        fi
    else
        echoerr " [!!] There was a problem downloading the files. Terminating..."
        return 1
    fi
    cat <<-'EOF'
           _       _                 _  
          (_)     (_)               | | 
 _ __ ___  _ _ __  _ _ __ ___   __ _| | 
| '_ ` _ \| | '_ \| | '_ ` _ \ / _` | | 
| | | | | | | | | | | | | | | | (_| | | 
|_| |_| |_|_|_| |_|_|_| __| |_|\__,_|_| 
                       | |              
  __ _ _ __ _   ___   _| |__   _____  __
 / _` | '__| | | \ \ / | '_ \ / _ \ \/ /
| (_| | |  | |_| |\ V /| |_) | (_) >  < 
 \__, |_|   \__,_| \_/ |_.__/ \___/_/\_\
  __/ |                                 
 |____            _                     
    | |          | |                    
  __| | __ _ _ __| | __                 
 / _` |/ _` | '__| |/ /                 
| (_| | (_| | |  |   <                  
 \__,_|\__,_|_|  |_|\_\                 
                        

EOF
    echoerr " Installation successful! Enjoy :)"
}

MOZILLA_USER_DIRECTORY="$(find ~/.mozilla/firefox -maxdepth 1 -type d -regextype egrep -regex '.*[a-zA-Z0-9]+.default-release')"

if [[ -n $MOZILLA_USER_DIRECTORY ]]; then
    # echoerr "mozilla user directory found: $MOZILLA_USER_DIRECTORY"

    CHROME_DIRECTORY="$(find $MOZILLA_USER_DIRECTORY -maxdepth 1 -type d -name 'chrome')"

    if [[ -n $CHROME_DIRECTORY ]]; then
        # echoerr "chrome directory found: ""$CHROME_DIRECTORY"
        download_mff
    else
        echoerr " [>>] No chrome directory found! Creating one..."
        mkdir $MOZILLA_USER_DIRECTORY"/chrome"
        if [[ $? -eq 0 ]]; then
            CHROME_DIRECTORY="$MOZILLA_USER_DIRECTORY/chrome"
            # echoerr "Directory succesfully created"
            download_mff
        else
            echoerr " [!!] There was a problem creating the directory. Terminating..."
            exit 1
        fi
    fi

else
    echoerr " [!!] No mozilla user directory found. Terminating..."
    exit 1
fi
