#!/bin/bash

Pdf_Name="internship_report.pdf"
Page_Num=0
Width=90

mkdir doc_images > /dev/null 2>&1

if [[ ! -f "${Pdf_Name}" ]]; then
    echo "Pdf file doesn't exists: ${Pdf_Name}"
    echo "Exiting"
    exit 1
fi

Page_Num=$(pdfinfo "${Pdf_Name}" | grep "Pages:" | awk '{print $2}')

echo "Generating svgs for README.md"
for i in $(seq 1 $Page_Num)
do
    pdf2svg "$Pdf_Name" "doc_images/${i}.svg" ${i}
    sed -i "2a<rect width=\"100%\" height=\"100%\" fill=\"white\" />" "doc_images/${i}.svg"
done

gen_img_insertion() {

    local img="$1"

    echo "<p align = \"center\" >"
    echo "    <img src=\"./doc_images/${img}.svg\" width=\"${Width}%\">"
    echo "</p>"
}

echo "Generating README.md"

echo "Generated on: $(date)" > README.md
echo "" >> README.md

echo "Please find the actual pdf version of the document at the root of this" >> README.md
echo "repo named \`internship_report.pdf\`." >> README.md
echo "" >> README.md

for i in $(seq 1 $((Page_Num - 1)))
do
    gen_img_insertion "$i" >> README.md
    echo "" >> README.md
done
gen_img_insertion "$Page_Num" >> README.md
