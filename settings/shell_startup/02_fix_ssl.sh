export SSL_CERT_FILE="$(openssl version -d | awk -F'"' '{print $2}' )/cert.pem"
# for some reason git needs its own var 
export GIT_SSL_CAINFO="$SSL_CERT_FILE"