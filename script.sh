az group create \
--name RG-20-Monitoring \
--location westeurope

az network vnet create \
  --resource-group RG-20-Monitoring \
  --name MAIN-vNET \
  --subnet-name SUBNET-01

az network nsg create \
  --resource-group RG-20-Monitoring \
  --name NSG-MAIN

az network nsg rule create \
  --resource-group RG-20-Monitoring \
  --name MAIN-vNET-NSG-RULE \
  --nsg-name NSG-MAIN \
  --protocol tcp \
  --direction inbound \
  --source-address-prefix '*' \
  --source-port-range '*' \
  --destination-address-prefix '*' \
  --destination-port-range 80 \
  --access allow \
  --priority 200

az network nsg rule create \
  --resource-group RG-20-Monitoring \
  --name MAIN-vNET-SSH-RULE \
  --nsg-name NSG-MAIN \
  --protocol tcp \
  --direction inbound \
  --source-address-prefix '*' \
  --source-port-range '*' \
  --destination-address-prefix '*' \
  --destination-port-range 22 \
  --access allow \
  --priority 300

az network vnet subnet update \
  --resource-group RG-20-Monitoring \
  --vnet-name MAIN-vNET \
  --name SUBNET-01 \
  --network-security-group NSG-MAIN

az vm create \
  --resource-group RG-20-Monitoring \
  --name VM-01 \
  --admin-username adminuser \
  --admin-password adminadmin123! \
  --vnet-name MAIN-vNET \
  --nsg NSG-MAIN \
  --subnet SUBNET-01 \
  --size Standard_B1s \
  --image UbuntuLTS

az vm extension set \
  --publisher Microsoft.Azure.Extensions \
  --version 2.0 \
  --name CustomScript \
  --vm-name VM-01 \
  --resource-group RG-20-Monitoring \
  --settings '{"commandToExecute":"apt-get -y update && apt-get -y install apache2 && echo Module 20 - Azure Monitoring > /var/www/html/index.html"}'
