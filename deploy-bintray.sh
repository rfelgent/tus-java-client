#!/bin/bash

set -e

# Generate files
./gradlew jar javadocJar sourcesJar

base_url="https://acconut:$BINTRAY_TOKEN@api.bintray.com/"
version="$TRAVIS_TAG"

# Create new version
curl \
    -X POST \
    $base_url/packages/tus/maven/tus-java-client/versions \
    -H "Content-Type: application/json" \
    -d "{\"name\":\"${version}\",\"vcs_tag\":\"${version}\"}"

function upload {
    local src=$1
    local dst=$2

    curl \
        -X PUT \
        "$base_url/content/tus/maven/tus-java-client/$version/$dst?publish=1" \
        -F "file=@build/libs/$src"
}

# Upload files
upload "tus-java-client.jar" "tus-java-client-$version.jar"
upload "tus-java-client-javadoc.jar" "tus-java-client-$version-javadoc.jar"
upload "tus-java-client-sources.jar" "tus-java-client-$version-sources.jar"
