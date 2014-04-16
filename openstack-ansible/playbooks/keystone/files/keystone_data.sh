#!/bin/bash

# --------
# Defaults
# --------

SERVICE_TENANT_NAME={{service_tenant_name}}

ADMIN_ROLE_NAME={{admin_role_name}}
ADMIN_TENANT_NAME={{admin_tenant_name}}
DEMO_TENANT_NAME={{demo_tenant_name}}

# SERVIVCE PASSWORD
ADMIN_PASS={{admin_password}}
DEMO_PASS={{demo_password}}
NOVA_PASS={{nova_password}}
GLANCE_PASS={{glance_password}}
CINDER_PASS={{cinder_password}}
NEUTRON_PASS={{neutron_password}}
#SWIFT_PASS={{swift_password}}
CEILOMETER_PASS={{ceilometer_password}}

# SERVICE USER
#ADMIN_USERNAME=admin
ADMIN_USERNAME={{admin_username}}
DEMO_USERNAME={{demo_username}}
NOVA_USERNAME={{nova_username}}
GLANCE_USERNAME={{glance_username}}
CINDER_USERNAME={{cinder_username}}
NEUTRON_USERNAME={{neutron_username}}
#SWIFT_USERNAME={{swift_username}}
CEILOMETER_USERNAME={{ceilometer_username}}

# E-MAIL ADDRESS
ADMIN_EMAIL={{admin_email}}
DEMO_EMAIL={{demo_email}}
NOVA_EMAIL={{nova_email}}
GLANCE_EMAIL={{glance_email}}
CINDER_EMAIL={{cinder_email}}
NEUTRON_EMAIL={{neutron_email}}
CEILOMETER_EMAIL={{ceilometer_email}}
#SWIFT_EMAIL={{swift_email}}

# SERVICE PROTOCOL
NOVA_PUBLIC_SERVICE_PROTOCOL={{nova_public_service_protocol}}
NOVA_ADMIN_SERVICE_PROTOCOL={{nova_admin_service_protocol}}
NOVA_INTERNAL_SERVICE_PROTOCOL={{nova_internal_service_protocol}}
EC2_PUBLIC_SERVICE_PROTOCOL={{ec2_public_service_protocol}}
EC2_ADMIN_SERVICE_PROTOCOL={{ec2_admin_service_protocol}}
EC2_INTERNAL_SERVICE_PROTOCOL={{ec2_internal_service_protocol}}
GLANCE_PUBLIC_SERVICE_PROTOCOL={{glance_public_service_protocol}}
GLANCE_ADMIN_SERVICE_PROTOCOL={{glance_admin_service_protocol}}
GLANCE_INTERNAL_SERVICE_PROTOCOL={{glance_internal_service_protocol}}
KEYSTONE_PUBLIC_SERVICE_PROTOCOL={{keystone_public_service_protocol}}
KEYSTONE_ADMIN_SERVICE_PROTOCOL={{keystone_admin_service_protocol}}
KEYSTONE_INTERNAL_SERVICE_PROTOCOL={{keystone_internal_service_protocol}}
CINDER_PUBLIC_SERVICE_PROTOCOL={{cinder_public_service_protocol}}
CINDER_ADMIN_SERVICE_PROTOCOL={{cinder_admin_service_protocol}}
CINDER_INTERNAL_SERVICE_PROTOCOL={{cinder_internal_service_protocol}}
NEUTRON_PUBLIC_SERVICE_PROTOCOL={{neutron_public_service_protocol}}
NEUTRON_ADMIN_SERVICE_PROTOCOL={{neutron_admin_service_protocol}}
NEUTRON_INTERNAL_SERVICE_PROTOCOL={{neutron_internal_service_protocol}}
#SWIFT_PUBLIC_SERVICE_PROTOCOL={{swift_public_service_protocol}}
#SWIFT_ADMIN_SERVICE_PROTOCOL={{swift_admin_service_protocol}}
#SWIFT_INTERNAL_SERVICE_PROTOCOL={{swift_internal_service_protocol}}
CEILOMETER_PUBLIC_SERVICE_PROTOCOL={{ceilometer_public_service_protocol}}
CEILOMETER_ADMIN_SERVICE_PROTOCOL={{ceilometer_admin_service_protocol}}
CEILOMETER_INTERNAL_SERVICE_PROTOCOL={{ceilometer_internal_service_protocol}}

