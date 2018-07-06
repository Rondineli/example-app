.PHONY: help

help:
	@echo "Usage: make command"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
            awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

lint: ## Run flake8
	@pipenv run flake8 .

build_docker: ## Running test
	@sudo docker build -t example-app  .

test: ## Run unittests
	@sudo python3 ./tests.py

run_docker: build_docker
	@sudo docker run -t -d -p 5000:5000 example-app

create_pod_env_vars:
	@sudo bash -x ./script.sh
