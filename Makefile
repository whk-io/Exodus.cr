console: build env

build:
	docker build -t crystal-dev .

env:
	docker run -w /exodus -ti -v "$(shell pwd)/exodus:/exodus" crystal-dev /bin/bash
