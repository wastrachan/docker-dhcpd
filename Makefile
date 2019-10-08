# Docker Image Makefile
#
# Copyright (c) Winston Astrachan 2019
#
help:
	@echo ""
	@echo "Usage: make COMMAND"
	@echo ""
	@echo "Docker Image makefile"
	@echo ""
	@echo "Commands:"
	@echo "  build        Build and tag image"
	@echo "  run          Start container in the background with locally mounted volume"
	@echo "  stop         Stop and remove container running in the background"
	@echo "  clean        Mark image for rebuild"
	@echo "  delete       Delete image and mark for rebuild"
	@echo ""

build: .dhcpd.img

.dhcpd.img:
	docker build -t wastrachan/dhcpd:latest .
	@touch $@

.PHONY: run
run: build
	docker run -v "$(CURDIR)/config:/config" \
	           --name dhcpd \
	           -e PUID=1111 \
	           -e PGID=1112 \
	           -p 67:67/udp \
	           --restart unless-stopped \
	           wastrachan/dhcpd:latest

.PHONY: stop
stop:
	docker stop dhcpd
	docker rm dhcpd

.PHONY: clean
clean:
	rm -f .dhcpd.img

.PHONY: delete
delete: clean
	docker rmi -f wastrachan/dhcpd
