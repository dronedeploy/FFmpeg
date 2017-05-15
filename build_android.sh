export NDK=~/Android/Ndk14b
#export NDK=/cygdrive/c/Users/jacky.qiu/projects/online_transcode/ndk_linux
 
if [ "$NDK" = "" ]; then
	echo NDK variable not set, exiting
	echo "Use: export NDK=/your/path/to/android-ndk"
	exit 1
fi

OS=`uname -s | tr '[A-Z]' '[a-z]'`
#OS=linux

function build_x264
{
	PLATFORM=$NDK/platforms/$PLATFORM_VERSION/arch-$ARCH/
	export PATH=${PATH}:$PREBUILT/bin/
	CROSS_COMPILE=$PREBUILT/bin/$EABIARCH-
	CFLAGS=$OPTIMIZE_CFLAGS
#CFLAGS=" -I$ARM_INC -fpic -DANDROID -fpic -mthumb-interwork -ffunction-sections -funwind-tables -fstack-protector -fno-short-enums -D__ARM_ARCH_5__ -D__ARM_ARCH_5T__ -D__ARM_ARCH_5E__ -D__ARM_ARCH_5TE__  -Wno-psabi -march=armv5te -mtune=xscale -msoft-float -mthumb -Os -fomit-frame-pointer -fno-strict-aliasing -finline-limit=64 -DANDROID  -Wa,--noexecstack -MMD -MP "
	export CPPFLAGS="$CFLAGS"
	export CFLAGS="$CFLAGS"
	export CXXFLAGS="$CFLAGS"
	export CXX="${CROSS_COMPILE}g++ --sysroot=$PLATFORM"
	export AS="${CROSS_COMPILE}gcc --sysroot=$PLATFORM"
	export CC="${CROSS_COMPILE}gcc --sysroot=$PLATFORM"
	export NM="${CROSS_COMPILE}nm"
	export STRIP="${CROSS_COMPILE}strip"
	export RANLIB="${CROSS_COMPILE}ranlib"
	export AR="${CROSS_COMPILE}ar"
	export LDFLAGS="-Wl,-rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib -nostdlib -lc -lm -ldl -llog"

	cd x264-amanda
	#./configure --prefix=$(pwd)/$PREFIX --host=$ARCH-linux --disable-static $ADDITIONAL_CONFIGURE_FLAG --extra-cflags="$OPTIMIZE_CFLAGS" || exit 1
	./configure \
	    --cross-prefix=$CROSS_COMPILE \
	    --prefix=$(pwd)/$PREFIX \
	    --host=$ARCH-linux \
	    --enable-pic \
	    --enable-strip \
	    --disable-static \
	    --disable-shared \
	    --disable-cli \
	    --disable-asm \
	    --disable-thread \
	    --sysroot=$NDK/platforms/android-21/arch-arm \
	    --extra-cflags="$OPTIMIZE_CFLAGS" \
	    || exit 1
	make clean || exit 1
	make -j4 STRIP= install || exit 1
	cd ..
}

function build_x264_v8
{
	PLATFORM=$NDK/platforms/$PLATFORM_VERSION/arch-$ARCH/
	export PATH=${PATH}:$PREBUILT/bin/
	CROSS_COMPILE=$PREBUILT/bin/$EABIARCH-
	CFLAGS=$OPTIMIZE_CFLAGS
#CFLAGS=" -I$ARM_INC -fpic -DANDROID -fpic -mthumb-interwork -ffunction-sections -funwind-tables -fstack-protector -fno-short-enums -D__ARM_ARCH_5__ -D__ARM_ARCH_5T__ -D__ARM_ARCH_5E__ -D__ARM_ARCH_5TE__  -Wno-psabi -march=armv5te -mtune=xscale -msoft-float -mthumb -Os -fomit-frame-pointer -fno-strict-aliasing -finline-limit=64 -DANDROID  -Wa,--noexecstack -MMD -MP "
	export CPPFLAGS="$CFLAGS"
	export CFLAGS="$CFLAGS"
	export CXXFLAGS="$CFLAGS"
	export CXX="${CROSS_COMPILE}g++ --sysroot=$PLATFORM"
	export AS="${CROSS_COMPILE}gcc --sysroot=$PLATFORM"
	export CC="${CROSS_COMPILE}gcc --sysroot=$PLATFORM"
	export NM="${CROSS_COMPILE}nm"
	export STRIP="${CROSS_COMPILE}strip"
	export RANLIB="${CROSS_COMPILE}ranlib"
	export AR="${CROSS_COMPILE}ar"
	export LDFLAGS="-Wl,-rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib -nostdlib -lc -lm -ldl -llog"

	cd x264-amanda
	#./configure --prefix=$(pwd)/$PREFIX --host=$ARCH-linux --disable-static $ADDITIONAL_CONFIGURE_FLAG --extra-cflags="$OPTIMIZE_CFLAGS" || exit 1
	./configure \
	    --cross-prefix=$CROSS_COMPILE \
	    --prefix=$(pwd)/$PREFIX \
	    --host=$ABI-linux \
	    --enable-pic \
	    --enable-strip \
	    --disable-static \
	    --disable-shared \
	    --disable-cli \
	    --enable-asm \
	    --disable-thread \
	    --sysroot=$NDK/platforms/android-21/arch-arm \
	    --extra-cflags="$OPTIMIZE_CFLAGS" \
	    || exit 1
	make clean || exit 1
	make -j4 STRIP= install || exit 1
	cd ..
}

