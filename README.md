# Preparing VirtualBox LAB with terraform

Bagaimana cara menggunakan repo ini? berikut langkah-langkahnya secara singkat

## Install beberapa dependency berikut

```bash
sudo apt install python3-pip sshpass 
# install ansible
sudo pip3 install -r ansible/requirement.txt
# install terraform
cd /tmp
wget https://releases.hashicorp.com/terraform/1.3.9/terraform_1.3.9_linux_amd64.zip
unzip terraform_1.3.9_linux_amd64.zip
sudo mv terraform /usr/local/bin/terraform
```

## eksekusi

```bash
terraform init
terraform plan
terraform apply
```

> catatan: dokumentasi lengkapnya menyusul ya, kalo sempat nulis :)

# Known Issue

- belum support NAT network
- belum support multiple network interface
