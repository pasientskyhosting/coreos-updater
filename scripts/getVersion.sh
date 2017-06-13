#!/bin/bash

URL="http://10.100.22.22/amd64-usr/"
VERSION="$1"

if [ ! -d amd64-usr/$VERSION ]; then
    mkdir -p amd64-usr/$VERSION
fi

if [ ! -f amd64-usr/$VERSION/update.gz ]; then
    echo "Getting $VERSION from https://update.release.core-os.net"
    wget -qP amd64-usr/$VERSION https://update.release.core-os.net/amd64-usr/$VERSION/update.gz
fi

SIZE=$(stat -c %s amd64-usr/${VERSION}/update.gz)
SHA1_b64=$(echo -ne "$(echo -n $(sha1sum amd64-usr/${VERSION}/update.gz | awk '{print $1}') | sed -e 's/../\\x&/g')" | base64 )
SHA256_b64=$(echo -ne "$(echo -n $(sha256sum amd64-usr/${VERSION}/update.gz | awk '{print $1}') | sed -e 's/../\\x&/g')" | base64)

XML="<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<response protocol=\"3.0\" server=\"update.core-os.net\">
 <daystart elapsed_seconds=\"0\"></daystart>
 <app appid=\"e96281a6-d1af-4bde-9a0a-97b76e56dc57\" status=\"ok\">
  <updatecheck status=\"ok\">
   <urls>
    <url codebase=\"${URL}/${VERSION}/\"></url>
   </urls>
   <manifest version=\"${VERSION}\">
    <packages>
     <package hash=\"${SHA1_b64}\" name=\"update.gz\" size=\"${SIZE}\" required=\"false\"></package>
    </packages>
    <actions>
     <action event=\"postinstall\" ChromeOSVersion=\"\" sha256=\"${SHA256_b64}\" needsadmin=\"false\" IsDelta=\"false\" DisablePayloadBackoff=\"true\"></action>
    </actions>
   </manifest>
  </updatecheck>
 </app>
</response>"

echo "$XML" > amd64-usr/$VERSION/index.html