function build_amr
{
	PLATFORM=$NDK/platforms/$PLATFORM_VERSION/arch-$ARCH/
	export PATH=${PATH}:$PREBUILT/bin/
	CROSS_COMPILE=$PREBUILT/bin/$EABIARCH-
	CFLAGS=$OPTIMIZE_CFLAGS
#CFLAGS=" -I$ARM_INC -fpic -DANDROID -fpic -mthumb-interwork -ffunction-sections -funwind-tables -fstack-protector -fno-short-enums -D__ARM_ARCH_5__ -D__ARM_ARCH_5T__ -D__ARM_ARCH_5E__ -D__ARM_ARCH_5TE__  -Wno-psabi -march=armv5te -mtune=xscale -msoft-float -mthumb -Os -fomit-frame-pointer -fno-strict-aliasing -finline-limit=64 -DANDROID  -Wa,--noexecstack -MMD -MP "
	export CPPFLAGS="$CFLAGS"
	export CFLAGS="$CFLAGS"
	export CXXFLAGS="$CFLAGS"
	export CXX="${CROSS_COMPILE}g++ --sysroot=$PLATFORM"
	export CC="${CROSS_COMPILE}gcc --sysroot=$PLATFORM"
	export NM="${CROSS_COMPILE}nm"
	export STRIP="${CROSS_COMPILE}strip"
	export RANLIB="${CROSS_COMPILE}ranlib"
	export AR="${CROSS_COMPILE}ar"
	export LDFLAGS="-Wl,-rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib -nostdlib -lc -lm -ldl -llog"

	cd vo-amrwbenc
	./configure \
	    --prefix=$(pwd)/$PREFIX \
	    --host=$ARCH-linux \
	    --disable-dependency-tracking \
	    --disable-shared \
            --disable-gpl \
	    --disable-version3 \
	    --disable-static \
	    --with-pic \
	    $ADDITIONAL_CONFIGURE_FLAG \
	    || exit 1

	make clean || exit 1
	make -j4 install || exit 1
	cd ..
}

function build_amr_v8
{
	PLATFORM=$NDK/platforms/$PLATFORM_VERSION/arch-$ARCH/
	export PATH=${PATH}:$PREBUILT/bin/
	CROSS_COMPILE=$PREBUILT/bin/$EABIARCH-
	CFLAGS=$OPTIMIZE_CFLAGS
#CFLAGS=" -I$ARM_INC -fpic -DANDROID -fpic -mthumb-interwork -ffunction-sections -funwind-tables -fstack-protector -fno-short-enums -D__ARM_ARCH_5__ -D__ARM_ARCH_5T__ -D__ARM_ARCH_5E__ -D__ARM_ARCH_5TE__  -Wno-psabi -march=armv5te -mtune=xscale -msoft-float -mthumb -Os -fomit-frame-pointer -fno-strict-aliasing -finline-limit=64 -DANDROID  -Wa,--noexecstack -MMD -MP "
	export CPPFLAGS="$CFLAGS"
	export CFLAGS="$CFLAGS"
	export CXXFLAGS="$CFLAGS"
	export CXX="${CROSS_COMPILE}g++ --sysroot=$PLATFORM"
	export CC="${CROSS_COMPILE}gcc --sysroot=$PLATFORM"
	export NM="${CROSS_COMPILE}nm"
	export STRIP="${CROSS_COMPILE}strip"
	export RANLIB="${CROSS_COMPILE}ranlib"
	export AR="${CROSS_COMPILE}ar"
	export LDFLAGS="-Wl,-rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib -nostdlib -lc -lm -ldl -llog"

	cd vo-amrwbenc
	./configure \
	    --prefix=$(pwd)/$PREFIX \
	    --host=$ABI-linux \
	    --disable-dependency-tracking \
	    --disable-shared \
	    --disable-version3 \
            --disable-gpl \
	    --disable-static \
	    --with-pic \
	    $ADDITIONAL_CONFIGURE_FLAG \
	    || exit 1

	make clean || exit 1
	make -j4 install || exit 1
	cd ..
}
function build_aac
{
	PLATFORM=$NDK/platforms/$PLATFORM_VERSION/arch-$ARCH/
	export PATH=${PATH}:$PREBUILT/bin/
	CROSS_COMPILE=$PREBUILT/bin/$EABIARCH-
	CFLAGS=$OPTIMIZE_CFLAGS
#CFLAGS=" -I$ARM_INC -fpic -DANDROID -fpic -mthumb-interwork -ffunction-sections -funwind-tables -fstack-protector -fno-short-enums -D__ARM_ARCH_5__ -D__ARM_ARCH_5T__ -D__ARM_ARCH_5E__ -D__ARM_ARCH_5TE__  -Wno-psabi -march=armv5te -mtune=xscale -msoft-float -mthumb -Os -fomit-frame-pointer -fno-strict-aliasing -finline-limit=64 -DANDROID  -Wa,--noexecstack -MMD -MP "
	export CPPFLAGS="$CFLAGS"
	export CFLAGS="$CFLAGS"
	export CXXFLAGS="$CFLAGS"
	export CXX="${CROSS_COMPILE}g++ --sysroot=$PLATFORM"
	export CC="${CROSS_COMPILE}gcc --sysroot=$PLATFORM"
	export NM="${CROSS_COMPILE}nm"
	export STRIP="${CROSS_COMPILE}strip"
	export RANLIB="${CROSS_COMPILE}ranlib"
	export AR="${CROSS_COMPILE}ar"
	export LDFLAGS="-Wl,-rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib -nostdlib -lc -lm -ldl -llog"

	cd vo-aacenc
	export PKG_CONFIG_LIBDIR=$(pwd)/$PREFIX/lib/pkgconfig/
	export PKG_CONFIG_PATH=$(pwd)/$PREFIX/lib/pkgconfig/
	./configure \
	    --prefix=$(pwd)/$PREFIX \
	    --host=$ARCH-linux \
	    --disable-dependency-tracking \
	    --disable-shared \
	    --disable-static \
            --disable-gpl \
            --disable-version3 \
	    --with-pic \
	    $ADDITIONAL_CONFIGURE_FLAG \
	    || exit 1

	make clean || exit 1
	make -j4 install || exit 1
	cd ..
}

