CROSS-COMPILE ?= aarch64-linux-gnu-

AS = $(CROSS-COMPILE)as
LD = $(CROSS-COMPILE)ld

ASFLAGS = -g
LDFLAGS = -g -static

SRCS = prog3.s
OBJS = $(SRCS:.s=.o)

EXE = prog3

all: $(SRCS) $(EXE)

clean:
	rm -rf $(EXE) $(OBJS)

$(EXE): $(OBJS)
	$(LD) $(LDFLAGS) $(OBJS) -o $@

.s.o:
	$(AS) $(ASFLAGS) $< -o $@
