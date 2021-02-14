# Install scripts for Debian / Ubuntu  

## The `deb` dir as local apt repo  

This is the local **apt** repo, that makes it possible to manage local packages with **apt** or **aptitude**. It contains a `*.deb` packages and management shell scripts. Also `Packages.gz` may be automatically created.  

### Adding local packages  

Put a `*.deb` files into the `deb` dir, then run `./upd.sh`.  

The `./Packages.gz` and **apt** database will be updated. Also, this will automatically inits the local repo by `./init.sh`.  

### Removing local package  

`./rem.sh <filename>.deb`  

## Other dirs  

Other dirs contains a simple shell scripts for building `*.deb` package and then installing it with **aptitude**.  

### OpenSSL  

`cd install/openssl-1.1.1h && ./install.sh`  

## Requirements  

- checkinstall  
- aptitude  
- sudo  