# SERVICE PORT
NOVA_COMPUTE_PORT={{nova_compute_port}}
EC2_PORT={{ec2_port}}
GLANCE_API_PORT={{glance_api_port}}
KEYSTONE_PUBLIC_PORT={{keystone_public_port}}
KEYSTONE_ADMIN_PORT={{keystone_admin_port}}
CEILOMETER_PORT={{ceilometer_port}}
NEUTRON_PORT={{neutron_port}}
#SWIFT_PORT={{swift_port}}
CINDER_PORT={{cinder_port}}

# IDENTITY
IDENTITY_API_VERSION={{identity_api_version}}
REGION={{region}}

# SERVICE HOST ADDRESS
NOVA_PUBLIC_SERVICE_HOST={{nova_public_service_host}}
NOVA_ADMIN_SERVICE_HOST={{nova_admin_service_host}}
NOVA_INTERNAL_SERVICE_HOST={{nova_internal_service_host}}
EC2_PUBLIC_SERVICE_HOST={{ec2_public_service_host}}
EC2_ADMIN_SERVICE_HOST={{ec2_admin_service_host}}
EC2_INTERNAL_SERVICE_HOST={{ec2_internal_service_host}}
GLANCE_PUBLIC_SERVICE_HOST={{glance_public_service_host}}
GLANCE_ADMIN_SERVICE_HOST={{glance_admin_service_host}}
GLANCE_INTERNAL_SERVICE_HOST={{glance_internal_service_host}}
KEYSTONE_PUBLIC_SERVICE_HOST={{keystone_public_service_host}}
KEYSTONE_ADMIN_SERVICE_HOST={{keystone_admin_service_host}}
KEYSTONE_INTERNAL_SERVICE_HOST={{keystone_internal_service_host}}
CINDER_PUBLIC_SERVICE_HOST={{cinder_public_service_host}}
CINDER_ADMIN_SERVICE_HOST={{cinder_admin_service_host}}
CINDER_INTERNAL_SERVICE_HOST={{cinder_internal_service_host}}
NEUTRON_PUBLIC_SERVICE_HOST={{neutron_public_service_host}}
NEUTRON_ADMIN_SERVICE_HOST={{neutron_admin_service_host}}
NEUTRON_INTERNAL_SERVICE_HOST={{neutron_internal_service_host}}
#SWIFT_PUBLIC_SERVICE_HOST={{swift_public_service_host}}
#SWIFT_ADMIN_SERVICE_HOST={{swift_admin_service_host}}
#SWIFT_INTERNAL_SERVICE_HOST={{swift_internal_service_host}}
CEILOMETER_PUBLIC_SERVICE_HOST={{ceilometer_public_service_host}}
CEILOMETER_ADMIN_SERVICE_HOST={{ceilometer_admin_service_host}}
CEILOMETER_INTERNAL_SERVICE_HOST={{ceilometer_internal_service_host}}


#------------
# Check
#------------

/usr/bin/keystone --os-username=${ADMIN_USERNAME} --os-tenant-name=${ADMIN_TENANT_NAME} --os-password=${ADMIN_PASS} --os-auth-url=http://localhost:5000/v2.0 tenant-list

RET=`echo $?`

if [ ${RET} -eq 0 ]
then
   exit 0
fi

#------------
# export environment variable 
#------------
export SERVICE_TOKEN={{service_token}}
export SERVICE_ENDPOINT={{service_endpoint}}

# ------------
# Function
# ------------

function get_id () {
    echo `"$@" | awk '/ id / { print \$4 }'`
}

# --------------------------------------
# Admin
# --------------------------------------
ADMIN_TENANT=$(get_id keystone tenant-create --name ${ADMIN_TENANT_NAME})
ADMIN_ROLE=$(get_id keystone role-create     --name ${ADMIN_ROLE_NAME})
ADMIN_USER=$(get_id keystone user-create     --name ${ADMIN_USERNAME} --pass "${ADMIN_PASS}" --email ${ADMIN_EMAIL})
keystone user-role-add --user-id ${ADMIN_USER} --role-id ${ADMIN_ROLE} --tenant-id ${ADMIN_TENANT}

