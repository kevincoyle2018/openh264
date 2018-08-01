COMMON_SRCDIR=codec/common
COMMON_CPP_SRCS=\
	$(COMMON_SRCDIR)/src/common_tables.cpp\
	$(COMMON_SRCDIR)/src/copy_mb.cpp\
	$(COMMON_SRCDIR)/src/cpu.cpp\
	$(COMMON_SRCDIR)/src/crt_util_safe_x.cpp\
	$(COMMON_SRCDIR)/src/deblocking_common.cpp\
	$(COMMON_SRCDIR)/src/expand_pic.cpp\
	$(COMMON_SRCDIR)/src/intra_pred_common.cpp\
	$(COMMON_SRCDIR)/src/mc.cpp\
	$(COMMON_SRCDIR)/src/memory_align.cpp\
	$(COMMON_SRCDIR)/src/sad_common.cpp\
	$(COMMON_SRCDIR)/src/utils.cpp\
	$(COMMON_SRCDIR)/src/welsCodecTrace.cpp\
	$(COMMON_SRCDIR)/src/WelsTaskThread.cpp\
	$(COMMON_SRCDIR)/src/WelsThread.cpp\
	$(COMMON_SRCDIR)/src/WelsThreadLib.cpp\
	$(COMMON_SRCDIR)/src/WelsThreadPool.cpp\

COMMON_OBJS += $(COMMON_CPP_SRCS:.cpp=.$(OBJ))

COMMON_ASM_SRCS=\
	$(COMMON_SRCDIR)/x86/cpuid.asm\
	$(COMMON_SRCDIR)/x86/dct.asm\
	$(COMMON_SRCDIR)/x86/deblock.asm\
	$(COMMON_SRCDIR)/x86/expand_picture.asm\
	$(COMMON_SRCDIR)/x86/intra_pred_com.asm\
	$(COMMON_SRCDIR)/x86/mb_copy.asm\
	$(COMMON_SRCDIR)/x86/mc_chroma.asm\
	$(COMMON_SRCDIR)/x86/mc_luma.asm\
	$(COMMON_SRCDIR)/x86/satd_sad.asm\
	$(COMMON_SRCDIR)/x86/vaa.asm\

COMMON_OBJSASM += $(COMMON_ASM_SRCS:.asm=.$(OBJ))
ifeq ($(ASM_ARCH), x86)
COMMON_OBJS += $(COMMON_OBJSASM)
endif
OBJS += $(COMMON_OBJSASM)

COMMON_ASM_ARM_SRCS=\
	$(COMMON_SRCDIR)/arm/copy_mb_neon.S\
	$(COMMON_SRCDIR)/arm/deblocking_neon.S\
	$(COMMON_SRCDIR)/arm/expand_picture_neon.S\
	$(COMMON_SRCDIR)/arm/intra_pred_common_neon.S\
	$(COMMON_SRCDIR)/arm/mc_neon.S\

COMMON_OBJSARM += $(COMMON_ASM_ARM_SRCS:.S=.$(OBJ))
ifeq ($(ASM_ARCH), arm)
COMMON_OBJS += $(COMMON_OBJSARM)
endif
OBJS += $(COMMON_OBJSARM)

COMMON_ASM_ARM64_SRCS=\
	$(COMMON_SRCDIR)/arm64/copy_mb_aarch64_neon.S\
	$(COMMON_SRCDIR)/arm64/deblocking_aarch64_neon.S\
	$(COMMON_SRCDIR)/arm64/expand_picture_aarch64_neon.S\
	$(COMMON_SRCDIR)/arm64/intra_pred_common_aarch64_neon.S\
	$(COMMON_SRCDIR)/arm64/mc_aarch64_neon.S\

COMMON_OBJSARM64 += $(COMMON_ASM_ARM64_SRCS:.S=.$(OBJ))
ifeq ($(ASM_ARCH), arm64)
COMMON_OBJS += $(COMMON_OBJSARM64)
endif
OBJS += $(COMMON_OBJSARM64)

COMMON_ASM_MIPS64_SRCS=\
	$(COMMON_SRCDIR)/mips64/deblock_mmi.c\

COMMON_OBJSMIPS64 += $(COMMON_ASM_MIPS64_SRCS:.c=.$(OBJ))
ifeq ($(ASM_ARCH), mips64)
COMMON_OBJS += $(COMMON_OBJSMIPS64)
endif
OBJS += $(COMMON_OBJSMIPS64)

OBJS += $(COMMON_OBJS)

$(COMMON_SRCDIR)/%.$(OBJ): $(COMMON_SRCDIR)/%.cpp
	$(QUIET_CXX)$(CXX) $(CFLAGS) $(CXXFLAGS) $(INCLUDES) $(COMMON_CFLAGS) $(COMMON_INCLUDES) -c $(CXX_O) $<

$(COMMON_SRCDIR)/%.$(OBJ): $(COMMON_SRCDIR)/%.asm
	$(QUIET_ASM)$(ASM) $(ASMFLAGS) $(ASM_INCLUDES) $(COMMON_ASMFLAGS) $(COMMON_ASM_INCLUDES) -o $@ $<

$(COMMON_SRCDIR)/%.$(OBJ): $(COMMON_SRCDIR)/%.S
	$(QUIET_CCAS)$(CCAS) $(CCASFLAGS) $(ASMFLAGS) $(INCLUDES) $(COMMON_CFLAGS) $(COMMON_INCLUDES) -c -o $@ $<

$(COMMON_SRCDIR)/%.$(OBJ): $(COMMON_SRCDIR)/%.c
	$(QUIET_CC)$(CC) $(CFLAGS) $(ASMFLAGS) $(INCLUDES) $(COMMON_CFLAGS) $(COMMON_INCLUDES) -c -o $@ $<

$(LIBPREFIX)common.$(LIBSUFFIX): $(COMMON_OBJS)
	$(QUIET)rm -f $@
	$(QUIET_AR)$(AR) $(AR_OPTS) $+

libraries: $(LIBPREFIX)common.$(LIBSUFFIX)
LIBRARIES += $(LIBPREFIX)common.$(LIBSUFFIX)
