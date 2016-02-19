SRC_DIR="../../framework/src/xcode/Pi-ios-client"
DOC_DIR="../../framework/src/xcode/build/docs"
OUTPUT_NAME="Pi-ios-client-docs"

appledoc \
--project-name "Pi-ios-client Framework" \
--project-company "Pearson" \
--company-id "com.pearsoned.gridmobile" \
--docset-atom-filename "Pi-ios-client.atom" \
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
