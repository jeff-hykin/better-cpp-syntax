# if file exists, use it
__temp_var__certs_file="$PROJECTR_FOLDER/resources/cacert.pem"
if [ -f "$__temp_var__certs_file" ]
then
    export SSL_CERT_FILE="$__temp_var__certs_file"
    # for some reason git needs its own var 
    export GIT_SSL_CAINFO="$SSL_CERT_FILE"
fi
unset __temp_var__certs_file
