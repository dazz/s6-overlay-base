
.PHONY: build
build:
	docker build --no-cache --build-arg S6_RELEASE=3.2.0.0 -t hakindazz/s6-overlay-base:3.2.0.0 .

.PHONY: push
push:
	docker push hakindazz/s6-overlay-base:3.2.0.0