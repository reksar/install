PACKAGES_GROUP := my
DEB_DIR := $(CURDIR)/deb
REPO_SOURCE := /etc/apt/sources.list.d/$(PACKAGES_GROUP).list
.DEFAULT_GOAL := repo


.PHONY: repo
repo: $(REPO_SOURCE)
	dpkg-scanpackages $(DEB_DIR) /dev/null | gzip -9c > $(DEB_DIR)/Packages.gz
	sudo aptitude update


$(REPO_SOURCE):
	echo "deb [trusted=yes] file:$(DEB_DIR) ./" | sudo tee $(REPO_SOURCE)


.PHONY: unrepo
unrepo:
	sudo rm $(REPO_SOURCE)
	sudo aptitude update

