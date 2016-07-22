#!/bin/bash

set -e
set -x

NAMESPACE=${NAMESPACE:-ceph}
CLUSTER_DOMAIN=${CLUSTER_DOMAIN:-cluster.local}

UUID=`./generate_secrets.sh fsid`
./generate_secrets.sh all ${UUID}

sed -i "s/mon_host = ceph-mon/mon_host = ceph-mon.${NAMESPACE}.svc.${CLUSTER_DOMAIN}/" ceph.conf

kubectl create secret generic ceph-conf-combined --from-file=ceph.conf --from-file=ceph.client.admin.keyring --from-file=ceph.mon.keyring --namespace=${NAMESPACE}
kubectl create secret generic ceph-bootstrap-rgw-keyring --from-file=ceph.keyring=ceph.rgw.keyring --namespace=${NAMESPACE}
kubectl create secret generic ceph-bootstrap-mds-keyring --from-file=ceph.keyring=ceph.mds.keyring --namespace=${NAMESPACE}
kubectl create secret generic ceph-bootstrap-osd-keyring --from-file=ceph.keyring=ceph.osd.keyring --namespace=${NAMESPACE}
kubectl create secret generic ceph-client-key --from-file=ceph-client-key --namespace=${NAMESPACE}
