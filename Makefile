CC      ?= cc
CFLAGS  ?= -std=c11 -D_POSIX_C_SOURCE=200809L -Wall -Wextra -Wpedantic -Werror -O2 -g
INCLUDE := -Iinclude
BUILD   := build

SRC   := $(wildcard src/*.c)
OBJ   := $(SRC:src/%.c=$(BUILD)/%.o)
LIB   := $(BUILD)/libkv.a

TESTS := $(wildcard tests/*.c)
TBIN  := $(TESTS:tests/%.c=$(BUILD)/tests/%)

BENCH := $(wildcard bench/*.c)
BBIN  := $(BENCH:bench/%.c=$(BUILD)/bench/%)

.PHONY: all test bench asan clean

all: $(if $(SRC),$(LIB))

$(LIB): $(OBJ)
	ar rcs $@ $^

$(BUILD)/%.o: src/%.c | $(BUILD)
	$(CC) $(CFLAGS) $(INCLUDE) -c $< -o $@

$(BUILD)/tests/%: tests/%.c $(LIB) | $(BUILD)/tests
	$(CC) $(CFLAGS) $(INCLUDE) $< $(LIB) -o $@

$(BUILD)/bench/%: bench/%.c $(LIB) | $(BUILD)/bench
	$(CC) $(CFLAGS) $(INCLUDE) $< $(LIB) -o $@

test: $(TBIN)
	@for t in $(TBIN); do echo "== $$t"; $$t || exit 1; done
	@echo "tests: done"

bench: $(BBIN)
	@for b in $(BBIN); do echo "== $$b"; $$b || exit 1; done

asan:
	$(MAKE) clean
	$(MAKE) test CFLAGS="$(CFLAGS) -O1 -fsanitize=address,undefined -fno-omit-frame-pointer" \
	             LDFLAGS="-fsanitize=address,undefined"

$(BUILD) $(BUILD)/tests $(BUILD)/bench:
	mkdir -p $@

clean:
	rm -rf $(BUILD)
