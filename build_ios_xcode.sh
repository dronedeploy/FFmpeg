#!/bin/sh

# Configuration from Xcode environment:
# SOURCE_ROOT - this directory
# OBJECT_FILE_DIR_normal/arch - object files here
# TARGET_TEMP_DIR - intermediate build files (put arch-specific build stuff there)
# BUILT_PRODUCTS_DIR - put fat framework there
# ARCHS - architectures to build
# IPHONEOS_DEPLOYMENT_TARGET - deployment target version

CONFIGURE_FLAGS="--enable-cross-compile --disable-programs \
				 --disable-debug \
				 	--enable-static --disable-shared \
                 --disable-doc --disable-ffmpeg --disable-ffplay --disable-ffprobe --disable-ffserver --enable-avresample \
                 --disable-armv6 --disable-armv6t2 \
                 --disable-iconv --disable-bzlib \
                 	--enable-version3 \
                 	--enable-pthreads --disable-small \
                 	--enable-vda --enable-vdpau --enable-asm \
                 	--enable-pic --enable-hwaccels \
                 	--enable-hwaccel=h264_vda --enable-hwaccel=h264_vdpau --enable-memalign-hack \
                 --disable-decoders \
                 	--enable-decoder=h264 --enable-decoder=aac\
                 --disable-encoders \
                 	--enable-encoder=aac \
                 --disable-parsers \
                 	--enable-parser=h264 --enable-parser=aac\
                 --disable-filters \
                 --disable-demuxers \
                 	--enable-demuxer=h264 --enable-demuxer=mov --enable-demuxer=aac\
                 --disable-muxers \
                 	--enable-muxer=flv --enable-muxer=mp4 --enable-muxer=mov --enable-muxer=h264"

for ARCH in $ARCHS; do
    OBJECT_DIR="$OBJECT_FILE_DIR_normal/$ARCH"
    INSTALL_DIR="$TARGET_TEMP_DIR/$ARCH"

	mkdir -p "$OBJECT_DIR"
	cd "$OBJECT_DIR"
    CDIR=$(pwd)
	echo "building $ARCH... in $CDIR"

	CFLAGS="-arch $ARCH"
	if [ "$ARCH" = "i386" -o "$ARCH" = "x86_64" ]; then
	    PLATFORM="iPhoneSimulator"
	    CFLAGS="$CFLAGS -mios-simulator-version-min=$IPHONEOS_DEPLOYMENT_TARGET"
	else
	    PLATFORM="iPhoneOS"
	    CFLAGS="$CFLAGS -mios-version-min=$IPHONEOS_DEPLOYMENT_TARGET -mfpu=neon -fembed-bitcode-marker"
	    if [ "$ARCH" = "arm64" ]; then
	        EXPORT="GASPP_FIX_XCODE5=1"
	    fi
	fi

	XCRUN_SDK=`echo $PLATFORM | tr '[:upper:]' '[:lower:]'`
	CC="xcrun -sdk $XCRUN_SDK clang"
	CXXFLAGS="$CFLAGS"
	LDFLAGS="$CFLAGS"

	TMPDIR=${TMPDIR/%\/} $SOURCE_ROOT/configure \
	    --target-os=darwin \
	    --arch=$ARCH \
	    --cc="$CC" \
	    $CONFIGURE_FLAGS \
	    --extra-cflags="$CFLAGS" \
	    --extra-cxxflags="$CXXFLAGS" \
	    --extra-ldflags="$LDFLAGS" \
	    --prefix="$TARGET_TEMP_DIR/static/$ARCH" \
	|| exit 1

	make -j8 install $EXPORT || exit 1
done

#
# Create fat libraries from each arch
#

#FAT=$BUILD_DIR/fat
#echo "building fat binaries into $FAT"
#mkdir -p $FAT/lib
#
#LIBDIR="$BUILD_DIR/install"
#set - $ARCHS
#cd "$LIBDIR/$1/lib"
#LIBS="*.a"
#for LIB in $LIBS; do
#	echo lipo -create `find $LIBDIR -name $LIB` -output $FAT/lib/$LIB 1>&2
#	lipo -create `find $LIBDIR -name $LIB` -output $FAT/lib/$LIB || exit 1
#done
#
##
## Create framework binary
##
#
#PRODUCT_NAME=ffmpeg
#FRAMEWORK="$BUILD_DIR/$PRODUCT_NAME.framework"
#
#mkdir -p "$FRAMEWORK"
#
#HEADER_DIR="$BUILT_PRODUCTS_DIR/$PUBLIC_HEADERS_FOLDER_PATH"
#mkdir -p "$HEADER_DIR"
#echo "$HEADER_DIR"
#cp -rf $LIBDIR/$1/include/* "$HEADER_DIR"
