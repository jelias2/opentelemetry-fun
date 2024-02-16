MINIKUBE_STATUS := $(shell minikube status | grep -c "host: Running")
KUBECONFIG := $(HOME)/.kube/config
REGION := us-east1
# Check if the UUID environment variable is set
ifndef UUID
    UUID := $(shell uuidgen)
	export UUID
endif


.PHONY: help
help: ## help: print this help message
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'


.PHONY: minikube
minikube: ## minikube: start minikube
	minikube start --driver=docker 
	eval $(minikube -p minikube docker-env)
	minikube addons enable gcp-auth --refresh
	kubectl config use-context minikube



.PHONY: build
build: ## build: build the docker image
	docker build -t legal-term-api:$(UUID) .


.PHONY: run-docker
run-docker: build ## run-docker: run the docker image
	docker run legal-term-api:latest


.PHONY: check-minikube-status
check-minikube-status: ## check-minikube-status: check if minikube is running
	@if [ $(MINIKUBE_STATUS) -eq 0 ]; then \
		echo "Minikube is not running. Please start Minikube first."; \
		echo "minikube start --driver=docker \n" \

	else \
		echo "Minikube is running"; \
	fi

.PHONY: guard-%
guard-%:
	@if [ -z "${${*}}" ]; then \
		echo "Environment variable $* not set"; \
        exit 1; \
    fi

.PHONY: build-and-push
build-and-push: build
	docker tag legal-term-api:$(UUID) public.ecr.aws/e2c0f2y6/my-public-repo:$(UUID) 
	docker push public.ecr.aws/e2c0f2y6/my-public-repo:$(UUID)

.PHONY: expose-monitor
expose-monitor: check-minikube-status ## expose-monitor: expose prometheus and grafana on localhost:9090, and localhost:3000 respectively
	@kubectl port-forward -n default service/kube-prometheus-stack-prometheus 9090:9090 &
	@kubectl port-forward -n default service/kube-prometheus-stack-grafana 3000:80 &
	@echo "Grafana is now available on localhost:3000"
	@echo "Prometheus is now available on localhost:9090"
