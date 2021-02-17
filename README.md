# Install scripts for Debian / Ubuntu  

## The `deb` dir as local apt repo  

This is the local **apt** repo, that makes it possible to manage local packages with **apt** or **aptitude**. It contains a `*.deb` packages and management shell scripts. Also `deb/Packages.gz` may be automatically created during repo update.  

### Init repo and add packages  

Put a `deb/*.deb` files, then run `make repo`.  

The `deb/Packages.gz` and **apt** database will be updated. Also, this will automatically inits the local repo by adding `deb` dir into apt sources.  

### Remove package  

Delete needed `deb/<filename>.deb`, then run `make repo` for update.  

### Remove repo

`make norepo` will remove repo from **apt** sources.

## Other dirs  

Other dirs are contains scripts for building `*.deb` package and then installing it with **aptitude**.  

### OpenSSL  

`cd install/openssl-1.1.1h && ./install.sh`  

## Requirements  

- checkinstall  
- aptitude  
- sudo  
