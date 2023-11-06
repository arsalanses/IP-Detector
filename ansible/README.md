```
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

cp -rfp inventory/sample inventory/arvancluster
declare -a IPS=(10.10.1.3 10.10.1.4 10.10.1.5)
CONFIG_FILE=inventory/arvancluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}

ansible-playbook -i inventory/arvancluster/hosts.yaml  --become --become-user=root reset.yml
ansible-playbook -i inventory/arvancluster/hosts.yaml  --become --become-user=root cluster.yml

scp $USERNAME@$IP_CONTROLLER_0:/etc/kubernetes/admin.conf kubespray-do.conf
```
