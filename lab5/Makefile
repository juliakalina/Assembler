CC       := aarch64-linux-gnu-gcc
EXE      := image.out

.PHONY: default
default: build

.PHONY: build
build: *.s *.c
	$(CC) $(OPTIMIZATION) -g -static -o  image.out $^ -lm

.PHONY: buildasm
buildasm: *.s *.c
	$(CC) $(OPTIMIZATION) -g -static -DASM -o image.out $^ -lm

.PHONY: clean
clean:
	-rm *.out *.o &> /dev/null || true
