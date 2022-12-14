if [ -z "${KOS_BASE}" ]; then
    export KOS_BASE="${DC_SYSROOT}/kos"
fi
#export KOS_PORTS="${DC_SYSROOT}/kos-ports"
export KOS_ARCH="dreamcast"
export KOS_SUBARCH="pristine"
export KOS_MAKE="make"
export KOS_LOADER="dc-tool -x"
export KOS_GENROMFS="${KOS_BASE}/utils/genromfs/genromfs"
export KOS_CC_BASE="${DC_HOST}"
export KOS_CC_PREFIX="sh-elf"
export DC_ARM_BASE="${DC_HOME}/host/arm-eabi"
export DC_ARM_PREFIX="arm-eabi"
#export PATH="${PATH}:${KOS_CC_BASE}/bin:/opt/toolchains/dc/bin"
export KOS_CFLAGS=""
export KOS_CPPFLAGS=""
export KOS_LDFLAGS=""
export KOS_AFLAGS=""
export KOS_CFLAGS="-O2 -fomit-frame-pointer"
. ${DC_HOME}/environ_base.sh

