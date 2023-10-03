# ENV Vars
Updates for 4/23 include adding IBM MQ message sending. IBM MQ requires a three different configuration files as well as SSL keys. These keys will need to be mounted in the `deploy-acmeair-cardservice-java.yaml`. The locations of the files are then passed to java using the following environment variables. Although these files could have been included in the container image by editing the Dockerfile, the approach of specifying locations with env vars and using volume mounts was chosen to support varying deployment environments, I.E. different keys, channel names, connection URL's in testing vs prod etc.

## MQENVURL 
This is a json file that is used to communicate client channel connection parameters in conjunction with the file at `$MQCCDTURL` I.E. the CCDT file.
Sample `env.json`:
## MQCCDTURL
[Client Channel Definition Table (CCDT) file](https://www.ibm.com/docs/en/ibm-mq/9.3?topic=tables-configuring-binary-format-ccdt) is used in conjunction with the json file at `$MQENVURL` to specify the MQ client connection parameters. Not sure we need both but Java will error if they are not both present. 
Sample `ccdt.json`:
## MQCLNTCF
Often called `mqclient.ini` [this file](https://www.ibm.com/docs/en/ibm-mq/9.3?topic=client-configuring-using-configuration-file) is also used to configure the MQClient, though I believe this is more general than the other two files.
## MQCLIENTKEYSTORE
Path to the `.jks` client tls keys.