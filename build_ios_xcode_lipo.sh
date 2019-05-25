#!/bin/sh

FAT=$TARGET_TEMP_DIR/fat
echo "building fat binaries into $FAT"
mkdir -p $FAT/lib

LIBDIR="$TARGET_TEMP_DIR/static"
set - $ARCHS
cd "$LIBDIR/$1/lib"
LIBS="*.a"
for LIB in $LIBS; do
	echo lipo -create `find $LIBDIR -name $LIB` -output $FAT/lib/$LIB 1>&2
	lipo -create `find $LIBDIR -name $LIB` -output $FAT/lib/$LIB || exit 1
done

HEADER_DIR="$BUILT_PRODUCTS_DIR/$PUBLIC_HEADERS_FOLDER_PATH"
mkdir -p "$HEADER_DIR"
echo "$HEADER_DIR"
cp -rf $LIBDIR/$1/include/* "$HEADER_DIR"
