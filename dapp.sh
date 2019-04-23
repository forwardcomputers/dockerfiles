#!/bin/bash
set -E              # any trap on ERR is inherited by shell functions
set -e              # exit if error occurs
set -u              # treat unset variables and parameters as an error
set -o pipefail     # fail if pipe failed
#set -x              # show every commond
#
DOCKER_PASSTHOUGH=""
set +u
if [[ ! -z "$3" ]]; then DOCKER_PASSTHOUGH="$3"; fi
set -u
#
if [[ -z ${LP_GITHUB_API_TOKEN+x} ]]; then LP_GITHUB_API_TOKEN=""; fi
if [[ -z ${DISPLAY+x} ]]; then DISPLAY=0; fi
#
GH_API_HEADER="Accept: application/vnd.github.v3+json"
GH_AUTH_HEADER="Authorization: token ${LP_GITHUB_API_TOKEN}"
#
ROLLING="$(curl --silent --location --url https://raw.githubusercontent.com/tianon/docker-brew-ubuntu-core/master/rolling)"
BUILD_DATE="$(date +'%-d-%-m-%G %r')"
CO="forwardcomputers"
NAME=$( echo "${2-none}" | cut -d '/' -f 1 )
IMG="${CO}/${NAME}"
set +u
if [[ "${CIRCLECI}" ]]; then
    ROOT=""
else
    if ! grep -q 'index.docker.io' "${HOME}"/.docker/config.json; then
        # shellcheck disable=SC2046
        docker login --username forwardcomputers --password $(lpass show LP_DOCKER_PASSWORD --password) > /dev/null 2>&1
    fi
    ROOT="/media/filer/os/dockerfiles/"
fi
set -u
#
# shellcheck disable=SC2034
BLACK=$'\033[30m'
# shellcheck disable=SC2034
BLUE=$'\033[34m'
# shellcheck disable=SC2034
GREEN=$'\033[32m'
# shellcheck disable=SC2034
CYAN=$'\033[36m'
# shellcheck disable=SC2034
PURPLE=$'\033[35m'
# shellcheck disable=SC2034
RED=$'\033[31m'
# shellcheck disable=SC2034
WHITE=$'\033[37m'
# shellcheck disable=SC2034
YELLOW=$'\033[1;33m'
# shellcheck disable=SC2034
NC=$'\033[0m'
#
# shellcheck disable=SC2191
DOCKER_OPT=(--rm --network=host --hostname=docker_"${NAME}" --shm-size=1gb \
            --env DISPLAY=unix"${DISPLAY}" \
            # --env GDK_SCALE \
            # --env GDK_DPI_SCALE \
            # --env QT_AUTO_SCREEN_SCALE_FACTOR=1 \
            --env PULSE_SERVER=unix:/run/user/"${UID}"/pulse/native \
            --device /dev/bus/usb \
            --device /dev/dri \
            --device /dev/snd \
            --volume /etc/machine-id:/etc/machine-id:ro \
            --volume /media:/media \
            --volume /run/user/"${UID}"/pulse:/run/user/1001/pulse \
            --volume /tmp/.X11-unix:/tmp/.X11-unix:ro \
            --volume "${HOME}":/home/duser)
