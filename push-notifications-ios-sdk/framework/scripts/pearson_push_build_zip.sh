#!/bin/sh

echo "RELEASE: Building Release..."

# SDK version and artifactId
SDK_VERSION="$1"
SDK_ARTIFACT_ID="$2"

echo "SDK Version: $SDK_VERSION"
echo "SDK Artifact: $SDK_ARTIFACT_ID"

# Paths and filenames
FRAMEWORK_FILE_NAME="PushNotifications.framework"
ZIP_FILE_NAME_1="${SDK_ARTIFACT_ID}-${SDK_VERSION}.xcode-framework-zip"
ZIP_FILE_NAME_2="${SDK_ARTIFACT_ID}-${SDK_VERSION}.zip"
TOPLEVEL_ZIP_DIR="src/xcode/build/framework/zip"
DEST_ZIP_DIR="${TOPLEVEL_ZIP_DIR}/${SDK_ARTIFACT_ID}-${SDK_VERSION}"
BUILT_FRAMEWORK="src/xcode/build/framework/${FRAMEWORK_FILE_NAME}"
ZIP_LIB_DIR="${DEST_ZIP_DIR}"

# framework exists?
if [ ! -d "${BUILT_FRAMEWORK}" ] ; then
	echo "Error: unable to find framework '${BUILT_FRAMEWORK}'"
	exit 1
fi

# zip directory exists?
if [ -d "${DEST_ZIP_DIR}" ]; then
	# get rid of everything in it
	find "${DEST_ZIP_DIR}" -type f -exec rm {} \;
else
	mkdir -p "${DEST_ZIP_DIR}"
fi

# create directory for zipped framework
mkdir -p "${ZIP_LIB_DIR}"

# copy framework to destination directory
cp -R "${BUILT_FRAMEWORK}" "${ZIP_LIB_DIR}"

# create the zip file
cd ${TOPLEVEL_ZIP_DIR} && zip -r -y ${ZIP_FILE_NAME_1} .

zip -r -y ${ZIP_FILE_NAME_2} .

