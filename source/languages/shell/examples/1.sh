export PATH="${PATH}:/usr/local/opt/llvm/bin" 

find "$PWD" -maxdepth 1 -print0 | perl -p -e 's/\0'$escaped_path'\//\0/g'

if [[ "$OSTYPE" == "darwin"* ]]; then
    brew install $@
fi

cd /opencv-3.2.0/ \
    && mkdir build \
    && cd build \
    && ldconfig \
    && rm /opencv.zip \
    && rm /opencv_contrib.zip

function go_to_vs_lang_settings {
    arg_1=$1
    arg_2=$2
    arg_3=$3
    all_arguments=$@
    cd "/Applications/extensions/"; ls -1
}

exec 9>&2
exec 8> >(
    perl -e '$|=1; while(sysread STDIN,$a,9999) {print 
"$ENV{COLOR_BLUE}$a$ENV{COLOR_RESET}"}'
)

export COLOR_BLUE="$(tput setaf 4)"
export COLOR_RED="$(tput setaf 1)"
export COLOR_RESET="$(tput sgr0)"