#
main () {
    TARGET="${1-help}"
#    NAME="${2}"

    if [[ "${TARGET}" == "help" || ( "${NAME}" == "none" && "${TARGET}" != "rebuild_all" && "${TARGET}" != "upgrade_all" && "${TARGET}" != "readme" ) ]]; then
        help
    else
        if ! type "${TARGET}" >/dev/null 2>&1; then
            help
        else
            "${TARGET}"
        fi
    fi
}
#
help () { ## Show this help message
    printf '\n%s\n  %s\n\n%s\n' "Usage:" "${GREEN}dapp ${YELLOW}[target] ${CYAN}directory${NC}" "Targets:"
    grep -E '^[a-zA-Z_-]+.*{.*?## .*$' "${0}" | sort | awk 'BEGIN {FS = "\\(.*?## "}; { printf "  '${GREEN}'%-15s'${YELLOW}'%s'${NC}'\n", $1, $2} '
    printf '\n'
}
#
info () { ## Check if there is a newer application version
#    appversions
    checkbaseimage
    if [[ ! "${APPNEW}" ]]; then APPNEW=null; fi
    if [[ "${APPNEW}" == "${APPOLD}" && ! -f /tmp/MAKE_BASE_UPDATED ]]; then
        printf '\r%s\n' "${YELLOW}${NAME}${GREEN} build is on latest version ${YELLOW}${APPNEW}${NC}"
    else
        if [[ ${APPOLD} -eq 0 ]]; then
            if [[ ${APPNEW} == "null" ]]; then APPNEW=""; fi
            printf '%s\n' "${YELLOW}${NAME}${GREEN} nonexistant in Docker, use ${YELLOW}'dapp upgrade ${NAME}'${GREEN} or ${YELLOW}'dapp build ${NAME}'${GREEN} to generate the latest version ${YELLOW}${APPNEW}${NC}"
        else
            if [[ -f /tmp/MAKE_BASE_UPDATED ]]; then
                printf '%s\n' "${YELLOW}${NAME}${GREEN} ${RED}base image ${YELLOW}${BASE_IMAGE}${NC} ${GREEN}has been updated"
            else \
                printf '%s\n' "${YELLOW}${NAME}${GREEN} ${RED}build is on older version ${YELLOW}${APPOLD}${NC} ${GREEN}current version ${YELLOW}${APPNEW}${NC}"
            fi
        fi
        touch -f /tmp/MAKE_REBUILD
    fi
    rm -f /tmp/MAKE_BASE_UPDATED
}
#
update () {
    upgrade
}
#
upgrade () { ## Upgrade if there is a newer application version
    printf '%s' "${GREEN}Upgrading ${YELLOW}${NAME}${NC} - "
    info
    if [[ -f /tmp/MAKE_REBUILD ]]; then
        build
        push
        printf '%s\n' "${GREEN}Rebuilt ${YELLOW}${NAME}${GREEN} to the latest version ${YELLOW}${APPNEW}${NC}"
        rm -f /tmp/MAKE_REBUILD
        readme
    fi
}
#
upgrade_all () { ## Upgrade all applications
    printf '%s\n' "Upgrading applications"
    all_apps
    for NAME in "${APPS[@]}"; do
        IMG="${CO}/${NAME}"
        appversions
        upgrade
    done
}
#
rebuild () { ## Rebuild application
    build
    push
    printf '%s\n' "${GREEN}Rebuilt ${YELLOW}${NAME}${GREEN} to the latest version ${YELLOW}${APPNEW}${NC}"
}
#
rebuild_all () { ## Rebuild all applications
    printf '%s\n' "Rebuilding all applications"
    all_apps
    for NAME in "${APPS[@]}"; do
        IMG="${CO}/${NAME}"
        set +e
        appversions
        set -e
        build
        push
        printf '%s\n' "${GREEN}Built ${YELLOW}${NAME}${GREEN} to the latest version ${YELLOW}${APPNEW}${NC}"
    done
    readme
}
#
build () { ## Build docker image file
    printf '%s\n' "Buildng ${NAME}"
#    appversions
    docker build --rm --force-rm --compress --label "${IMG}" --tag "${IMG}" --tag "${IMG}":"${APPNEW}" --build-arg REPO="${NAME}" --build-arg VERSION="${APPNEW}" --build-arg TEXT="${BUILD_DATE}" "${ROOT}${NAME}"
}
#
push () {  ## Push image to Docker Hub
    printf '%s\n' "Pushing ${NAME}-${APPNEW} to Docker hub"
    docker push "${IMG}":latest
    docker push "${IMG}":"${APPNEW}"
    tweet
}
#
run () { ## Run the docker application
    printf '%s\n' "Runing ${NAME}"
    checklocalimage
    xhost +LOCAL:
    if [[ "${DOCKER_PASSTHOUGH}" ]]; then
        docker run --name "${NAME}" "${DOCKER_OPT[@]}" "${IMG}" "${DOCKER_PASSTHOUGH}"
    else
#        docker run --detach --name "${NAME}" "${DOCKER_OPT[@]}" "${IMG}"
        docker run --name "${NAME}" "${DOCKER_OPT[@]}" "${IMG}"
    fi
    xhost -LOCAL:
}
#
shell () { ## Run shell in docker application
    printf '%s\n' "Runing shell in ${NAME}"
    checklocalimage
    xhost +LOCAL:
    docker run --interactive --tty --name "${NAME}"_shell --entrypoint  /bin/bash "${DOCKER_OPT[@]}" "${IMG}"
    xhost -LOCAL:
}
#
desktop () { ## Populate desktop application menu
    printf '%s\n' "Populating application menu"
    DESKTOP_NAME="$(grep -oP '(?<=DESKTOP_NAME ).*' "${ROOT}${NAME}"/Dockerfile 2> /dev/null || true)"
    DESKTOP_COMMENT="$(grep -oP '(?<=DESKTOP_COMMENT ).*' "${ROOT}${NAME}"/Dockerfile 2> /dev/null || true)"
    DESKTOP_CATEGORIES="$(grep -oP '(?<=DESKTOP_CATEGORIES ).*' "${ROOT}${NAME}"/Dockerfile 2> /dev/null || true)"
    DESKTOP_MIMETYPES="$(grep -oP '(?<=DESKTOP_MIMETYPES ).*' "${ROOT}${NAME}"/Dockerfile 2> /dev/null || true)"
    DESKTOP_LOGO="$(grep -oP '(?<=DESKTOP_LOGO ).*' "${ROOT}${NAME}"/Dockerfile 2> /dev/null || true)"
    DESKTOP_LOGO_NAME="${NAME}_$(basename "${DESKTOP_LOGO}")"
    curl --silent --location --output ~/.local/share/applications/"${DESKTOP_LOGO_NAME}" "${DESKTOP_LOGO}"
    printf '%s\n' \
        "[Desktop Entry]" \
        "Version=1.0" \
        "Type=Application" \
        "Terminal=false" \
        "Encoding=UTF-8" \
        "StartupNotify=true" \
        "Name=${DESKTOP_NAME}" \
        "Comment=${DESKTOP_COMMENT}" \
        "Categories=${DESKTOP_CATEGORIES}" \
        "MimeType=${DESKTOP_MIMETYPES}" \
        "Exec=${DOCKER_FILES}/dapp.sh run ${NAME}" \
        "Icon=${HOME}/.local/share/applications/${DESKTOP_LOGO_NAME}" > ~/.local/share/applications/"${NAME}".desktop
    printf '%s\n' "${DESKTOP_MIMETYPES}=${NAME}.desktop;" >> ~/.local/share/applications/mimeapps.list
}
#
readme () { ## Create readme file
    printf '%s\n' "Creating readme file"
    all_apps
    printf '%s\n' \
        "# Docker files" \
        "#### Docker files for various Linux applications." \
        "---" \
        "| Repository | Status | GitHub | Docker | Tag | Size | Layers |" \
        "| --- | --- | :---: | :---: | :--- | :---: | :---: |" > README.md
    for APP in "${APPS[@]}"; do
        printf '%s' \
            "| [![](https://img.shields.io/badge/${APP}-grey.svg)](https://hub.docker.com/r/forwardcomputers/${APP}) " \
            "| [![](https://img.shields.io/badge/dynamic/json.svg?query=$.Labels.BuildDate&label=&url=https://api.microbadger.com/v1/images/forwardcomputers/${APP})](https://hub.docker.com/r/forwardcomputers/${APP}) " \
            "| [![](https://img.shields.io/badge/github--grey.svg?label=&logo=github&logoColor=white)](https://github.com/forwardcomputers/dockerfiles/${APP}) " \
            "| [![](https://img.shields.io/badge/docker--E5E5E5.svg?label=&logo=docker)](https://hub.docker.com/r/forwardcomputers/${APP}) " \
            "| [![](https://img.shields.io/badge/dynamic/json.svg?query=$.results.0.name&label=&url=https://registry.hub.docker.com/v2/repositories/forwardcomputers/${APP}/tags)](https://hub.docker.com/r/forwardcomputers/${APP}) " \
            "| [![](https://img.shields.io/microbadger/image-size/forwardcomputers/${APP}.svg?label=)](http://microbadger.com/images/forwardcomputers/${APP}) " \
            "| [![](https://img.shields.io/microbadger/layers/forwardcomputers/${APP}.svg?label=)](http://microbadger.com/images/forwardcomputers/${APP}) " \
            "|" >> README.md
        printf '\n' >> README.md
    done
    printf '\n%s\n' \
        "[//]: # (BlockEnd)" \
        "This setup is largely based on Jessie Frazelle work [https://github.com/jfrazelle/dockerfiles](https://github.com/jfrazelle/dockerfiles)" >> README.md
}
#
appversions () {
    BASE_IMAGE="$(sed -n -e 's/^FROM //p' "${ROOT}${NAME}"/Dockerfile 2> /dev/null || true)"
    APPOLD="$(curl --silent --location --url https://registry.hub.docker.com/v2/repositories/forwardcomputers/"${NAME}"/tags | jq --raw-output '.results|.[0]|.name // 0')"
    APPNEW="$(grep -oP '(?<=APPNEW ).*' "${ROOT}${NAME}"/Dockerfile 2> /dev/null || true)"
    if ! [[ "${APPNEW}" =~ ^[+-]?([0-9]*[.,])?[0-9]+?$ ]]; then
        if [[ "${APPNEW}" == "apt" ]]; then
            until APTNEWPAGE=$(curl --fail --silent --location --url https://packages.ubuntu.com/"${ROLLING}"/"${NAME}"); do
                sleep 1
            done
            APPNEW="$(echo "${APTNEWPAGE}" | perl -nle 'print $1 if /Package: '"${NAME}"' \((\K[^\)]+)/' | cut -f 1 -d '-' | cut -f 1 -d '+' | cut -f 2 -d ':')"
        else
            set +e
            eval APPNEW=\$\("$(grep -oP '(?<=APPNEW ).*' "${ROOT}${NAME}"/Dockerfile 2> /dev/null || true)"\)
            set -e
        fi
    fi
}
#
checkbaseimage () {
    rm -f /tmp/MAKE_BASE_LOG /tmp/MAKE_BASE_UPDATED /tmp/MAKE_REBUILD
    docker pull "${IMG}":latest > /dev/null 2>&1 || true
    if [[ "${BASE_IMAGE}" ]]; then docker pull "${BASE_IMAGE}" > /tmp/MAKE_BASE_LOG; fi
    # shellcheck disable=SC2143
    if [[ -f /tmp/MAKE_BASE_LOG && ! -z "$(grep 'Pull complete' /tmp/MAKE_BASE_LOG)" ]]; then touch -f /tmp/MAKE_BASE_UPDATED; fi
    rm -f /tmp/MAKE_BASE_LOG
}
#
checklocalimage () {
    if ! docker image inspect "${IMG}" > /dev/null 2>&1; then
        docker pull "${IMG}":latest > /dev/null 2>&1 || build
    fi
    if [[ "${NAME}" == "chrome" ]]; then
        # shellcheck disable=SC2191
        DOCKER_OPT+=(--security-opt seccomp="$HOME"/.config/google-chrome/chrome.json)
    fi
    if [[ "${NAME}" == "dserver" ]]; then
        # shellcheck disable=SC2191
        DOCKER_OPT=(--rm --network=host --hostname=docker_"${NAME}" --volume /media:/media)
    fi
    if [[ "${NAME}" == "gparted" ]]; then
        if [[ ! "${DOCKER_PASSTHOUGH}" ]]; then
            printf '\r%s\n' "${YELLOW}Drive not defined${NC}"
            exit
        fi
        # shellcheck disable=SC2191
        DOCKER_OPT+=(--device "${DOCKER_PASSTHOUGH}":"${DOCKER_PASSTHOUGH}" --privileged)
    fi
}
#
tweet () {
    printf '%s\n' "Tweet ${NAME} push"
    # Code bits from - https://github.com/moebiuscurve/tweetExperiments/tree/master/curlTweets
    message="Pushed ${NAME}"
    message_string=$(echo -n "${message}"|sed -e s'/ /%2520/g')
    message_curl=$(echo -n "${message}"|sed -e s'/ /+/g')
    timestamp=$(date +%s)
    nonce=$(date +%s%T | openssl base64 | sed -e s'/[+=/]//g')
    api_version=1.1
    signature_base_string="POST&https%3A%2F%2Fapi.twitter.com%2F${api_version}%2Fstatuses%2Fupdate.json&oauth_consumer_key%3D${LP_T_CONSUMER_KEY}%26oauth_nonce%3D${nonce}%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D${timestamp}%26oauth_token%3D${LP_T_OAUTH_TOKEN}%26oauth_version%3D1.0%26status%3D${message_string}"
    signature_key="${LP_T_CONSUMER_SECRET}&${LP_T_OAUTH_SECRET}"
    oauth_signature=$(echo -n "${signature_base_string}" | openssl dgst -sha1 -hmac "${signature_key}" -binary | openssl base64 | sed -e s'/+/%2B/g' -e s'/\//%2F/g' -e s'/=/%3D/g')
    header="Authorization: OAuth oauth_consumer_key=\"${LP_T_CONSUMER_KEY}\", oauth_nonce=\"${nonce}\", oauth_signature=\"${oauth_signature}\", oauth_signature_method=\"HMAC-SHA1\", oauth_timestamp=\"${timestamp}\", oauth_token=\"${LP_T_OAUTH_TOKEN}\", oauth_version=\"1.0\""
    # shellcheck disable=SC2034
    result=$(curl -s -X POST "https://api.twitter.com/${api_version}/statuses/update.json" --data "status=${message_curl}" --header "Content-Type: application/x-www-form-urlencoded" --header "${header}")
}
#
all_apps () {
    # shellcheck disable=SC2207
    APPS=( $( \
        curl --silent --location --header "${GH_AUTH_HEADER}" --header "${GH_API_HEADER}" --url https://api.github.com/repos/forwardcomputers/dockerfiles/contents | \
        jq -r 'sort_by( .name )[] | select( .type == "dir" and ( .name | startswith( "." ) | not ) ) | .name' ) \
    )
}
#
appversions
main "$@"
