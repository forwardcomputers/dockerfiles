#!/bin/bash
set -E              # any trap on ERR is inherited by shell functions
set -e              # exit if error occurs
set -u              # treat unset variables and parameters as an error
set -o pipefail     # fail if pipe failed
#set -x              # show every commond
#
GH_API_HEADER="Accept: application/vnd.github.v3+json"
GH_AUTH_HEADER="Authorization: token ${LP_GITHUB_API_TOKEN}"
#
BUILD_DATE="$(date +'%-d-%-m-%G %r')"
CO="forwardcomputers"
NAME=$( echo "${2-none}" | cut -d '/' -f 1 )
IMG="${CO}/${NAME}"
BASE_IMAGE="$(sed -n -e 's/^FROM //p' "${NAME}"/Dockerfile 2> /dev/null || true)"
APPOLD="$(curl --silent --location --url https://registry.hub.docker.com/v2/repositories/forwardcomputers/"${NAME}"/tags | jq --raw-output '.results|.[0]|.name // 0')"
set +e
eval APPNEW=\$\("$(grep -oP '(?<=APPNEW ).*' "${NAME}"/Dockerfile 2> /dev/null || true)"\)
set -e
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
DOCKER_OPT=(--rm --network=host --hostname=docker_"${NAME}" \
            --env DISPLAY \
            --env GDK_SCALE \
            --env GDK_DPI_SCALE \
            --env PULSE_SERVER=unix:/run/user/"${UID}"/pulse/native \
            --env QT_DEVICE_PIXEL_RATIO \
            --device /dev/bus/usb \
            --device /dev/dri \
            --device /dev/snd \
            --volume /dev/shm:/dev/shm \
            --volume /etc/machine-id:/etc/machine-id:ro \
            --volume /media:/media \
            --volume /run/user/"${UID}"/pulse:/run/user/1001/pulse \
            --volume /tmp/.X11-unix:/tmp/.X11-unix:ro \
            --volume /home/"${USER}":/home/duser)
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
    printf "%b" "\\nUsage:\\n  ${GREEN}dapp ${YELLOW}[target] ${CYAN}directory${NC}\\n\\nTargets:\\n"
    grep -E '^[a-zA-Z_-]+.*{.*?## .*$' "${0}" | sort | awk 'BEGIN {FS = "\\(.*?## "}; { printf "  '${GREEN}'%-15s'${YELLOW}'%s'${NC}'\n", $1, $2} '
    printf '\n'
}
#
info () { ## Check if there is a newer application version
    checkbaseimage
    if [[ ! "${APPNEW}" ]]; then APPNEW=null; fi
    if [[ "${APPNEW}" = "${APPOLD}" && ! -f /tmp/MAKE_BASE_UPDATED ]]; then
        printf '%b' "${YELLOW}${NAME}${GREEN} Build is on latest version ${YELLOW}${APPNEW}${NC}\\n"
    else
        if [[ ${APPOLD} = 0 ]]; then
            if [[ ${APPNEW} = "null" ]]; then APPNEW=""; fi
            printf '%b' "${GREEN}Nonexistant in Docker, use ${YELLOW}'dapp upgrade ${NAME}'${GREEN} or ${YELLOW}'dapp build ${NAME}'${GREEN} to generate the latest version ${YELLOW}${APPNEW}${NC}\\n"
        else
            if [[ -f /tmp/MAKE_BASE_UPDATED ]]; then
                printf '%b' "${YELLOW}${NAME}${GREEN} ${RED}Base image ${YELLOW}${BASE_IMAGE}${NC} ${GREEN}has been updated\\n"
            else \
                printf '%b' "${YELLOW}${NAME}${GREEN} ${RED}Build is on older version ${YELLOW}${APPOLD}${NC} ${GREEN}current version ${YELLOW}${APPNEW}${NC}\\n"
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
    printf '%s\n' "Upgrading ${NAME}"
    info
    if [[ -f /tmp/MAKE_REBUILD ]]; then
        build
        push
        printf '%b' "${GREEN}Rebuilt ${YELLOW}${NAME}${GREEN} to the latest version ${YELLOW}${APPNEW}${NC}\\n"
        rm -f /tmp/MAKE_REBUILD
    fi
}
#
upgrade_all () { ## Upgrade all applications
    printf '%s\n' "Upgrading applications"
    all_apps
    for NAME in "${APPS[@]}"; do
        IMG="${CO}/${NAME}"
        BASE_IMAGE="$(sed -n -e 's/^FROM //p' "${NAME}"/Dockerfile 2> /dev/null || true)"
        APPOLD="$(curl --silent --location --url https://registry.hub.docker.com/v2/repositories/forwardcomputers/"${NAME}"/tags | jq --raw-output '.results|.[0]|.name // 0')"
        set +e
        eval APPNEW=\$\("$(grep -oP '(?<=APPNEW ).*' "${NAME}"/Dockerfile 2> /dev/null || true)"\)
        set -e
        upgrade
    done
}
#
rebuild_all () { ## Rebuild all applications
    printf '%s\n' "Rebuilding all applications"
    all_apps
    for NAME in "${APPS[@]}"; do
        IMG="${CO}/${NAME}"
        set +e
        eval APPNEW=\$\("$(grep -oP '(?<=APPNEW ).*' "${NAME}"/Dockerfile 2> /dev/null || true)"\)
        set -e
        build
        push
        printf '%b' "${GREEN}Built ${YELLOW}${NAME}${GREEN} to the latest version ${YELLOW}${APPNEW}${NC}\\n"
    done
}
#
build () { ## Build docker image file
    printf '%s\n' "Buildng ${NAME}"
    docker build --rm --force-rm --compress --label "${IMG}" --tag "${IMG}" --tag "${IMG}":"${APPNEW}" --build-arg REPO="${NAME}" --build-arg VERSION="${APPNEW}" --build-arg TEXT="${BUILD_DATE}" "${NAME}"
}
#
push () {  ## Push image to Docker Hub
    printf '%s\n' "Pushing ${NAME} to Docker hub"
    docker push "${IMG}":latest
    docker push "${IMG}":"${APPNEW}"
    tweet
}
#
run () { ## Run the docker application
    printf '%s\n' "Runing ${NAME}"
    checklocalimage
    docker run --detach --name "${NAME}" "${DOCKER_OPT[@]}" "${IMG}"
}
#
shell () { ## Run shell in docker application
    printf '%s\n' "Runing shell in ${NAME}"
    checklocalimage
    docker run --interactive --tty --name "${NAME}"_shell "${DOCKER_OPT[@]}" "${IMG}" /bin/bash
}
#
desktop () { ## Populate desktop application menu
    printf '%s\n' "Populating application menu"
    DESKTOP_NAME="$(grep -oP '(?<=DESKTOP_NAME ).*' "${NAME}"/Dockerfile 2> /dev/null || true)"
    DESKTOP_COMMENT="$(grep -oP '(?<=DESKTOP_COMMENT ).*' "${NAME}"/Dockerfile 2> /dev/null || true)"
    DESKTOP_CATEGORIES="$(grep -oP '(?<=DESKTOP_CATEGORIES ).*' "${NAME}"/Dockerfile 2> /dev/null || true)"
    DESKTOP_MIMETYPES="$(grep -oP '(?<=DESKTOP_MIMETYPES ).*' "${NAME}"/Dockerfile 2> /dev/null || true)"
    DESKTOP_LOGO="$(grep -oP '(?<=DESKTOP_LOGO ).*' "${NAME}"/Dockerfile 2> /dev/null || true)"
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
        "[//]: # (BlockStart)" > README.md
    for APP in "${APPS[@]}"; do
        printf '%s\n' \
            "[![Docker push](https://img.shields.io/badge/dynamic/json.svg?query=$.Labels.BuildDate&label=${APP}%20pushed%20on&url=https://api.microbadger.com/v1/images/forwardcomputers/${APP})](https://hub.docker.com/r/forwardcomputers/${APP})" \
            "[![Github](https://img.shields.io/badge/github--grey.svg?label=&logo=github&logoColor=white)](https://github.com/forwardcomputers/${APP})" \
            "[![Docker](https://img.shields.io/badge/docker--E5E5E5.svg?label=&logo=docker)](https://hub.docker.com/r/forwardcomputers/${APP})" \
            "[![Docker release](https://img.shields.io/badge/dynamic/json.svg?query=$.results.0.name&label=latest%20tag&url=https://registry.hub.docker.com/v2/repositories/forwardcomputers/${APP}/tags)](https://hub.docker.com/r/forwardcomputers/${APP})" \
            "[![Microbadger](https://images.microbadger.com/badges/image/forwardcomputers/${APP}.svg)](http://microbadger.com/images/forwardcomputers/${APP} \"Image size\")" \
            "<br/>" >> README.md
    done
    printf '\n%s\n' \
        "[//]: # (BlockEnd)" \
        "This setup is largely based on Jessie Frazelle work [https://github.com/jfrazelle/dockerfiles](https://github.com/jfrazelle/dockerfiles)" >> README.md
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
    if [[ "${NAME}" = "chrome" ]]; then
        # shellcheck disable=SC2191
        DOCKER_OPT+=(--security-opt seccomp="$HOME"/.config/google-chrome/chrome.json)
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
        jq -r 'sort_by(.name)[] | select(.type == "dir" and .name != ".circleci") | .name') \
    )
}
#
main "$@"