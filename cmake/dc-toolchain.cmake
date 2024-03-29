cmake_minimum_required(VERSION 3.6.0)

if (NOT DEFINED ENV{DC_HOME})
  set(DC_HOME "/opt/pacbrew/dc")
  set(ENV{DC_HOME} ${DC_HOME})
else ()
  set(DC_HOME $ENV{DC_HOME})
endif ()

if (NOT DEFINED ENV{KOS_BASE})
  set(KOS_BASE "/opt/pacbrew/dc/target/sh-elf/kos")
  set(ENV{KOS_BASE} ${KOS_BASE})
else ()
  set(KOS_BASE $ENV{KOS_BASE})
endif ()

set(PLATFORM_DREAMCAST TRUE CACHE BOOL "")
set(DREAMCAST TRUE CACHE BOOL "")
set(UNIX TRUE CACHE BOOL "")
set(DC_SYSROOT "${DC_HOME}/target/sh-elf")

set(TARGET "sh-elf")
set(CMAKE_SYSTEM_NAME "Generic")
set(CMAKE_SYSTEM_PROCESSOR "sh")
set(CMAKE_SYSTEM_VERSION 12)
set(CMAKE_CROSSCOMPILING TRUE)
set(CMAKE_SYSROOT ${DC_SYSROOT})
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

# toolchain setup
set(DC_HOST "${DC_HOME}/host/${TARGET}")
set(DC_CROSS_PREFIX "${DC_HOST}/bin")
set(DC_TOOLS_COMPILER_PREFIX "${DC_CROSS_PREFIX}/${TARGET}-")

set(CMAKE_ASM_COMPILER "${DC_TOOLS_COMPILER_PREFIX}gcc" CACHE PATH "")
set(CMAKE_C_COMPILER "${DC_TOOLS_COMPILER_PREFIX}gcc" CACHE PATH "")
set(CMAKE_CXX_COMPILER "${DC_TOOLS_COMPILER_PREFIX}g++" CACHE PATH "")
set(CMAKE_LINKER "${DC_TOOLS_COMPILER_PREFIX}ld" CACHE PATH "")
set(CMAKE_AR "${DC_TOOLS_COMPILER_PREFIX}ar" CACHE PATH "")
set(CMAKE_RANLIB "${DC_TOOLS_COMPILER_PREFIX}ranlib" CACHE PATH "")
set(CMAKE_NM "${DC_TOOLS_COMPILER_PREFIX}nm" CACHE PATH "")
set(CMAKE_STRIP "${DC_TOOLS_COMPILER_PREFIX}strip" CACHE PATH "")
set(CMAKE_OBJCOPY "${DC_TOOLS_COMPILER_PREFIX}objcopy" CACHE FILEPATH "")

set(DC_COMMON_CFLAGS "-D__DREAMCAST__ -D_arch_dreamcast -D_arch_sub_pristine -Wall -g -ml -m4-single-only -ffunction-sections -fdata-sections -fomit-frame-pointer -fno-builtin")
set(DC_COMMON_INCS "-I${KOS_BASE}/include -I${KOS_BASE}/kernel/arch/dreamcast/include -I${KOS_BASE}/addons/include -I${DC_SYSROOT}/usr/include")
set(DC_COMMON_LDFLAGS "-L${KOS_BASE}/lib/dreamcast -L${KOS_BASE}/addons/lib/dreamcast -L${DC_SYSROOT}/usr/lib")
set(DC_KOS_LIBS "-Wl,--start-group -lstdc++ -lc -lgcc -Wl,--end-group -lm")

#set(CMAKE_ASM_FLAGS_INIT "${CMAKE_ASM_FLAGS_INIT} ${DC_COMMON_CFLAGS} -little")
set(CMAKE_C_FLAGS_INIT "${CMAKE_C_FLAGS_INIT} ${CMAKE_ASM_FLAGS_INIT} ${DC_COMMON_CFLAGS} ${DC_COMMON_INCS}")
set(CMAKE_CXX_FLAGS_INIT "${CMAKE_CXX_FLAGS_INIT} ${CMAKE_C_FLAGS_INIT} ${DC_COMMON_CFLAGS} ${DC_COMMON_INCS} -fno-operator-names -fno-rtti -fno-exceptions")
set(CMAKE_C_STANDARD_LIBRARIES "${CMAKE_C_STANDARD_LIBRARIES} ${DC_KOS_LIBS}")
set(CMAKE_CXX_STANDARD_LIBRARIES "${CMAKE_CXX_STANDARD_LIBRARIES} ${DC_KOS_LIBS}")
set(CMAKE_EXE_LINKER_FLAGS_INIT "${DC_COMMON_LDFLAGS} ${DC_KOS_LIBS} -ml -m4-single-only -Wl,-Ttext=0x8c010000 -Wl,--gc-sections -T${KOS_BASE}/utils/ldscripts/shlelf.xc ${DC_KOS_LIBS}")

set_property(DIRECTORY PROPERTY TARGET_SUPPORTS_SHARED_LIBS FALSE)

set(CMAKE_FIND_ROOT_PATH ${DC_SYSROOT}/usr)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM BOTH)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
set(CMAKE_FIND_PACKAGE_PREFER_CONFIG TRUE)

set(BUILD_SHARED_LIBS OFF CACHE INTERNAL "Shared libs not available")

find_program(PKG_CONFIG_EXECUTABLE NAMES ${TARGET}-pkg-config HINTS "${DC_SYSROOT}/usr/bin")
if (NOT PKG_CONFIG_EXECUTABLE)
  message(WARNING "Could not find ${TARGET}-pkg-config: try installing dc-pkg-config package")
endif ()

# needed by kos "bin2o" utility
set(KOS_ARCH "dreamcast")
set(KOS_AS "${DC_TOOLS_COMPILER_PREFIX}as")
set(KOS_AFLAGS "-little")
set(KOS_LD ${CMAKE_LINKER})
set(KOS_OBJCOPY ${CMAKE_OBJCOPY})
