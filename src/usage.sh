#!/bin/bash

function grumpi::usage::printHelp() {
  echo "Grumpi is an automatic IPA generator for your iOS project."
  echo "You will need a properties file with the configuration needed for generating your IPA."
  echo ""
  echo "The following options are available:"
  echo ""
  echo "     -f <file>, --file=<file>"
  echo "             Mandatory. Path to your properties file containing the project configuration. Run 'grumpi -h properties' to see the help about the properties file."
  echo ""
  echo "     -p <password>, --password=<password>"
  echo "             Mandatory. Password for your certificate p12."
  echo ""
  echo "     -k <path to kar>, --kar=<path to kar>"
  echo "             Optional. If you are generating your IPA from a Kony project, use this to specify the path to the .KAR file generaated by the Kony build. This is mandatory if your project is a Kony project."
  echo ""
  echo "     -h, --help"
  echo "             Display this help text. Run 'grumpi -h properties' to see more details about the data your properties file must provide."
  echo ""
  echo "May 7th, 2015"
}

function grumpi::usage::printPropertiesHelp() {
  echo "Grumpi requires a properties file with the configuration needed to generate your IPA."
  echo "The following properties are used. Please note that many of them are mandatory:"
  echo ""
  echo "     name"
  echo "             Optional. The name of your project. This will be used for logs and naming the generated IPA. If a name is not provided 'grumpi' will be used."
  echo ""
  echo "     source"
  echo "             Optional. The source to be used to generate the IPA from. Two values are allowed:"
  echo "                  xcode: Used by projects generated from an xcode project. This is the default in case this property is not provided."
  echo "                  kony: Used by projects generated from a Kony Studio KAR file. Kony is a product used to create native iOS applications in JavaScript. It builds an intermediary KAR file that is used as input to generate the IPA. If you use this option, when running Grumpi you will need to use the -k option to provide the path to the KAR file. You will also need to provide the konyPath property listed below."
  echo ""
  echo "     konyPath"
  echo "             Optional (mandatory if generating the IPA from a kony project). The path to your Kony Studio installation. This is usually /Applications/Kony. Grumpi needs a Kony Studio installation since it uses Kony plugins to unpack the KAR file."
  echo ""
  echo "     provisioningProfile"
  echo "             Mandatory. The path to the .mobileprovision file gotten from the iOS Developer Center, used when signing the IPA."
  echo ""
  echo "     certPath"
  echo "             Mandatory. Path to the .cer file gotten from the iOS Developer Center, used when signing the IPA."
  echo ""
  echo "     p12Path"
  echo "             Mandatory. Path to the .p12 file gotten from the iOS Developer Center, used when signing the IPA. You need to provide the password for the certificate p12 when running Grumpi by means of the -p option."
  echo ""
  echo "     schemesPath"
  echo "             Mandatory. Path to a folder containing the schemes to be used when building the IPA."
}