function build_aac_v8
{
	PLATFORM=$NDK/platforms/$PLATFORM_VERSION/arch-$ARCH/
	export PATH=${PATH}:$PREBUILT/bin/
	CROSS_COMPILE=$PREBUILT/bin/$EABIARCH-
	CFLAGS=$OPTIMIZE_CFLAGS
#CFLAGS=" -I$ARM_INC -fpic -DANDROID -fpic -mthumb-interwork -ffunction-sections -funwind-tables -fstack-protector -fno-short-enums -D__ARM_ARCH_5__ -D__ARM_ARCH_5T__ -D__ARM_ARCH_5E__ -D__ARM_ARCH_5TE__  -Wno-psabi -march=armv5te -mtune=xscale -msoft-float -mthumb -Os -fomit-frame-pointer -fno-strict-aliasing -finline-limit=64 -DANDROID  -Wa,--noexecstack -MMD -MP "
	export CPPFLAGS="$CFLAGS"
	export CFLAGS="$CFLAGS"
	export CXXFLAGS="$CFLAGS"
	export CXX="${CROSS_COMPILE}g++ --sysroot=$PLATFORM"
	export CC="${CROSS_COMPILE}gcc --sysroot=$PLATFORM"
	export NM="${CROSS_COMPILE}nm"
	export STRIP="${CROSS_COMPILE}strip"
	export RANLIB="${CROSS_COMPILE}ranlib"
	export AR="${CROSS_COMPILE}ar"
	export LDFLAGS="-Wl,-rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib -nostdlib -lc -lm -ldl -llog"

	cd vo-aacenc
	export PKG_CONFIG_LIBDIR=$(pwd)/$PREFIX/lib/pkgconfig/
	export PKG_CONFIG_PATH=$(pwd)/$PREFIX/lib/pkgconfig/
	./configure \
	    --prefix=$(pwd)/$PREFIX \
	    --host=$ABI-linux \
	    --disable-dependency-tracking \
	    --disable-shared \
	    --disable-version3 \
            --disable-gpl \
	    --disable-static \
	    --with-pic \
	    $ADDITIONAL_CONFIGURE_FLAG \
	    || exit 1

	make clean || exit 1
	make -j4 install || exit 1
	cd ..
}
function build_freetype2
{
	PLATFORM=$NDK/platforms/$PLATFORM_VERSION/arch-$ARCH/
	export PATH=${PATH}:$PREBUILT/bin/
	CROSS_COMPILE=$PREBUILT/bin/$EABIARCH-
	CFLAGS=$OPTIMIZE_CFLAGS
#CFLAGS=" -I$ARM_INC -fpic -DANDROID -fpic -mthumb-interwork -ffunction-sections -funwind-tables -fstack-protector -fno-short-enums -D__ARM_ARCH_5__ -D__ARM_ARCH_5T__ -D__ARM_ARCH_5E__ -D__ARM_ARCH_5TE__  -Wno-psabi -march=armv5te -mtune=xscale -msoft-float -mthumb -Os -fomit-frame-pointer -fno-strict-aliasing -finline-limit=64 -DANDROID  -Wa,--noexecstack -MMD -MP "
	export CPPFLAGS="$CFLAGS"
	export CFLAGS="$CFLAGS"
	export CXXFLAGS="$CFLAGS"
	export CXX="${CROSS_COMPILE}g++ --sysroot=$PLATFORM"
	export CC="${CROSS_COMPILE}gcc --sysroot=$PLATFORM"
	export NM="${CROSS_COMPILE}nm"
	export STRIP="${CROSS_COMPILE}strip"
	export RANLIB="${CROSS_COMPILE}ranlib"
	export AR="${CROSS_COMPILE}ar"
	export LDFLAGS="-Wl,-rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib  -nostdlib -lc -lm -ldl -llog"

	cd freetype2
	export PKG_CONFIG_LIBDIR=$(pwd)/$PREFIX/lib/pkgconfig/
	export PKG_CONFIG_PATH=$(pwd)/$PREFIX/lib/pkgconfig/
	./configure \
	    --prefix=$(pwd)/$PREFIX \
	    --host=$ARCH-linux \
	    --disable-dependency-tracking \
	    --disable-shared \
            --disable-gpl \
	    --disable-static \
	    --with-pic \
	    $ADDITIONAL_CONFIGURE_FLAG \
	    || exit 1

	make clean || exit 1
	make -j4 install || exit 1
	cd ..
}

