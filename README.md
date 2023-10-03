# tanzu-plug-in-for-asdf

ASDF plugin to VMware Tanzu install tools from github on x86 Mac and Linux. Note most tools ship with 64 bit binaries.

ASDF allows you to install multiple versions of a single tool and switch between them either globally or on a per shell basis.

## Supported Tools
- bbr
- bbr-s3-config-validator
- bosh
- credhub
- fly
- kpack
- om
- pivnet
- tanzu-cli
- uaa-cli

## Prerequisites
You must have [asdf](https://asdf-vm.com/guide/getting-started.html) installed.

## Installation

Install using ASDF. Example below for `bosh` will download, install and set the version.
```
asdf plugin add bosh
asdf list all bosh
asdf install bosh 7.0.0
asdf global bosh 7.0.0
```

To manually install use the following, where tool name is one of the support tools listed above:
```
asdf plugin-add <tool name> https://github.com/vmware-tanzu/tanzu-plug-in-for-asdf.git
```

## Testing

Testing requires docker to be installed locally.

From the root of the repo run `./tests/docker-run-tests.sh`.

## Contributing

Please see our [Code of Conduct](CODE-OF-CONDUCT.md) and [Contributors guide](CONTRIBUTING.md).

The tanzu-plugin-for-asdf project team welcomes contributions from the community. Before you start working with tanzu-plugin-for-asdf, please read and sign our Contributor License Agreement [CLA](https://cla.vmware.com/cla/1/preview). If you wish to contribute code and you have not signed our contributor license agreement (CLA), our bot will prompt you to do so when you open a Pull Request. For any questions about the CLA process, please refer to our [FAQ]([https://cla.vmware.com/faq](https://cla.vmware.com/faq)).


## License
Apache License 
