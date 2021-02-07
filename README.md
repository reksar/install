# Install scripts for Debian / Ubuntu  

## `deb` dir as local apt repo  

The main dir is `deb`, that is the `apt` local repo. It contains a `*.deb` files that are awailable in the `apt` database, so it is possible to manage local third-party packages with `apt` or `aptitude`.  

### Adding local package  

Put a `*.deb` files into `deb` dir, then run `./upd.sh`. The `Packages.gz` and aptitude will be updated. Also, this will automatically inits the local repo with `./init.sh`.  

### Removing local package  

`./rem.sh <filename>.deb`  

## Other dirs  

Other dirs contains simple shell scripts for getting the `*.deb` package, putting it into the local repo and installing then. They builds `*.deb` package from sources, using `checkinstall`.  

### OpenSSL  

`cd install/openssl-1.1.1h && ./install.sh`  

## Requirements

- aptitude
- checkinstall
- sudo

