#!/bin/bash
set -e 

BASENAME=$(basename $0)
OUTPUT="${BASENAME}.log"
exec 3>&1   # Copy current STDOUT to &3
exec 4>&2   # Copy current STDERR to &4
echo "Redirecting STDIN/STDOUT to $OUTPUT"
# exec 1>$OUTPUT 2>&1  
# REF: https://unix.stackexchange.com/questions/145651/using-exec-and-tee-to-redirect-logs-to-stdout-and-a-log-file-in-the-same-time
exec &> >(tee -a "$OUTPUT") # Reditect STDOUT/STDERR to file
exec 2>&1  
echo "This will be logged to the file and to the screen"

GLOBAL_EXIT_STATUS=0
WD=$(pwd)


ERROR=""
function funThrow {
    if [[ $STOP_ON_ERROR != false ]] ; then
      echo "ERROR DETECTED: Aborting now due to" 
      echo -e ${ERROR} 
      exit 1;
    else
      echo "ERROR DETECTED: "
      echo -e ${ERROR}
      echo "WARN: CONTINUING WITH ERRORS "
      GLOBAL_EXIT_STATUS=1
    fi
    ERROR=""
}

function funUssage {
    cat << EOF
# Option 1: Create -Self Signed- (R)oot Auth cert
  ${BASENAME} R # ← (R)oot            

# Option 2: Sign (C)hild certificate with existing Root one
  $ export DOMAIN="oficina24x7.com"
  $ export SUBJ="/C=ES/ST=Aragon/L=Zaragoza/O=Oficina24x7/CN=\${DOMAIN}"
  $ export N_DAYS="9999"
  ${BASENAME} C # ← (C)hild 
EOF
  funThrow
}
function funCreateRooCertAndKey {
openssl genrsa -out rootCA.key 2048
openssl req -x509 -nodes \
    -days $N_DAYS \
    -key rootCA.key -sha256 \
    -out rootCA.pem \
    -new  # ← Replace with ' -in $DOMAIN.csr ' to reuse crt
}

function funCreateCertificate {
  if [ ! -f rootCA.pem ]; then
    ERROR='no rootCA.pem detected. Please, run create_root_cert_and_key.sh first, and try again!' 
    funThrow
  fi
  if [ ! -f v3.ext     ]; then 
    ERROR='Please download the "v3.ext" file and try again!' 
    funThrow
  fi

  if [ -f $DOMAIN.key ]; then #  Create/Reuse Priv.Key for domain
      KEY_OPT="-key" 
  else 
      KEY_OPT="-keyout"
  fi 

EXT_FILE=v3.ext
cat << EOF > $EXT_FILE
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = $COMMON_NAME
EOF

  openssl req -new -newkey rsa:2048 \
     -sha256 -nodes $KEY_OPT $DOMAIN.key \
     -subj "${SUBJ}" -out $DOMAIN.csr

  openssl x509 -req -in $DOMAIN.csr \
     -CA rootCA.pem -CAkey rootCA.key \
     -CAcreateserial -out $DOMAIN.crt \
     -days $N_DAYS -sha256 \
     -extfile $EXT_FILE
}

function funPreChecks {
 if [[ ! $DOMAIN ]] ; then ERROR="DOMAIN not defined"; funUssage ; fi
 if [[ ! $SUBJ   ]] ; then ERROR="SUBJ   not defined"; funUssage ; fi
 if [[ ! $N_DAYS ]] ; then ERROR="SUBJ   not defined"; funUssage ; fi
 SUBJ=""
 SUBJ="${SUBJ}/C=ES"
 SUBJ="${SUBJ}/ST=Aragon"
 SUBJ="${SUBJ}/L=Zaragoza"
 SUBJ="${SUBJ}/O=Oficina24x7"
 SUBJ="${SUBJ}/CN=${DOMAIN}"
 N_DAYS="9999"

}
cd $WD; funPreChecks

if   [[ $1 == "R" ]] ; then
  funCreateRooCertAndKey
elif [[ $1 == "C" ]] ; then
  funCreateCertificate
else 
  funUssage
fi     

echo "Exiting with status:$GLOBAL_EXIT_STATUS"
exit $GLOBAL_EXIT_STATUS
