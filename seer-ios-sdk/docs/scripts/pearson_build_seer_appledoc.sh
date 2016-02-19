SRC_DIR="../../framework/src/xcode/Seer-ios-client"
DOC_DIR="build/docs"
OUTPUT_NAME="Seer-ios-client-docs"

appledoc \
--project-name "PearsonSeerClient Framework" \
--project-company "Pearson" \
--company-id "com.pearsoned.gridmobile" \
--docset-atom-filename "PearsonSeerClient.atom" \
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
--verbose 3 \
"${SRC_DIR}"

# ZIP the docs
pushd "${DOC_DIR}"
zip -r "${OUTPUT_NAME}" "${OUTPUT_NAME}"
popd