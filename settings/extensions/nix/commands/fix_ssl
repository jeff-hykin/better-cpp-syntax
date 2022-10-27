#!/usr/bin/env bash

# how to create up-to-date cert on MacOS
# if [ "$(uname)" = "Darwin" ] 
# then
#     # check if file exists
#     if ! [ -f "/etc/ssl/certs/ca-certificates.crt" ]
#     then
#         #
#         # create an up-to-date cert with keychain
#         #
#         sudo mkdir -p /etc/ssl/certs/
#         sudo rm -f /etc/ssl/certs/ca-certificates.crt
#         sudo security export -t certs -f pemseq -k /System/Library/Keychains/SystemRootCertificates.keychain -o /etc/ssl/certs/ca-certificates.crt
#         # force/ensure correct permissions on folders/files
#         sudo chown root /etc /etc/ssl /etc/ssl/certs/ /etc/ssl/certs/ca-certificates.crt
#         sudo chmod u=rwx,g=rx,o=rx /etc
#         sudo chmod u=rwx,g=rx,o=rx /etc/ssl
#         sudo chmod u=rwx,g=rx,o=rx /etc/ssl/certs/
#         sudo chmod u=rw,g=r,o=r  /etc/ssl/certs/ca-certificates.crt
#     fi
# fi

# if file exists, use it
__temp_var__certs_file="$FORNIX_FOLDER/settings/extensions/nix/cacert.pem"
if [ -f "$__temp_var__certs_file" ]
then
    export SSL_CERT_FILE="$__temp_var__certs_file"
    export NIX_SSL_CERT_FILE="$SSL_CERT_FILE"
    # for some reason git needs its own var 
    export GIT_SSL_CAINFO="$SSL_CERT_FILE"
    export CURL_CA_BUNDLE="$SSL_CERT_FILE"
    
    wgetrc_path="$FORNIX_HOME/.wgetrc"
    # ensure file exists
    if ! [ -f "$wgetrc_path" ]
    then
        rm -rf "$wgetrc_path" 2>/dev/null
        touch "$wgetrc_path"
    fi
    # check if already included
    if ! { cat "$wgetrc_path" | grep -F "$SSL_CERT_FILE" 1>/dev/null 2>/dev/null }
    then
        # TODO: this probably wont work with spaces in the path (breaks if any parent folder of the project has space in the name)
        echo "
ca_certificate = $SSL_CERT_FILE" >> "$wgetrc_path"
    fi
fi
unset __temp_var__certs_file


#
# link cert into nix
#
nix_certificates_file="/nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt" # not sure if different for single-user install
# check if file exists
if ! [ -f "$nix_certificates_file" ]
then
    echo "Creating nix certificate file: $nix_certificates_file"
    sudo mkdir -p "$(dirname "$nix_certificates_file")"
    # link into nix profile
    sudo ln -s "$NIX_SSL_CERT_FILE" "$nix_certificates_file"
fi