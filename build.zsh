#!/usr/bin/env zsh

function col_echo {
    tput setaf $2
    echo $1
    tput sgr0
}

WEB_SRC="web_src"
WEB_SRC_ROOT="web_src_root"
RESULT_ROOT="deploy"
ENV_LIQUID="$WEB_SRC_ROOT/_includes/env.liquid"

if [ -z {1+x} ]
then
    BASE_URL="$(pwd)/$RESULT_ROOT"
else
    case $1 in
    deploy)
        BASE_URL="thermalspan.github.io"
        ;;
    *)
        BASE_URL="$(pwd)/$RESULT_ROOT"
        ;;
    esac
fi

col_echo "Copying over web sources ..." 3
ditto $WEB_SRC $WEB_SRC_ROOT 

col_echo "Generating env.liquid ..." 3
rm -f $ENV_LIQUID
echo "{% assign title = \"thermalspan\" %}" >> $ENV_LIQUID
echo "{% assign base_url = \"$BASE_URL\" %}" >> $ENV_LIQUID

cobalt build --source $WEB_SRC_ROOT --destination $RESULT_ROOT --config $WEB_SRC_ROOT/.cobalt.yml

