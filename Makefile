CURRENT_DIRECTORY := $(shell pwd)
include environment

build:
	sed -i.bak 's|^FROM.*|FROM $(DOCKER_BASE)|' Dockerfile && \
	docker build --build-arg KIBANA_VERSION=$(KIBANA_VERSION) --build-arg KIBANA_DOWNLOAD_URL=$(KIBANA_DOWNLOAD_URL) -t $(DOCKER_USER)/kibana --rm=true . && \
	mv Dockerfile.bak Dockerfile

debug:
	docker run -it -v $(REPO_WORKING_DIR)/config:/usr/share/kibana/config -v /tmp/kibana:/usr/share/kibana/data -p 5601:5601 --entrypoint=sh $(DOCKER_USER)/kibana

run:
	sed -i.bak 's|^elasticsearch.url:.*|elasticsearch.url: "$(ELASTIC_URL)"|' config/kibana.yml && \
	docker run -d --name kibana -v $(REPO_WORKING_DIR)/config:/usr/share/kibana/config -p 5601:5601 $(DOCKER_USER)/kibana 
