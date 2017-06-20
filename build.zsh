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
DEPLOY_DIR="../thermalspan.github.io"

if [ -z {1+x} ]
then
    BASE_URL="$(pwd)/$RESULT_ROOT"
else
    case $1 in
    deploy)
        DEPLOY=1
        BASE_URL="https://thermalspan.github.io"
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

col_echo "Running Cobalt ..." 3
cobalt build --source $WEB_SRC_ROOT --destination $RESULT_ROOT --config $WEB_SRC_ROOT/.cobalt.yml

col_echo "Dittoing result to deploy dir ..." 3
rm -rf $DEPLOY_DIR/*
ditto $RESULT_ROOT $DEPLOY_DIR

