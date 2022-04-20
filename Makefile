.DEFAULT_GOAL := all
dir_guard=@mkdir -p $(@D)

ifeq ($(DEBUG),1)
	opt_flags := -Og -g2 -ggdb2
else
	opt_flags := -Os -g0 -ffunction-sections -fdata-sections
endif

CFLAGS := -std=gnu17 -nostdlib $(opt_flags)
CXXFLAGS := -std=gnu++17 -nostdlib $(opt_flags)

# QEMU doesn't support any ez-clang lib yet
qemu/include/:
	$(dir_guard)
qemu/lib/:
	$(dir_guard)

include_dirs := src include
includes := $(addprefix -I,$(include_dirs))

due_flags := -mcpu=cortex-m3 -mthumb --config armv7m_soft_nofp_nosys
due_defs := -D__SAM3X8E__ -DARDUINO_SAM_DUE -DARDUINO=10805 -DARDUINO_ARCH_SAM
due_defs += -DF_CPU=84000000L -DUSBCON -DUSB_VID=0x2341 -DUSB_PID=0x003E

.build/due/ez/stdio/printf.cc.o: src/ez/stdio/printf.cc
	$(dir_guard)
	$(CXX) $(CXXFLAGS) $(due_flags) $(due_defs) $(includes) -c $< -o $@

due/lib/ez/stdio/printf.a: .build/due/ez/stdio/printf.cc.o
	$(dir_guard)
	$(AR) cr $@ $<

ifdef ARDUINO_DIR
arduino_include_subdirs := cores/arduino variants/arduino_due_x
arduino_include_subdirs += system/libsam system/CMSIS/CMSIS/Include system/CMSIS/Device/ATMEL
arduino_includes := $(addprefix -I$(ARDUINO_DIR)/,$(arduino_include_subdirs))

arduino_c := $(shell find $(ARDUINO_DIR)/cores/arduino -name '*.c')
arduino_cpp := $(shell find $(ARDUINO_DIR)/cores/arduino -name '*.cpp')
arduino_cpp += $(ARDUINO_DIR)/variants/arduino_due_x/variant.cpp

arduino_c_o := $(arduino_c:$(ARDUINO_DIR)/%=.build/due/ez/framework/%.o)
arduino_cpp_o := $(arduino_cpp:$(ARDUINO_DIR)/%=.build/due/ez/framework/%.o)
endif

.build/due/ez/framework/%.c.o: $(ARDUINO_DIR)/%.c
	$(dir_guard)
	$(CC) $(CFLAGS) $(due_flags) $(due_defs) $(arduino_includes) -c $< -o $@

.build/due/ez/framework/%.cpp.o: $(ARDUINO_DIR)/%.cpp
	$(dir_guard)
	$(CXX) $(CXXFLAGS) $(due_flags) $(due_defs) $(arduino_includes) -c $< -o $@

due/lib/ez/framework/Arduino.a: $(arduino_cpp_o) $(arduino_c_o)
	$(dir_guard)
	$(AR) cr $@ $(arduino_cpp_o) $(arduino_c_o)

due/lib/: due/lib/ez/framework/Arduino.a due/lib/ez/stdio/printf.a

due/include/:
	$(dir_guard)
	cp -r include due/.
	mkdir -p due/include/ez/framework
	cp $(ARDUINO_DIR)/cores/arduino/Arduino.h due/include/ez/framework/

.PHONY: due
due: due/include/ due/lib/

.PHONY: qemu
qemu: qemu/include/ qemu/lib/

.PHONY: all
all: due qemu

.PHONY: clean
clean:
	rm -rf .build
	rm -rf due
	rm -rf qemu
