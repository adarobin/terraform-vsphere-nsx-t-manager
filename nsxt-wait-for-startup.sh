#!/usr/bin/env bash

set -o errexit
set -o errtrace
set -o nounset
set -o pipefail
# set -o xtrace

resp=""
mstatus=""
cstatus=""

while true; do
    resp=`curl --silent --insecure --user "${NSXT_USERNAME}:${NSXT_PASSWORD}" https://${NSXT_MANAGER_HOSTNAME}/api/v1/cluster/status` || true
    mstatus=`echo $resp | jq -r '.mgmt_cluster_status.status'` || true
    cstatus=`echo $resp | jq -r '.control_cluster_status.status'` || true

    if [ "$mstatus" = "STABLE" ] && [ "$cstatus" = "STABLE" ]; then
        echo "NSX-T Manager is started successfully."
        break
    fi

    echo "Management Cluster status was $mstatus and Control Cluster status was $status. Sleeping for 20 seconds."
    sleep 20
done

exit 0
