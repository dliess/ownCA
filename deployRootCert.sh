#!/bin/bash

certfile="myCA.pem"
certname="My Root CA"

###
### for system
###
sudo mkdir /usr/local/share/ca-certificates/extra
sudo cp ${certfile} /usr/local/share/ca-certificates/extra/${certfile%.*}.crt
sudo update-ca-certificates

###
### for browsers
###
sudo apt install -y libnss3-tools

hidden_dirs=$(find ~ -maxdepth 1 -type d -name ".*")

# For cert8 (legacy - DBM)
for certDB in $(find ${hidden_dirs} -name "cert8.db")
do
    certdir=$(dirname ${certDB});
    echo "--> certutil -A -n "${certname}" -t "TCu,Cu,Tu" -i ${certfile} -d dbm:${certdir}"
    certutil -A -n "${certname}" -t "TCu,Cu,Tu" -i ${certfile} -d dbm:${certdir}
done

# For cert9 (SQL)
for certDB in $(find ${hidden_dirs} -name "cert9.db")
do
    certdir=$(dirname ${certDB});
    echo "--> certutil -A -n "${certname}" -t "TCu,Cu,Tu" -i ${certfile} -d sql:${certdir}"
    certutil -A -n "${certname}" -t "TCu,Cu,Tu" -i ${certfile} -d sql:${certdir}
done
