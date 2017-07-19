RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
NORMAL=$(tput sgr0)

function print_ok {
    echo -e " [ $GREEN OK $NORMAL ]"
}

function print_skip {
    echo -e " [ $GREEN SKIP $NORMAL ]"
}

function print_fail {
    echo -e " [ $RED FAIL $NORMAL ]"
}


function backup_file {
    path=$1
    file=$(basename $path)
    echo -n "Backing up $path..."

    if [[ -e "$BACKUP_DIR/$file" ]]; then
        print_skip
    elif [[ -e "$path" ]]; then
        cp $path $BACKUP_DIR/$file > /dev/null
        print_ok
    else
        echo -n "could not copy $file"
        print_fail
    fi
}


function add_line {
    line=$1
    file=$2

    if [[ -z $line || -z $file ]]; then
        echo "usage: add_line line file"
    fi

    echo -n "Appending $line to $file..."
    grep $file -e "$line" > /dev/null
    if [[ $? -eq '1' ]]; then
        echo $line >> $file
        print_ok
    else
        print_skip
    fi
}

