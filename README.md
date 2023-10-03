# Deploying Acme Air on Openshift
Acme Air workload, configured to run on Openshift on Z. The Acme Air workload models a Flight booking system for the fictional Acme Air company. See upstream source at https://github.com/blueperf/acmeair-mainservice-java for running on other plaforms than OCP. Once deployed, access Acmeair application by going to https://<your_custom_domain>/acmeair . To simulate many customers interating with the system use Acmeair-driver https://github.ibm.com/OpenShift-on-Z/Acmeair-driver . For running acmeair on nfs persistent volume checkout nfs_volume branch. For running as part of the kitchen sink ci test checkout the jenkins branch.

# Card Service Routes
Swagger UI API specifications available at `deployment.url.com/openapi/ui`. The specification can be edited in `acmeair-cardservice-java/src/main/webapp/META-INF/openapi.yaml`.

GET `/acmeair-cardservice-java/api/cardService/getCardByCardholder`

As url encoded form data, pass in `cardholderName:<first and last name>` to retrieve all credit card data for the provided cardholder. 
  
POST `/acmeair-cardservice-java/api/cardService/processCard`

As url encoded form data, the post route takes the following parameters to process a new card

    `cardNumber:<16 digit credit card number>*`

    `expDate:<card experiation date in MM/YY format>*`

    `securityCode:<three digit security code>*`

    `cardholderName:<first and last name>*`

    `billingAddressLine1:1<street address>*`

    `billingAddressLine2: <street address line two>`

    `billingAddressZipCode:<5 digit zip code>*`

    `billingAddressCity:<city>*`

    `billingAddressStateProvince:<state/province>`

    `billingAddressCountry:<country>*`

  * = required 