# --------------------------------------
# demo
# --------------------------------------
MEMBER_ROLE=$(keystone role-list | awk "/ _member_ / { print \$2 }")
DEMO_TENANT=$(get_id keystone tenant-create --name ${DEMO_TENANT_NAME})
DEMO_USER=$(get_id keystone user-create --name ${DEMO_USERNAME} --pass "${DEMO_PASS}" --email ${DEMO_EMAIL})
keystone user-role-add --user-id ${DEMO_USER} --role-id ${MEMBER_ROLE} --tenant-id ${DEMO_TENANT}
keystone user-role-add --user-id ${ADMIN_USER} --role-id ${ADMIN_ROLE} --tenant-id ${DEMO_TENANT}

# --------------------------------------
# Service
# --------------------------------------
SERVICE_TENANT=$(get_id keystone tenant-create --name ${SERVICE_TENANT_NAME})

# --------------------------------------
# Services
# --------------------------------------
NOVA_SERVICE=$(get_id keystone service-create       --name=nova     --type=compute --description="Nova Compute Service")
NOVA_V3_SERVICE=$(get_id keystone service-create    --name=nova     --type=computev3 --description="Nova Compute Service V3")
EC2_SERVICE=$(get_id keystone service-create        --name=ec2      --type=ec2 --description="EC2 Compatibility Layer")
GLANCE_SERVICE=$(get_id keystone service-create     --name=glance   --type=image --description="Glance Image Service")
KEYSTONE_SERVICE=$(get_id keystone service-create   --name keystone --type identity --description "Keystone Identity Service")
CINDER_SERVICE=$(get_id keystone service-create     --name=cinder   --type=volume --description="Cinder Volume Service")
CINDER_V2_SERVICE=$(get_id keystone service-create  --name=cinder   --type=volumev2 --description="Cinder Volume Service V2")
NEUTRON_SERVICE=$(get_id keystone service-create    --name=neutron  --type=network --description="Neutron Service")
#SWIFT_SERVICE=$(get_id keystone service-create      --name=swift    --type=object-store --description="Object Service")
CEILOMETER_SERVICE=$(get_id keystone service-create --name=ceilometer    --type=metering --description="Ceilometer Service")

# --------------------------------------
# Service Users
# --------------------------------------
NOVA_USER=$(get_id keystone user-create       --name ${NOVA_USERNAME}    --pass "${NOVA_PASS}"    --tenant_id ${SERVICE_TENANT} --email ${NOVA_EMAIL})
GLANCE_USER=$(get_id keystone user-create     --name ${GLANCE_USERNAME}  --pass "${GLANCE_PASS}"  --tenant_id ${SERVICE_TENANT} --email ${GLANCE_EMAIL})
CINDER_USER=$(get_id keystone user-create     --name ${CINDER_USERNAME}  --pass "${CINDER_PASS}"  --tenant_id ${SERVICE_TENANT} --email ${CINDER_EMAIL})
NEUTRON_USER=$(get_id keystone user-create    --name ${NEUTRON_USERNAME} --pass "${NEUTRON_PASS}" --tenant_id ${SERVICE_TENANT} --email ${NEUTRON_EMAIL})
#SWIFT_USER=$(get_id keystone user-create      --name ${SWIFT_USERNAME}   --pass "${SWIFT_PASS}"   --tenant_id ${SERVICE_TENANT} --email ${SWIFT_EMAIL})
CEILOMETER_USER=$(get_id keystone user-create --name ${CEILOMETER_USERNAME} --pass "${CEILOMETERPASS}" --tenant_id ${SERVICE_TENANT} --email ${CEILOMETER_EMAIL})

