REMOTE_REPO=liabifano
DOCKER_NAME=job
DOCKER_LABEL=latest
GIT_MASTER_HEAD_SHA:=$(shell git rev-parse --short=7 --verify HEAD)
PROJECT_NAME=job
TEST_PATH=./


help:
	@echo "install - install project in dev mode using conda"
	@echo "test -  run tests quickly within env: $(PROJECT_NAME)"
	@echo "lint - check code style"
	@echo "clean - remove build and python artifacts"
	@echo "clean-build - remove build artifacts"
	@echo "clean-pyc - remove python artifacts"
	@echo
	@echo "preprocessing - generates clean_train.csv, clean_test.csv"
	@echo "split - generates y_train.csv, X_train.csv, y_val, X_val"
	@echo "train - generates trained_model.pkl"
	@echo "score-test - generates score_test.csv"
	@echo "build - build docker image"
	@echo "push - push image to remote repository"


build:
	@docker build --no-cache -t ${REMOTE_REPO}/${DOCKER_NAME}:${DOCKER_LABEL} .
	@docker run ${REMOTE_REPO}/${DOCKER_NAME}:${DOCKER_LABEL} /bin/bash -c "cd job; py.test --verbose --color=yes"


push:
	@docker tag ${REMOTE_REPO}/${DOCKER_NAME}:${DOCKER_LABEL} ${REMOTE_REPO}/${DOCKER_NAME}:${GIT_MASTER_HEAD_SHA}
	@echo "${DOCKER_PASSWORD}" | docker login -u="${DOCKER_USERNAME}" --password-stdin
	@docker push ${REMOTE_REPO}/${DOCKER_NAME}:${GIT_MASTER_HEAD_SHA}



test: clean-pyc
	@echo "\n--- If the env $(PROJECT_NAME) doesn't exist, run 'make install' before ---\n"n
	@echo "\n--- Running tests at $(PROJECT_NAME) ---\n"
	bash -c "source activate $(PROJECT_NAME) &&  py.test --verbose --color=yes $(TEST_PATH)"


install: clean
	-@conda env remove -yq -n $(PROJECT_NAME) # ignore if fails
	@conda create -y --name $(PROJECT_NAME) --file conda.txt
	@echo "\n --- Creating env: $(PROJECT_NAME) in $(shell which conda) ---\n"
	@echo "\n--- Installing dependencies ---\n"
	bash -c "source activate $(PROJECT_NAME) && pip install -e . && pip install -U -r requirements.txt && source deactivate"


lint:
	-@pylint src/**/*.py --output-format text --reports no --msg-template "{path}:{line:04d}:{obj} {msg} ({msg_id})" | sort


clean-build:
	rm -fr build/
	rm -fr dist/
	rm -fr .eggs/
	find . -name '*.egg-info' -exec rm -fr {} +
	find . -name '*.egg' -exec rm -f {} +


clean-pyc:
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +


clean: clean-build clean-pyc


preprocessing: resources/train.csv resources/test.csv
	@echo "\n--- If the env $(PROJECT_NAME) doesn't exist, run 'make install' before ---\n"
	bash -c "source activate $(PROJECT_NAME)"
	@echo "\n--- Running preprocessing.py file ---\n"
	python src/$(PROJECT_NAME)/preprocessing.py


split: preprocessing resources/clean_train.csv
	@echo "\n--- If the env $(PROJECT_NAME) doesn't exist, run 'make install' before ---\n"
	bash -c "source activate $(PROJECT_NAME)"
	@echo "\n--- Running split.py file ---\n"
	python src/$(PROJECT_NAME)/split.py


train: split resources/X_train.csv resources/X_val.csv resources/y_train.csv resources/y_val.csv
	@echo "\n--- If the env $(PROJECT_NAME) doesn't exist, run 'make install' before ---\n"
	bash -c "source activate $(PROJECT_NAME)"
	@echo "\n--- Running train.py file ---\n"
	python src/$(PROJECT_NAME)/train.py


score-test: train resources/test.csv resources/trained_model.pkl
	@echo "\n--- If the env $(PROJECT_NAME) doesn't exist, run 'make install' before ---\n"
	bash -c "source activate $(PROJECT_NAME)"
	@echo "\n--- Running score.py file ---\n"
	python src/$(PROJECT_NAME)/score.py