function build_freetype2_v8
{
	PLATFORM=$NDK/platforms/$PLATFORM_VERSION/arch-$ARCH/
	export PATH=${PATH}:$PREBUILT/bin/
	CROSS_COMPILE=$PREBUILT/bin/$EABIARCH-
	CFLAGS=$OPTIMIZE_CFLAGS
#CFLAGS=" -I$ARM_INC -fpic -DANDROID -fpic -mthumb-interwork -ffunction-sections -funwind-tables -fstack-protector -fno-short-enums -D__ARM_ARCH_5__ -D__ARM_ARCH_5T__ -D__ARM_ARCH_5E__ -D__ARM_ARCH_5TE__  -Wno-psabi -march=armv5te -mtune=xscale -msoft-float -mthumb -Os -fomit-frame-pointer -fno-strict-aliasing -finline-limit=64 -DANDROID  -Wa,--noexecstack -MMD -MP "
	export CPPFLAGS="$CFLAGS"
	export CFLAGS="$CFLAGS"
	export CXXFLAGS="$CFLAGS"
	export CXX="${CROSS_COMPILE}g++ --sysroot=$PLATFORM"
	export CC="${CROSS_COMPILE}gcc --sysroot=$PLATFORM"
	export NM="${CROSS_COMPILE}nm"
	export STRIP="${CROSS_COMPILE}strip"
	export RANLIB="${CROSS_COMPILE}ranlib"
	export AR="${CROSS_COMPILE}ar"
	export LDFLAGS="-Wl,-rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib  -nostdlib -lc -lm -ldl -llog"

	cd freetype2
	export PKG_CONFIG_LIBDIR=$(pwd)/$PREFIX/lib/pkgconfig/
	export PKG_CONFIG_PATH=$(pwd)/$PREFIX/lib/pkgconfig/
	./configure \
	    --prefix=$(pwd)/$PREFIX \
	    --host=$ABI-linux \
	    --disable-dependency-tracking \
	    --disable-shared \
            --disable-gpl \
	    --disable-static \
	    --with-pic \
	    $ADDITIONAL_CONFIGURE_FLAG \
	    || exit 1

	make clean || exit 1
	make -j4 install || exit 1
	cd ..
}
function build_ass
{
	PLATFORM=$NDK/platforms/$PLATFORM_VERSION/arch-$ARCH/
	export PATH=${PATH}:$PREBUILT/bin/
	CROSS_COMPILE=$PREBUILT/bin/$EABIARCH-
	CFLAGS="$OPTIMIZE_CFLAGS"
#CFLAGS=" -I$ARM_INC -fpic -DANDROID -fpic -mthumb-interwork -ffunction-sections -funwind-tables -fstack-protector -fno-short-enums -D__ARM_ARCH_5__ -D__ARM_ARCH_5T__ -D__ARM_ARCH_5E__ -D__ARM_ARCH_5TE__  -Wno-psabi -march=armv5te -mtune=xscale -msoft-float -mthumb -Os -fomit-frame-pointer -fno-strict-aliasing -finline-limit=64 -DANDROID  -Wa,--noexecstack -MMD -MP "
	export CPPFLAGS="$CFLAGS"
	export CFLAGS="$CFLAGS"
	export CXXFLAGS="$CFLAGS"
	export CXX="${CROSS_COMPILE}g++ --sysroot=$PLATFORM"
	export CC="${CROSS_COMPILE}gcc --sysroot=$PLATFORM"
	export NM="${CROSS_COMPILE}nm"
	export STRIP="${CROSS_COMPILE}strip"
	export RANLIB="${CROSS_COMPILE}ranlib"
	export AR="${CROSS_COMPILE}ar"
	export LDFLAGS="-Wl,-rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib  -nostdlib -lc -lm -ldl -llog"

	cd libass
	export PKG_CONFIG_LIBDIR=$(pwd)/$PREFIX/lib/pkgconfig/
	export PKG_CONFIG_PATH=$(pwd)/$PREFIX/lib/pkgconfig/
	./configure \
	    --prefix=$(pwd)/$PREFIX \
	    --host=$ARCH-linux \
	    --disable-fontconfig \
	    --disable-dependency-tracking \
	    --disable-require-system-font-provider \
	    --enable-shared \
            --disable-gpl \
	    --disable-static \
	    --disable-thread \
	    --with-pic \
	    $ADDITIONAL_CONFIGURE_FLAG \
	    || exit 1

	make clean || exit 1
	make V=1 -j4 install || exit 1
	cd ..
}

