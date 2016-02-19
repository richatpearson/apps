echo "Building Mobileapp1 App"

# Images
imageDir=PearsonPush/GFX/mobileapp1_icons

imageFiles[0]="icon_144.png"
imageFiles[1]="icon_iOS7.png"
imageFiles[2]="icon.png"
imageFiles[3]="icon@2x.png"
imageFiles[4]="icon_iPadNoRetina.png"

tgt_path=PearsonPush/GFX/

ls -l

#   Iterate through imageFiles array
#   and move files to the Images folder
#   in the eCollege directory
echo "Copying images"

for image in ${imageFiles[@]}
do
echo $image
cp $imageDir/$image ${tgt_path}
done

echo "Shell script complete."