#!/bin/bash
set -e  # Exit on any error
set -u  # Treat unset variables as error

# ===============================
# Configurable variables
# ===============================
STATE_STORE="s3://system-resource-monitor-kops-941377151096-eu"
CLUSTER_NAME="system-resource-monitor.k8s.local"
ZONE="eu-west-1a,eu-west-1b,eu-west-1c"
NODE_COUNT=3
NODE_SIZE="t3.small"
CONTROLPLANE_SIZE="t3.small"

# ===============================
# Export kOps state store
# ===============================
echo "[INFO] Setting KOPS_STATE_STORE to $STATE_STORE"
export KOPS_STATE_STORE=$STATE_STORE

# ===============================
# Create the cluster
# ===============================
echo "[INFO] Creating kOps cluster: $CLUSTER_NAME"
kops create cluster \
  --name $CLUSTER_NAME \
  --state $KOPS_STATE_STORE \
  --zones $ZONE \
  --node-count $NODE_COUNT \
  --node-size $NODE_SIZE \
  --control-plane-size $CONTROLPLANE_SIZE \
  --yes

# ===============================
# Validate the cluster
# ===============================
echo "[INFO] Validating cluster..."
kops validate cluster

# ===============================
# List nodes
# ===============================
echo "[INFO] Cluster nodes:"
kubectl get nodes

echo "[SUCCESS] Cluster setup complete!"
