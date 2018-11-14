REMOTE_REPO=liabifano

help:
	@echo "build-local"
	@echo "push-and-push"
	@echo "test"


build-local:
	@docker build -t  ${REMOTE_REPO}/executor .


build-and-push:
	@docker login --username=${DOCKER_USER} --password=${DOCKER_PASS} 2> /dev/null
	@docker build -t ${REMOTE_REPO}/executor .
	@docker push ${REMOTE_REPO}/executor


test: build-local
	-@docker run ${REMOTE_REPO}/executor /bin/bash -c "cd executor; py.test --verbose --color=yes"
	@docker rmi -f ${REMOTE_REPO}/executor