function build_ass_v8
{
	PLATFORM=$NDK/platforms/$PLATFORM_VERSION/arch-$ARCH/
	export PATH=${PATH}:$PREBUILT/bin/
	CROSS_COMPILE=$PREBUILT/bin/$EABIARCH-
	CFLAGS="$OPTIMIZE_CFLAGS"
#CFLAGS=" -I$ARM_INC -fpic -DANDROID -fpic -mthumb-interwork -ffunction-sections -funwind-tables -fstack-protector -fno-short-enums -D__ARM_ARCH_5__ -D__ARM_ARCH_5T__ -D__ARM_ARCH_5E__ -D__ARM_ARCH_5TE__  -Wno-psabi -march=armv5te -mtune=xscale -msoft-float -mthumb -Os -fomit-frame-pointer -fno-strict-aliasing -finline-limit=64 -DANDROID  -Wa,--noexecstack -MMD -MP "
	export CPPFLAGS="$CFLAGS"
	export CFLAGS="$CFLAGS"
	export CXXFLAGS="$CFLAGS"
	export CXX="${CROSS_COMPILE}g++ --sysroot=$PLATFORM"
	export CC="${CROSS_COMPILE}gcc --sysroot=$PLATFORM"
	export NM="${CROSS_COMPILE}nm"
	export STRIP="${CROSS_COMPILE}strip"
	export RANLIB="${CROSS_COMPILE}ranlib"
	export AR="${CROSS_COMPILE}ar"
	export LDFLAGS="-Wl,-rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib  -nostdlib -lc -lm -ldl -llog"

	cd libass
	export PKG_CONFIG_LIBDIR=$(pwd)/$PREFIX/lib/pkgconfig/
	export PKG_CONFIG_PATH=$(pwd)/$PREFIX/lib/pkgconfig/
	./configure \
	    --prefix=$(pwd)/$PREFIX \
	    --host=$ABI-linux \
	    --disable-fontconfig \
	    --disable-dependency-tracking \
	    --disable-require-system-font-provider \
	    --disable-shared \
            --disable-gpl \
	    --disable-static \
	    --disable-thread \
	    --with-pic \
	    $ADDITIONAL_CONFIGURE_FLAG \
	    || exit 1

	make clean || exit 1
	make V=1 -j4 install || exit 1
	cd ..
}
function build_fribidi
{
	PLATFORM=$NDK/platforms/$PLATFORM_VERSION/arch-$ARCH/
	export PATH=${PATH}:$PREBUILT/bin/
	CROSS_COMPILE=$PREBUILT/bin/$EABIARCH-
	CFLAGS="$OPTIMIZE_CFLAGS -std=gnu99"
 
	export CPPFLAGS="$CFLAGS"
	export CFLAGS="$CFLAGS"
	export CXXFLAGS="$CFLAGS"
	export CXX="${CROSS_COMPILE}g++ --sysroot=$PLATFORM"
	export CC="${CROSS_COMPILE}gcc --sysroot=$PLATFORM"
	export NM="${CROSS_COMPILE}nm"
	export STRIP="${CROSS_COMPILE}strip"
	export RANLIB="${CROSS_COMPILE}ranlib"
	export AR="${CROSS_COMPILE}ar"
	export LDFLAGS="-Wl,-rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib -nostdlib -lc -lm -ldl -llog"

	cd fribidi
	./configure \
	    --prefix=$(pwd)/$PREFIX \
	    --host=$ARCH-linux \
	    --disable-bin \
            --disable-gpl \
	    --disable-dependency-tracking \
	    --disable-shared \
	    --disable-static \
	    --with-pic \
	    $ADDITIONAL_CONFIGURE_FLAG \
	    || exit 1

	make clean || exit 1
	make -j4 install || exit 1
	cd ..
}
function build_fribidi_v8
{
	PLATFORM=$NDK/platforms/$PLATFORM_VERSION/arch-$ARCH/
	export PATH=${PATH}:$PREBUILT/bin/
	CROSS_COMPILE=$PREBUILT/bin/$EABIARCH-
	CFLAGS="$OPTIMIZE_CFLAGS -std=gnu99"
 
	export CPPFLAGS="$CFLAGS"
	export CFLAGS="$CFLAGS"
	export CXXFLAGS="$CFLAGS"
	export CXX="${CROSS_COMPILE}g++ --sysroot=$PLATFORM"
	export CC="${CROSS_COMPILE}gcc --sysroot=$PLATFORM"
	export NM="${CROSS_COMPILE}nm"
	export STRIP="${CROSS_COMPILE}strip"
	export RANLIB="${CROSS_COMPILE}ranlib"
	export AR="${CROSS_COMPILE}ar"
	export LDFLAGS="-Wl,-rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib -nostdlib -lc -lm -ldl -llog"

	cd fribidi
	./configure \
	    --prefix=$(pwd)/$PREFIX \
	    --host=$ABI-linux \
	    --disable-bin \
	    --disable-dependency-tracking \
	    --disable-shared \
            --disable-gpl \
	    --disable-static \
	    --with-pic \
	    $ADDITIONAL_CONFIGURE_FLAG \
	    || exit 1

	make clean || exit 1
	make -j4 install || exit 1
	cd ..
}
function build_ffmpeg
{
	PLATFORM=$NDK/platforms/$PLATFORM_VERSION/arch-$ARCH/
	CC=$PREBUILT/bin/$EABIARCH-gcc
	CROSS_PREFIX=$PREBUILT/bin/$EABIARCH-
	PKG_CONFIG=${CROSS_PREFIX}pkg-config
	if [ ! -f $PKG_CONFIG ];
	then
		cat > $PKG_CONFIG << EOF
#!/bin/bash
pkg-config \$*
EOF
		chmod u+x $PKG_CONFIG
	fi
	NM=$PREBUILT/bin/$EABIARCH-nm
	cd ffmpeg-2.5.3
	export PKG_CONFIG_LIBDIR=$(pwd)/$PREFIX/lib/pkgconfig/
	export PKG_CONFIG_PATH=$(pwd)/$PREFIX/lib/pkgconfig/
	./configure --target-os=linux \
	    --prefix=$PREFIX \
	    --enable-cross-compile \
	    --extra-libs="-lgcc" \
	    --arch=$ARCH \
	    --cc=$CC \
	    --cross-prefix=$CROSS_PREFIX \
	    --nm=$NM \
	    --sysroot=$PLATFORM \
	    --extra-cflags=" -O3 -fpic -DANDROID -DHAVE_SYS_UIO_H=1 -Dipv6mr_interface=ipv6mr_ifindex -fasm -Wno-psabi -fno-short-enums  -fno-strict-aliasing -finline-limit=300 $OPTIMIZE_CFLAGS " \
	    --disable-shared \
	    --enable-static \
	    --enable-runtime-cpudetect \
	    --extra-ldflags="-Wl,-rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib  -nostdlib -lc -lm -ldl -llog -L$PREFIX/lib -L$PREFIX/lib/pkgconfig" \
	    --extra-cflags="-I$PREFIX/include" \
	    --disable-programs \
	    --enable-debug=3 \
	    --disable-libass \
	    --enable-libvo-aacenc \
	    --disable-libvo-amrwbenc \
		--disable-hwaccels \
	    --disable-demuxers \
			--enable-demuxer=mp4 --enable-demuxer=mov  --enable-demuxer=h264 --enable-demuxer=aac  \
		--disable-muxers \
			--enable-muxer=mp4 --enable-muxer=aac --enable-muxer=h264 --enable-muxer=mov   --enable-muxer=flv\
	    --enable-protocols \
		--disable-decoders \
			--enable-decoder=h264 --enable-decoder=aac \
		--disable-encoders \
			--enable-encoder=aac\
	    --disable-parsers \
			--enable-parser=h264 --enable-parser=aac \
	    --enable-bsfs \
	    --enable-avformat \
	    --enable-avcodec \
	    --enable-avresample \
		--enable-avfilter \
	    --disable-zlib \
	    --disable-doc \
	    --disable-ffplay \
	    --disable-ffmpeg \
	    --disable-ffplay \
	    --disable-ffprobe \
	    --disable-ffserver \
	    --enable-avdevice \
	    --disable-version3 \
	    --enable-memalign-hack \
	    --disable-asm \
	    --enable-pic \
	    --enable-vda \
	    --enable-vdpau \
	    --enable-pthreads \
            --disable-gpl \
            --disable-nonfree \
	    $ADDITIONAL_CONFIGURE_FLAG \
	    || exit 1
	make clean || exit 1
	make -j4 install || exit 1

	cd ..
}
function build_ffmpeg_v8
{
	PLATFORM=$NDK/platforms/$PLATFORM_VERSION/arch-$ARCH/
	CC=$PREBUILT/bin/$EABIARCH-gcc
	CROSS_PREFIX=$PREBUILT/bin/$EABIARCH-
	PKG_CONFIG=${CROSS_PREFIX}pkg-config
	if [ ! -f $PKG_CONFIG ];
	then
		cat > $PKG_CONFIG << EOF
#!/bin/bash
pkg-config \$*
EOF
		chmod u+x $PKG_CONFIG
	fi
	NM=$PREBUILT/bin/$EABIARCH-nm
	cd ffmpeg-2.5.3
	export PKG_CONFIG_LIBDIR=$(pwd)/$PREFIX/lib/pkgconfig/
	export PKG_CONFIG_PATH=$(pwd)/$PREFIX/lib/pkgconfig/
	./configure --target-os=linux \
	    --prefix=$PREFIX \
	    --enable-cross-compile \
	    --extra-libs="-lgcc" \
	    --arch=$ARCH \
	    --cc=$CC \
	    --cross-prefix=$CROSS_PREFIX \
	    --nm=$NM \
	    --sysroot=$PLATFORM \
	    --extra-cflags=" -O3 -fpic -DANDROID -DHAVE_SYS_UIO_H=1 -Dipv6mr_interface=ipv6mr_ifindex -fasm -Wno-psabi -fno-short-enums  -fno-strict-aliasing -finline-limit=300 $OPTIMIZE_CFLAGS " \
	    --disable-shared \
	    --disable-static \
	    --enable-runtime-cpudetect \
	    --extra-ldflags="-Wl,-rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib  -nostdlib -lc -lm -ldl -llog -L$PREFIX/lib -L$PREFIX/lib/pkgconfig" \
	    --extra-cflags="-I$PREFIX/include" \
	    --disable-programs \
	    --enable-debug=3 \
	    --disable-libass \
	    --enable-libvo-aacenc \
	    --disable-libvo-amrwbenc \
		--disable-hwaccels \
	    --disable-demuxers \
			--enable-demuxer=mp4 --enable-demuxer=mov  --enable-demuxer=h264 --enable-demuxer=aac  \
		--disable-muxers \
			--enable-muxer=mp4 --enable-muxer=aac --enable-muxer=h264 --enable-muxer=mov   --enable-muxer=flv\
	    --enable-protocols \
		--disable-decoders \
			--enable-decoder=h264 --enable-decoder=aac \
		--disable-encoders \
			--enable-encoder=libx264 --enable-encoder=aac\
	    --disable-parsers \
			--enable-parser=h264 --enable-parser=aac \
	    --enable-bsfs \
	    --enable-avformat \
	    --enable-avcodec \
	    --enable-avresample \
		--enable-avfilter \
	    --disable-zlib \
	    --disable-doc \
	    --disable-ffplay \
	    --disable-ffmpeg \
	    --disable-ffplay \
	    --disable-ffprobe \
	    --disable-ffserver \
	    --enable-avdevice \
	    --disable-version3 \
	    --enable-memalign-hack \
	    --enable-asm \
	    --enable-pic \
	    --enable-vda \
	    --enable-vdpau \
	    --enable-pthreads \
	    --disable-libx264 \
            --disable-gpl \
            --disable-postproc \
            --disable-nonfree \
	    $ADDITIONAL_CONFIGURE_FLAG \
	    || exit 1
	make clean || exit 1
	make -j4 install || exit 1

	cd ..
}
function build_one {
	cd ffmpeg-2.5.3
	PLATFORM=$NDK/platforms/$PLATFORM_VERSION/arch-$ARCH/

	$PREBUILT/bin/$EABIARCH-ld -rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib -L$PREFIX/lib  -soname $SONAME -shared -nostdlib  -z -Bsymbolic --whole-archive --no-undefined -o $OUT_LIBRARY -lavcodec -lavformat -lavresample -lavutil -lswresample -lass -lfreetype -lfribidi -lswscale -lvo-aacenc -lvo-amrwbenc -lc -lm -lz -ldl -llog  --dynamic-linker=/system/bin/linker -zmuldefs $PREBUILT/lib/gcc/$EABIARCH/4.9.x/libgcc.a || exit 1
	cd ..
}


