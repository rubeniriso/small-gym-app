.DEFAULT_GOAL := help

FLUTTER_BIN := $(HOME)/sdks/flutter/bin
ANDROID_SDK := $(HOME)/Android/Sdk
JDK := $(HOME)/sdks/jdk-21

.PHONY: help mobile-flutter mobile-flutter-apk

help:
	@echo "Gym — comandos locales"
	@echo ""
	@echo "  make mobile-flutter      Flutter en este repo (ARGS= pasa flags a flutter run)"
	@echo "  make mobile-flutter-apk  APK release de Android (ARGS= pasa flags a flutter build apk)"

mobile-flutter:
	@export PATH="$(FLUTTER_BIN):$$PATH"; \
	export ANDROID_HOME="$(ANDROID_SDK)"; \
	export JAVA_HOME="$(JDK)"; \
	command -v flutter >/dev/null || { echo "No está flutter. Añádelo al PATH o instálalo en $(FLUTTER_BIN)"; exit 1; }; \
	flutter pub get && flutter run $(ARGS)

mobile-flutter-apk:
	@export PATH="$(FLUTTER_BIN):$$PATH"; \
	export ANDROID_HOME="$(ANDROID_SDK)"; \
	export JAVA_HOME="$(JDK)"; \
	command -v flutter >/dev/null || { echo "No está flutter. Añádelo al PATH o instálalo en $(FLUTTER_BIN)"; exit 1; }; \
	flutter pub get && flutter build apk --release $(ARGS) && \
	echo "APK: build/app/outputs/flutter-apk/app-release.apk"
