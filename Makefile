.PHONY: cleantodo todo doNothing

all: clean build

clean:
	@echo "Cleaning todo list"
	python /home/takina/scripts/cleantodo.py

update:
	@echo "Updating stuff..."
	./scripts/update.sh

build:
	@echo "Building stuff..."
	./scripts/vimrc2coderc.sh

