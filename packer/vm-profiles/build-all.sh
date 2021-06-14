#!/bin/bash -l

set -ex

printf "\t\t\t\t\t[ Illume v2 - Builder CLI ]\n"


# cd base
# printf "\n\n[ BUILDING NON-INTERACTIVE ]\n\n"
# packer build -force non-interactive.pkr.hcl
# printf "\n\n[ BUILDING INTERACTIVE ]\n\n"
# packer build -force interactive.pkr.hcl

# cd ../bastion
# printf "\n\n[ BUILDING BASTION ]\n\n"
# packer build -force bastion.pkr.hcl

# cd ../ingress
# printf "\n\n[ BUILDING INGRESS ]\n\n"
# packer build -force ingress.pkr.hcl

# cd ../monitor
# printf "\n\n[ BUILDING MONITOR ]\n\n"
# packer build -force monitor.pkr.hcl

# cd ../ldap
# printf "\n\n[ BUILDING openLDAP ]\n\n"
# packer build -force openLDAP.pkr.hcl
# printf "\n\n[ BUILDING phpLDAPadmin ]\n\n"
# packer build -force phpLDAPadmin.pkr.hcl

# cd ../proxy
# printf "\n\n[ BUILDING PROXY ]\n\n"
# packer build -force proxy.pkr.hcl

# cd ../control
# printf "\n\n[ BUILDING CONTROL ]\n\n"
# packer build -force control.pkr.hcl

# cd ../worker
cd worker
printf "\n\n[ BUILDING WORKER-NOGPU ]\n\n"
packer build -force worker-nogpu.pkr.hcl
printf "\n\n[ BUILDING WORKER-GPU ]\n\n"
packer build -force worker-gpu.pkr.hcl
