# special-palm-tree

This role is specifically designed for Ubuntu 24.04 and is not compatible with other operating systems. It installs and configures the Nginx web server, ensuring it starts on boot, and sets up a firewall using UFW to allow only HTTP (port 80), HTTPS (port 443), SSH (port 22) and LOKI INSTANCE (port 3100) traffic. For log management, it installs Promtail to collect logs from Nginx and configures it to forward the logs to a specified Loki instance, with Promtail set to start on boot and monitor Nginx logs. In terms of user management, the role creates a new user, devops, with sudo privileges and configures SSH key-based authentication for secure access. Additionally, it creates a non-privileged user, bob, granting them the ability to reboot the instance using sudo without requiring a password. This role ensures a secure, efficient, and properly configured server setup.

### Prerequisites
#### 1. For Terraform-Managed Nodes
If you are using the Terraform script provided in Terraform directory, your SSH public key will automatically be copied to the newly deployed node. You can then log in using the ubuntu user.

#### 2. For Existing Nodes
If you are using an existing node, ensure your SSH public key is copied to the target node before running the Ansible tasks. Use the ssh-copy-id command for this purpose.

Example Command
```sh
ssh-copy-id user@remote-server
```
During execution, you will be prompted to enter the SSH password for the remote server.

Once completed, you can proceed with Ansible tasks.

#### 3. Update the Inventory File
Before running the Ansible playbook, update the inventory/inventory.yml file to include the IP address of the remote target nodes. 

For example:
```sh
all:
  children:
    nginx:
      hosts:
        nginx-host1:
          ansible_host: 192.168.1.101
        nginx-host2:
          ansible_host: 192.168.1.102
```

#### 4. Loki Instance Configuration
For this challenge, I am using my Grafana Cloud Loki service as the logging destination. However, this service is temporary and will stop working after some time. When using this role on your end, make sure to update the loki_instance variable with your own Loki instance URL.

Update Example
Modify the defaults/main.yml file:
```sh
loki_instance: "http://<YOUR_LOKI_INSTANCE>:3100"
```

### How to Use this role

Follow these step-by-step instructions to use this Ansible role:

#### 1. Clone the Repository
Start by cloning the repository:
```sh
git clone https://github.com/draju1980/special-palm-tree.git
```

#### 2. Navigate to the Project Directory
Change to the project directory:
```sh
cd special-palm-tree
```

#### 3. Verify Ansible Installation
Ensure Ansible is installed on your local machine by checking its version:
```sh
ansible --version
```

#### 4. Execute the Ansible Playbook
Run the following command to start the Ansible playbook execution:
```sh
ansible-playbook -i inventory/inventory.yml tasks/main.yml
```

Wait a few minutes for Ansible to complete the installation and configuration process.


### Trigger Deployment with GitHub Actions
In the special-palm-tree GitHub repository, update the inventory.yml file and push your changes to the master branch. This will automatically trigger the GitHub Actions workflow, which runs the Ansible role to deploy to the remote target nodes.

Note: Ensure the SSH_PRIVATE_KEY repository secret is updated with the contents of your local ~/.ssh/id_rsa file. This ensures the GitHub Actions workflow can execute the Ansible playbook without errors.

### Important Note
For the user management tasks, SSH keys have been pre-generated:

* Private Key: files/id_ed25519
* Public Key: files/id_ed25519.pub

These keys are included as part of the Ansible deployment. Please use these keys when logging in as the devops or bob user.

