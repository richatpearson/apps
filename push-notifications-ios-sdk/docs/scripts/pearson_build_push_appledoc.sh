# To be run from maven pom

#SRC_DIR="../framework/src/xcode/PushNotifications"
#DOC_DIR="build/docs"
OUTPUT_NAME="pushnotifications-docs"

# To run from scripts folder, comment out above SRC_DIR and DOC_DIR and uncomment these
SRC_DIR="../../framework/src/xcode/PushNotifications"
DOC_DIR="../../framework/src/xcode/build/docs" 

appledoc \
--project-name "PearsonPushNotifications Framework" \
--project-company "Pearson" \
--company-id "com.pearsoned.gridmobile" \
--docset-atom-filename "PushNotifications.atom" \
--output "${DOC_DIR}/${OUTPUT_NAME}" \
--create-html \
--logformat xcode \
--keep-undocumented-objects \
--keep-undocumented-members \
--keep-intermediate-files \
--no-repeat-first-par \
--no-warn-invalid-crossref \
--finalize-docset \
--ignore "*.m" \
--ignore "*Operation.h" \
--verbose 3 \
"${SRC_DIR}"

# ZIP the docs
pushd "${DOC_DIR}"
zip -r "${OUTPUT_NAME}" "${OUTPUT_NAME}"
popd
