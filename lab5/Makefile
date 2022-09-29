#!/bin/bash

CROSS_COMPILE ?= aarch64-linux-gnu-

PREFIX = /opt/gcc-linaro-7.5.0-2019.12-x86_64_aarch64-linux-gnu/aarch64-linux-gnu
LIBPATH = -L$(PREFIX)/libc/usr/lib -L$(PREFIX)/../lib/gcc/aarch64-linux-gnu/7.5.0
OBJPATH = $(PREFIX)/libc/usr/lib
LIBS = -lgcc -lgcc_eh -lc -lm
PREOBJ = $(OBJPATH)/crt1.o $(OBJPATH)/crti.o
POSTOBJ = $(OBJPATH)/crtn.o

CC = $(CROSS_COMPILE)gcc
AS = $(CROSS_COMPILE)as
LD = $(CROSS_COMPILE)ld

CCFLAGS = -g -c -Ofast
ASFLAGS = -g
LDFLAGS = -g -static

SRCS = prog1.c prog.s main.c
HEAD = prog1.h
OBJS = prog1.o prog.o main.o

EXE = main

all: $(SRCS) $(EXE)

clean:
	rm -rf $(EXE) $(OBJS)

$(OBJS): $(HEAD)

$(EXE): $(OBJS)
	$(LD) $(LDFLAGS) $(LIBPATH) $(PREOBJ) $(OBJS) $(POSTOBJ) -\( $(LIBS) -\) -o $@

.c.o:
	$(CC) $(CCFLAGS) $< -o $@

.s.o:
	$(AS) $(ASFLAGS) $< -o $@
