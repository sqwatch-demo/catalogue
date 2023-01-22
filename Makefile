NAME = sqwatch-demo/catalogue
DBNAME = sqwatch-demo/catalogue-db

TAG ?= latest
BUILDER ?= minikube image

INSTANCE = catalogue

.PHONY: default copy test

default: test

release:
	$(BUILDER) build -t $(NAME):$(TAG) -f docker/catalogue/Dockerfile .

release-db:
	$(BUILDER) build -t $(DBNAME):$(TAG) -f Dockerfile docker/catalogue-db

test: 
	GROUP=weaveworksdemos COMMIT=test ./scripts/build.sh
	./test/test.sh unit.py
	./test/test.sh container.py --tag $(TAG)

dockertravisbuild: build
	docker build -t $(NAME):$(TAG) -f docker/catalogue/Dockerfile-release docker/catalogue/
	docker build -t $(DBNAME):$(TAG) -f docker/catalogue-db/Dockerfile docker/catalogue-db/
	docker login -u $(DOCKER_USER) -p $(DOCKER_PASS)
	scripts/push.sh
