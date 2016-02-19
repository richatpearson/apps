SRC_DIR="../../framework/src/xcode/classroom-ios"
DOC_DIR="../../framework/src/xcode/build/docs"
OUTPUT_NAME="classroom-ios-library-docs"

appledoc \
--project-name "classroom-ios-library Framework" \
--project-company "Pearson" \
--company-id "com.pearsoned.gridmobile" \
--docset-atom-filename "classroom-ios-library.atom" \
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
--verbose 0 \
"${SRC_DIR}"

# ZIP the docs
pushd "${DOC_DIR}"
zip -r "${OUTPUT_NAME}" "${OUTPUT_NAME}"
popd
