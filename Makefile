
build:
	docker build --no-cache --build-arg S6_RELEASE=3.2.0.0 -t hakindazz/s6-overlay:3.2.0.0 .
