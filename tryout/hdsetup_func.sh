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
    backupdir=$2
    echo -n "Backup $path... "

    if [[ -e "$backupdir/$file" ]]; then
        print_skip
    elif [[ -e "$path" ]]; then
        cp $path $backupdir/$file > /dev/null
        print_ok
    else
        echo -n "could not copy $file into $backupdir"
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


function apply_subst {
    # Applies a substitution to a given file, and update with an optional status
    # usage: apply_subst regexp subst file [status]
    regexp=$1
    subst=$2
    file=$3
    if [[ -z $4 ]]; then
        status="Replacing pattern '$regexp' with '$subst' in '$file'"
    else
        status=$4
    fi

    echo -n "$status"
    # check to see if the pattern is even in the file
    grep "$file" -e "$regexp" > /dev/null
    if [[ $? -ne '0' ]]; then
        # if not then continue
        print_skip
    else
        full_subst="s/$regexp/$(echo $subst | sed -e 's/[\/&]/\\&/g')/g"
        tmpfile=tmp_$(basename $file)
        cp $file $tmpfile
        sed "$full_subst" < $tmpfile > $file
        rm $tmpfile
        print_ok
    fi
}
