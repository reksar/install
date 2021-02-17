PACKAGES_GROUP := my
DEB_DIR := $(CURDIR)/deb
DEB_REPO := /etc/apt/sources.list.d/$(PACKAGES_GROUP).list
.DEFAULT_GOAL := repo


.PHONY: repo
repo: $(DEB_REPO)
	dpkg-scanpackages $(DEB_DIR) /dev/null | gzip -9c > $(DEB_DIR)/Packages.gz
	sudo aptitude update


.PHONY: unrepo
unrepo:
	sudo rm $(DEB_REPO)
	sudo aptitude update


$(DEB_REPO):
	echo "deb [trusted=yes] file:$(DEB_DIR) ./" | sudo tee $(DEB_REPO)
