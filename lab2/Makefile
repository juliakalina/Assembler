CROSS-COMPILE ?= aarch64-linux-gnu-

AS = $(CROSS-COMPILE)as
LD = $(CROSS-COMPILE)ld

ASFLAGS = -g
LDFLAGS = -g -static

ifeq ($(MAKECMDGOALS),reverse)
	ASFLAGS := $(ASFLAGS) --defsym reverse=1
endif

SRCS = prog2.s
OBJS = $(SRCS:.s=.o)

EXE = prog2

all: $(SRCS) $(EXE)

clean:
	rm -rf $(EXE) $(OBJS)

reverse: $(SRCS) $(EXE)

$(EXE): $(OBJS)
	$(LD) $(LDFLAGS) $(OBJS) -o $@

.s.o:
	$(AS) $(ASFLAGS) $< -o $@
