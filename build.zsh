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

# Clone, checkout, and build KaTeX
col_echo "Checkout on KaTeX checkout ..." 3
KATEX_SRC_DIR="./dependencies/KaTeX"
KATEX_SRC_TAG="v0.7.1"
if [ -e dependencies/KaTeX ]
then
    git -C $KATEX_SRC_DIR pull
    git -C $KATEX_SRC_DIR checkout $KATEX_SRC_TAG
else
    git clone https://github.com/Khan/KaTeX.git $KATEX_SRC_DIR 
    git -C $KATEX_SRC_DIR checkout $KATEX_SRC_TAG
fi

col_echo "Make KaTeX ..." 3
make -C $KATEX_SRC_DIR

col_echo "Copy over KaTeX to WEB_SRC_ROOT" 3
ditto $KATEX_SRC_DIR/build $WEB_SRC_ROOT/static/KaTeX

# Clone, checkout, and build posts
https://github.com/ThermalSpan/posts.git
col_echo "Checkout on posts checkout ..." 3


col_echo "Copying over web sources ..." 3
ditto $WEB_SRC $WEB_SRC_ROOT 

col_echo "Generating env.liquid ..." 3
rm -f $ENV_LIQUID
echo "{% assign title = \"thermalspan\" %}" >> $ENV_LIQUID
echo "{% assign base_url = \"$BASE_URL\" %}" >> $ENV_LIQUID

col_echo "Running Cobalt ..." 3
cobalt build --source $WEB_SRC_ROOT --destination $RESULT_ROOT --config $WEB_SRC_ROOT/.cobalt.yml --trace

col_echo "Dittoing result to deploy dir ..." 3
rm -rf $DEPLOY_DIR/*
ditto $RESULT_ROOT $DEPLOY_DIR

