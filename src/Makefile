FILES = main.tf

.PHONY: all clean
all: main
# Added all files to be scanned for changes

main: $(FILES)
	terraform apply
clean:
	terraform destroy