function build_armv7 {
	##arm v7 + neon (neon also include vfpv3-32)
	EABIARCH=arm-linux-androideabi
	ARCH=arm
	CPU=armv7-a
	OPTIMIZE_CFLAGS="-mfloat-abi=softfp -DHAVE_NEON=1 -mfpu=neon -marm -march=$CPU -mtune=cortex-a8 -mthumb -D__thumb__ #-D__ARM_ARCH_7__ -D__ARM_ARCH_7A__"
	PREFIX=../ffmpeg-build/armeabi-v7a-neon
	PREFIX2=../../ffmpeg-build/armeabi-v7a-neon
	OUT_LIBRARY=../../ffmpeg-build/armeabi-v7a/libffmpeg-neon.so
	ADDITIONAL_CONFIGURE_FLAG=--enable-neon
	SONAME=libffmpeg-neon.so
	TOOLCHAINS_VERSION=4.9
	PREBUILT=$NDK/toolchains/arm-linux-androideabi-$TOOLCHAINS_VERSION/prebuilt/$OS-x86_64
	PLATFORM_VERSION=android-21
	build_amr
	build_aac
	build_fribidi
	build_freetype2
	build_ass
	#build_x264
	build_ffmpeg
	build_one
}
function build_arm_v7vfpv3 {
	##arm v7vfpv3
	EABIARCH=arm-linux-androideabi
	ARCH=arm
	CPU=armv7-a
	OPTIMIZE_CFLAGS="-mfloat-abi=softfp -mfpu=vfpv3-d16 -marm -march=$CPU -mtune=cortex-a8 -mthumb -D__thumb__ -D__ARM_ARCH_7__ -D__ARM_ARCH_7A__"
	PREFIX=../build_results/armeabi-v7a
	OUT_LIBRARY=$PREFIX/libffmpeg.so
	ADDITIONAL_CONFIGURE_FLAG=
	SONAME=libffmpeg.so
	TOOLCHAINS_VERSION=4.9
	PREBUILT=$NDK/toolchains/arm-linux-androideabi-$TOOLCHAINS_VERSION/prebuilt/$OS-x86_64
	PLATFORM_VERSION=android-21
	
	#vo-amrwbenc
	build_amr
	
	#vo-aacenc
	build_aac
	
	#fribidi
	build_fribidi
	
	#freetype2	
	build_freetype2
	
	#libass
	build_ass
	
	#x264-20151207
	#build_x264
	
	#ffmpeg-2.5.3
	build_ffmpeg
	
	#ffmpeg-2.5.3
	build_one
}