# --------------------------------------
# User role add
# --------------------------------------
keystone user-role-add --tenant-id ${SERVICE_TENANT} --role-id ${ADMIN_ROLE} --user-id ${NOVA_USER}
keystone user-role-add --tenant-id ${SERVICE_TENANT} --role-id ${ADMIN_ROLE} --user-id ${GLANCE_USER}
keystone user-role-add --tenant-id ${SERVICE_TENANT} --role-id ${ADMIN_ROLE} --user-id ${CINDER_USER}
keystone user-role-add --tenant-id ${SERVICE_TENANT} --role-id ${ADMIN_ROLE} --user-id ${NEUTRON_USER}
keystone user-role-add --tenant-id ${SERVICE_TENANT} --role-id ${ADMIN_ROLE} --user-id ${SWIFT_USER}
keystone user-role-add --tenant-id ${SERVICE_TENANT} --role-id ${ADMIN_ROLE} --user-id ${CEILOMETER_USER}

# --------------------------------------
# Endpoints
# --------------------------------------
keystone endpoint-create \
    --region ${REGION} \
    --service_id ${NOVA_SERVICE} \
    --publicurl "${NOVA_PUBLIC_SERVICE_PROTOCOL}://${NOVA_PUBLIC_SERVICE_HOST}:${NOVA_COMPUTE_PORT}/v2/\$(tenant_id)s" \
    --adminurl "${NOVA_ADMIN_SERVICE_PROTOCOL}://${NOVA_ADMIN_SERVICE_HOST}:${NOVA_COMPUTE_PORT}/v2/\$(tenant_id)s" \
    --internalurl "${NOVA_INTERNAL_SERVICE_PROTOCOL}://${NOVA_INTERNAL_SERVICE_HOST}:${NOVA_COMPUTE_PORT}/v2/\$(tenant_id)s"

keystone endpoint-create \
    --region ${REGION} \
    --service_id ${NOVA_V3_SERVICE} \
    --publicurl "${NOVA_PUBLIC_SERVICE_PROTOCOL}://${NOVA_PUBLIC_SERVICE_HOST}:${NOVA_COMPUTE_PORT}/v3" \
    --adminurl "${NOVA_ADMIN_SERVICE_PROTOCOL}://${NOVA_ADMIN_SERVICE_HOST}:${NOVA_COMPUTE_PORT}/v3" \
    --internalurl "${NOVA_INTERNAL_SERVICE_PROTOCOL}://${NOVA_INTERNAL_SERVICE_HOST}:${NOVA_COMPUTE_PORT}/v3"

keystone endpoint-create \
    --region ${REGION} \
    --service_id ${EC2_SERVICE} \
    --publicurl "${EC2_PUBLIC_SERVICE_PROTOCOL}://${EC2_PUBLIC_SERVICE_HOST}:${EC2_PORT}/services/Cloud" \
    --adminurl "${EC2_INTERNAL_SERVICE_PROTOCOL}://${EC2_ADMIN_SERVICE_HOST}:${EC2_PORT}/services/Admin" \
    --internalurl "${EC2_ADMIN_SERVICE_PROTOCOL}://${EC2_INTERNAL_SERVICE_HOST}:${EC2_PORT}/services/Cloud"

keystone endpoint-create \
    --region ${REGION} \
    --service_id ${GLANCE_SERVICE} \
    --publicurl "${GLANCE_PUBLIC_SERVICE_PROTOCOL}://${GLANCE_PUBLIC_SERVICE_HOST}:${GLANCE_API_PORT}" \
    --adminurl "${GLANCE_ADMIN_SERVICE_PROTOCOL}://${GLANCE_INTERNAL_SERVICE_HOST}:${GLANCE_API_PORT}" \
    --internalurl "${GLANCE_INTERNAL_SERVICE_PROTOCOL}://${GLANCE_ADMIN_SERVICE_HOST}:${GLANCE_API_PORT}"

keystone endpoint-create \
    --region ${REGION} \
    --service_id ${KEYSTONE_SERVICE} \
    --publicurl "${KEYSTONE_PUBLIC_SERVICE_PROTOCOL}://${KEYSTONE_PUBLIC_SERVICE_HOST}:${KEYSTONE_PUBLIC_PORT}/${IDENTITY_API_VERSION}" \
    --adminurl "${KEYSTONE_ADMIN_SERVICE_PROTOCOL}://${KEYSTONE_INTERNAL_SERVICE_HOST}:${KEYSTONE_ADMIN_PORT}/${IDENTITY_API_VERSION}" \
    --internalurl "${KEYSTONE_INTERNAL_SERVICE_PROTOCOL}://${KEYSTONE_ADMIN_SERVICE_HOST}:${KEYSTONE_PUBLIC_PORT}/${IDENTITY_API_VERSION}"

