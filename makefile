MAKEFLAGS		+= --warn-undefined-variables --no-print-directory --no-builtin-rules --silent
SHELL			:= bash
.SHELLFLAGS		:= -eu -o pipefail -c
.DEFAULT_GOAL	:= help
#
BUILD_DATE		:= $(shell date +"%-d-%-m-%G %r")
CO				:= forwardcomputers
TARGET			:= $(strip $(word 1,$(MAKECMDGOALS)))
NAME			:= $(strip $(subst $(word 1,$(MAKECMDGOALS)),,$(MAKECMDGOALS)))
IMG				:= $(CO)/$(NAME)
BASE_IMAGE		:= $(shell sed -n -e 's/^FROM //p' $(NAME)/Dockerfile 2> /dev/null || true)
APPOLD			:= $(shell curl --silent --location --url https://registry.hub.docker.com/v2/repositories/forwardcomputers/$(NAME)/tags | jq --raw-output '.results|.[0]|.name' 2> /dev/null || true)
APPNEW			:= $(shell $(shell sed -n -e 's/^\#APPNEW //p' $(NAME)/Dockerfile 2> /dev/null || true))
#
NC				:= \033[0m
BLACK			:= \033[30m
BLUE			:= \033[34m
GREEN			:= \033[32m
CYAN			:= \033[36m
PURPLE			:= \033[35m
RED				:= \033[31m
WHITE			:= \033[37m
YELLOW			:= \033[1;33m
#
DOCKER_OPT		:= --rm --network=host --hostname=docker_$(NAME) \
					--env DISPLAY \
					--env GDK_SCALE \
					--env GDK_DPI_SCALE \
					--env PULSE_SERVER=unix:/run/user/$${UID}/pulse/native \
					--env QT_DEVICE_PIXEL_RATIO \
					--device /dev/dri \
					--device /dev/snd \
					--volume /media:/media \
					--volume /run/user/$${UID}/pulse:/run/user/1001/pulse \
					--volume /tmp/.X11-unix:/tmp/.X11-unix:ro \
					--volume /home/$${USER}:/home/duser
#
.PHONY: help
help: ## Show this help message
	@printf '%b' '\nUsage:\n  $(GREEN)make $(YELLOW)[target] $(BLUE)directory$(NC)\n\nTargets:\n' ;\
	grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; { printf "  $(GREEN)%-15s$(YELLOW)%s$(NC)\n", $$1, $$2} ' ;\
	printf '\n'
#
.PHONY: checkbaseimage
checkbaseimage:
	@docker pull $(IMG) > /dev/null 2>&1 || true ;\
	docker pull $(BASE_IMAGE) > /tmp/MAKE_BASE_LOG ;\
	rm -f /tmp/MAKE_BASE_UPDATED ;\
	if [ ! -z "$$(grep 'Pull complete' /tmp/MAKE_BASE_LOG)" ]; then touch -f /tmp/MAKE_BASE_UPDATED; fi ;\
	rm -f /tmp/MAKE_BASE_LOG
#
.PHONY: info
info: checkbaseimage ## Check if there is a newer application version
	@rm -f /tmp/MAKE_REBUILD ;\
	if [ $(APPNEW) = $(APPOLD) ] && [ ! -f /tmp/MAKE_BASE_UPDATED ]; then \
		printf '%b' '$(GREEN)Build is on latest version $(YELLOW)$(APPNEW)$(NC)\n' ;\
	else \
		if [ $(APPOLD) = 0 ]; then \
			printf '%b' '$(GREEN)Nonexistant in Docker, use "make upgrade" or "make build" to generate the latest version $(YELLOW)$(APPNEW)$(NC)\n' ;\
		else \
			if [ -f /tmp/MAKE_BASE_UPDATED ]; then \
				printf '%b' '$(RED)Base image $(YELLOW)$(BASE_IMAGE)$(NC) $(GREEN)has been updated\n' ;\
			else \
				printf '%b' '$(RED)Build is on older version $(YELLOW)$(APPOLD)$(NC) $(GREEN)current version $(YELLOW)$(APPNEW)$(NC)\n' ;\
			fi ;\
		fi ;\
		touch -f /tmp/MAKE_REBUILD ;\
	fi ;\
	rm -f /tmp/MAKE_BASE_UPDATED
#
.PHONY: update
update: upgrade
#
.PHONY: upgrade
upgrade: info ## Upgrade if there is a newer application version
	@if [ -f /tmp/MAKE_REBUILD ]; then \
		make build ;\
		make push ;\
		printf '%b' '$(GREEN)Rebuilt to the latest version $(YELLOW)$(APPNEW)$(NC)\n' ;\
		rm -f /tmp/MAKE_REBUILD ;\
	fi
#
.PHONY: build
build: ## Generate docker image file
	@docker build --rm --compress --label $(IMG) --tag $(IMG) --tag $(IMG):$(APPNEW) --build-arg REPO=$(NAME) --build-arg VERSION=$(APPNEW) --build-arg TEXT="$(BUILD_DATE)" .
#
.PHONY: push
push:  ## Push image to Docker Hub
	@docker push $(IMG):latest ;\
	docker push $(IMG):$(APPNEW) ;\
	touch /tmp/MAKE_PUSHED
#
.PHONY: checklocalimage
checklocalimage:
	@if ( ! docker image inspect $(IMG) > /dev/null 2>&1 ); then \
		docker pull $(IMG) > /dev/null 2>&1 || make build ;\
	fi 
#
.PHONY: run
run: checklocalimage ## Run the docker application
	@docker run --detach \
	--name $(NAME) \
	$(DOCKER_OPT) \
	$(IMG)
#
.PHONY: shell
shell: checklocalimage ## Run shell in docker application
	@docker run --interactive --tty \
	--name $(NAME)_shell \
	$(DOCKER_OPT) \
	$(IMG)
#
.PHONY: desktop
desktop: ## Populate desktop application menu
	$(info Populating application menu)
	-@cp $(NAME).* ~/.local/share/applications/
