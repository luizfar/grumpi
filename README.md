# Grumpi

Grumpi is a command line utility that generates .IPA files for iOS applications.
It can generate .IPA packages either from an Xcode project or from a Kony archive (.KAR).

### Installation

Just clone the repository and add the bin folder to your path. Example:

```bash
# Adjust the installation path to your preference
installation_path=~/grumpi
mkdir -p $installation_path

git clone https://github.com/luizfar/grumpi.git $installation_path
echo 'export PATH=$PATH:'$installation_path'/bin' >> ~/.bashrc
```