keystone endpoint-create \
    --region ${REGION} \
    --service_id ${CINDER_SERVICE} \
    --publicurl "${CINDER_PUBLIC_SERVICE_PROTOCOL}://${CINDER_PUBLIC_SERVICE_HOST}:${CINDER_PORT}/v1/\$(tenant_id)s" \
    --adminurl "${CINDER_ADMIN_SERVICE_PROTOCOL}://${CINDER_ADMIN_SERVICE_HOST}:${CINDER_PORT}/v1/\$(tenant_id)s" \
    --internalurl "${CINDER_INTERNAL_SERVICE_PROTOCOL}://${CINDER_INTERNAL_SERVICE_HOST}:${CINDER_PORT}/v1/\$(tenant_id)s"

keystone endpoint-create \
    --region ${REGION} \
    --service_id ${CINDER_V2_SERVICE} \
    --publicurl "${CINDER_PUBLIC_SERVICE_PROTOCOL}://${CINDER_PUBLIC_SERVICE_HOST}:${CINDER_PORT}/v2/\$(tenant_id)s" \
    --adminurl "${CINDER_ADMIN_SERVICE_PROTOCOL}://${CINDER_ADMIN_SERVICE_HOST}:${CINDER_PORT}/v2/\$(tenant_id)s" \
    --internalurl "${CINDER_INTERNAL_SERVICE_PROTOCOL}://${CINDER_INTERNAL_SERVICE_HOST}:${CINDER_PORT}/v2/\$(tenant_id)s" \

keystone endpoint-create \
    --region ${REGION} \
    --service_id ${NEUTRON_SERVICE} \
    --publicurl "${NEUTRON_PUBLIC_SERVICE_PROTOCOL}://${NEUTRON_PUBLIC_SERVICE_HOST}:${NEUTRON_PORT}" \
    --adminurl "${NEUTRON_ADMIN_SERVICE_PROTOCOL}://${NEUTRON_INTERNAL_SERVICE_HOST}:${NEUTRON_PORT}" \
    --internalurl "${NEUTRON_INTERNAL_SERVICE_PROTOCOL}://${NEUTRON_ADMIN_SERVICE_HOST}:${NEUTRON_PORT}"

#keystone endpoint-create \
#    --region ${REGION} \
#    --service_id ${SWIFT_SERVICE} \
#    --publicurl "${SWIFT_PUBLIC_SERVICE_PROTOCOL}://${SWIFT_PUBLIC_SERVICE_HOST}:${SWIFT_PORT}/v1/AUTH_\$(tenant_id)s" \
#    --adminurl "${SWIFT_ADMIN_SERVICE_PROTOCOL}://${SWIFT_INTERNAL_SERVICE_HOST}:${SWIFT_PORT}" \
#    --internalurl "${SWIFT_INTERNAL_SERVICE_PROTOCOL}://${SWIFT_ADMIN_SERVICE_HOST}:${SWIFT_PORT}/v1/AUTH_\$(tenant_id)s"

keystone endpoint-create \
    --region ${REGION} \
    --service_id ${CEILOMETER_SERVICE} \
    --publicurl "${CEILOMETER_PUBLIC_SERVICE_PROTOCOL}://${CEILOMETER_PUBLIC_SERVICE_HOST}:${CEILOMETER_PORT}" \
    --adminurl "${CEILOMETER_ADMIN_SERVICE_PROTOCOL}://${CEILOMETER_INTERNAL_SERVICE_HOST}:${CEILOMETER_PORT}" \
    --internalurl "${CEILOMETER_INTERNAL_SERVICE_PROTOCOL}://${CEILOMETER_ADMIN_SERVICE_HOST}:${CEILOMETER_PORT}"

