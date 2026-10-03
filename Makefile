SHELL := /bin/zsh

PROJECT := Doll.xcodeproj
SCHEME := Doll
APP_NAME ?= Doll2
CONFIGURATION ?= Debug
DERIVED_DATA := .build
INSTALL_DIR ?= $(HOME)/Applications
DEVELOPER_DIR ?= /Applications/Xcode.app/Contents/Developer

APP_BUNDLE := $(DERIVED_DATA)/Build/Products/$(CONFIGURATION)/$(APP_NAME).app
INSTALL_BUNDLE := $(INSTALL_DIR)/$(APP_NAME).app

.PHONY: help build release run install uninstall clean rebuild

help:
	@echo "Available targets:"
	@echo "  make build      Build $(SCHEME) in $(CONFIGURATION) mode"
	@echo "  make release    Build $(SCHEME) in Release mode"
	@echo "  make run        Build and launch the app"
	@echo "  make install    Build and install app bundle to $(INSTALL_DIR)"
	@echo "  make uninstall  Remove installed app bundle from $(INSTALL_DIR)"
	@echo "  make clean      Remove local build artifacts"
	@echo "  make rebuild    Clean then build"
	@echo ""
	@echo "Optional overrides:"
	@echo "  APP_NAME=Doll2"
	@echo "  CONFIGURATION=Debug|Release"
	@echo "  INSTALL_DIR=/path/to/install"

build:
	xcodebuild \
		-project $(PROJECT) \
		-scheme $(SCHEME) \
		-configuration $(CONFIGURATION) \
		-derivedDataPath $(DERIVED_DATA) \
		build

release:
	$(MAKE) build CONFIGURATION=Release

run: build
	open "$(APP_BUNDLE)"

install: build
	mkdir -p "$(INSTALL_DIR)"
	rm -rf "$(INSTALL_BUNDLE)"
	ditto "$(APP_BUNDLE)" "$(INSTALL_BUNDLE)"
	@echo "Installed to $(INSTALL_BUNDLE)"

uninstall:
	rm -rf "$(INSTALL_BUNDLE)"
	@echo "Removed $(INSTALL_BUNDLE)"

clean:
	rm -rf "$(DERIVED_DATA)"

rebuild: clean build
