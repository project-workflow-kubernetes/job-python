# job-python

[![Build Status](http://img.shields.io/travis/liabifano/ml-aws.svg?style=flat)](https://travis-ci.com/project-workflow-kubernetes/job-python)



Dependencies to run the Makefile commands: `conda>=4.5.11, pylint>=2.1.1, docker>=18.06.1`


### To build image locally
```bash
make install
```

### To push the image
You must have `DOCKER_USERNAME` and `DOCKER_PASSWORD` available in the environment.
```bash
make push
```


### Install dependencies in your machine:
```bash
make install
```

### Run project (execute `main.py`):
```bash
make run
```

### Run tests in your machine:
```bash
make test
```

### Run tests in docker:
```bash
make test-in-docker
```
