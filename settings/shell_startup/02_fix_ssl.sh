# 
# if file exists, use it
# 
if [ -f "/usr/local/etc/openssl@1.1/cert.pem" ]
then
    export SSL_CERT_FILE="/usr/local/etc/openssl@1.1/cert.pem"
elif [ -f "/usr/lib/ssl/certs/ca-certificates.crt" ]
then
    export SSL_CERT_FILE="/usr/lib/ssl/certs/ca-certificates.crt"
elif [ -f "/etc/ssl/certs/ca-certificates.crt" ]
then
    export SSL_CERT_FILE="/etc/ssl/certs/ca-certificates.crt"
elif [ -f "/usr/lib/ssl/cert.pem" ]
then
    export SSL_CERT_FILE="/usr/lib/ssl/cert.pem"
elif [ -f "/nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt" ]
then
    export SSL_CERT_FILE="/nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt"
# 
# otherwise detect a file
# 
else

    escape_shell_argument () {
        printf '%s' "'$(printf '%s' "$1" | sed 's/'"'"'/'"'"'"'"'"'"'"'"'/')'"
    }
    __temp_var__ssl_path="$PROJECTR_FOLDER/#system/#temporary/ssl_file"
    __temp_var__escaped_temp_file="$(escape_shell_argument "$__temp_var__ssl_path")"
    __temp_var__double_quotes="\"\""
    
    # it would be nice if python wasnt needed to reliably fine this file... alas
    nix-shell --pure --run "python -c 'import ssl; print(ssl.get_default_verify_paths().openssl_cafile, end=$__temp_var__double_quotes)' > ""$__temp_var__escaped_temp_file" -p python37 -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/046f8835dcb9082beb75bb471c28c832e1b067b6.tar.gz
    export SSL_CERT_FILE="$(cat "$__temp_var__ssl_path")"

    unset __temp_var__double_quotes
    unset __temp_var__escaped_temp_file 
    unset __temp_var__ssl_path
fi

# for some reason git needs its own var 
export GIT_SSL_CAINFO="$SSL_CERT_FILE"