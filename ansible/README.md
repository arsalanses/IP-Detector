# KubeSpray

## Setup
```sh
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

## Set inventory
```sh
cp -rfp inventory/sample inventory/arvancluster
declare -a IPS=(10.10.1.3 10.10.1.4 10.10.1.5)
CONFIG_FILE=inventory/arvancluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}
# ansible_user: ubuntu
```

## Run playbook
```sh
ansible-playbook -i inventory/arvancluster/hosts.yaml  --become --become-user=root reset.yml
ansible-playbook -i inventory/arvancluster/hosts.yaml  --become --become-user=root cluster.yml
```

## kube config file
```sh
scp $USERNAME@$IP_CONTROLLER_0:/etc/kubernetes/admin.conf kubespray-do.conf
```

## Setup Shecan DNS 
```sh
sudo echo "$(dig +short @178.22.122.100 k8s.io) k8s.io" | sudo tee -a /etc/hosts && \
sudo sed -i '1i nameserver 185.51.200.2' /etc/resolv.conf && \
sudo sed -i '1i nameserver 178.22.122.100' /etc/resolv.conf
```

## Ingress 
```sh
inventory/arvancluster/group_vars/k8s_cluster/addons
# ingress_nginx_enabled: true
```

## Testing cluster
```sh
kubectl run myshell1 -it --rm --image busybox -- sh
```