function build_x86 {
	##x86
	EABIARCH=i686-linux-android
	ARCH=x86
	OPTIMIZE_CFLAGS="-m32"
	PREFIX=../ffmpeg-build/x86
	OUT_LIBRARY=$PREFIX/libffmpeg.so
	ADDITIONAL_CONFIGURE_FLAG=--disable-asm
	SONAME=libffmpeg.so
	PREBUILT=$NDK/toolchains/x86-4.9/prebuilt/$OS-x86_64
	PLATFORM_VERSION=android-21
	build_amr
	build_aac
	build_fribidi
	build_freetype2
	build_ass
	#build_x264
	build_ffmpeg
	build_one

}

function build_x86_64 {
	##x86_64
	EABIARCH=x86_64-linux-android
	ARCH=x86_64
	PREFIX=../ffmpeg-build/x86_64
	OUT_LIBRARY=$PREFIX/libffmpeg.so
	SONAME=libffmpeg.so
	PREBUILT=$NDK/toolchains/x86_64-4.9/prebuilt/$OS-x86_64
	PLATFORM_VERSION=android-21
	build_amr
	build_aac
	build_fribidi
	build_freetype2
	build_ass
	#build_x264
	build_ffmpeg
	build_one

}




function build_armv5 {
	##arm v5
	EABIARCH=arm-linux-androideabi
	ARCH=arm
	CPU=armv5
	OPTIMIZE_CFLAGS="-marm -march=$CPU"
	PREFIX=../ffmpeg-build/armeabi
	OUT_LIBRARY=$PREFIX/libffmpeg.so
	ADDITIONAL_CONFIGURE_FLAG=
	SONAME=libffmpeg.so
	PREBUILT=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/$OS-x86_64
	PLATFORM_VERSION=android-21
	build_amr
	build_aac
	build_fribidi
	build_freetype2
	build_ass
	build_ffmpeg
	build_one
}

function build_armv8 {
	##arm v8 64
	EABIARCH=aarch64-linux-android
	ARCH=arm64
	ABI=aarch64
	CPU=armv8-a
	PREFIX=../build_results/armeabi-v8a
	OUT_LIBRARY=$PREFIX/libffmpeg.so
	ADDITIONAL_CONFIGURE_FLAG=
	SONAME=libffmpeg.so
	TOOLCHAINS_VERSION=4.9
	PREBUILT=$NDK/toolchains/aarch64-linux-android-$TOOLCHAINS_VERSION/prebuilt/$OS-x86_64
	PLATFORM_VERSION=android-21
	
	#vo-amrwbenc
	build_amr_v8
	
	#vo-aacenc
	build_aac_v8
	
	#fribidi
	build_fribidi_v8
	
	#freetype2	
	build_freetype2_v8
	
	#libass
	build_ass_v8
	
	#x264-20151207
	#build_x264_v8
	
	#ffmpeg-2.5.3
	build_ffmpeg
	
	#ffmpeg-2.5.3
	build_one
}

function build_all {
	build_arm_v7vfpv3
	build_x86
	build_armv8
	#build_x86_64
}

build_all
