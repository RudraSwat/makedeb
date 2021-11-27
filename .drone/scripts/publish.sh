#!/usr/bin/env bash
set -e

cd src
pkgbuild_data="$(cat PKGBUILD)"

component_name="$(echo "${pkgbuild_data}" | grep 'pkgname=' | sed 's|pkgname=||')"
component_pkgver="$(echo "${pkgbuild_data}" | grep 'pkgver=' | sed 's|pkgver=||')"
component_pkgrel="$(echo "${pkgbuild_data}" | grep 'pkgrel=' | sed 's|pkgrel=||')"

# Check for build debs
deb_packages=$(find *.deb 2> /dev/null)
deb_packages_count=$(echo "${deb_packages}" | wc -w)

if [[ "${deb_packages_count}" == "0" ]]; then
    echo "ERROR: There doesn't appear to be any packages present."
    exit 1

elif [[ "${deb_packages_count}" -gt "1" ]]; then
    echo "ERROR: More than one package is present."
    exit 1
fi

# Upload packages.
echo "Uploading ${deb_packages} to ${proget_server}..."

curl "https://${proget_server}/debian-packages/upload/makedeb/main/${deb_packages}" \
     --user "api:${proget_api_key}" \
     --upload-file "${deb_packages}"
