name="gitff"
path="$HOME/scripts"

print_usage() {
    echo "./install.sh [options]
    options:
        -n:     Program name to be installed
                Default: 'gitff'
        -p:     Program path for installation
                Default: '$HOME/scripts
        -h:     Show this help
    " 
}

check_path() {
    [ ! -z $1 ] && [[ ! ":$PATH:" == *":$path:"* ]] && gum style --foreground "#CE8954" "REMINDER: Installation path ($path) is not in your \$PATH variable
To make it possible to run the script, please run the following command (for bash):

echo 'export PATH=\"\$PATH:$path\" >> ~/.bashrc
"
}


while getopts 'n:p:h' flag; do
  case "${flag}" in
    n) name=$OPTARG ;;
    p) path=$OPTARG ;;
    h) print_usage   ;;
    *) print_usage
       exit 1 ;;
  esac
done

gum confirm "Install script on $path/$name?"

echo "Installing in $path/$name"

mkdir -p $path
cp main.sh "$path/$name"

check_path $path
