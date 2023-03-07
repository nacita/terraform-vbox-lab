terraform {
  required_providers {
    virtualbox = {
      source  = "shekeriev/virtualbox"
      version = "0.0.4"
    }
  }
}

provider "virtualbox" {
  delay      = 60
  mintimeout = 5
}

resource "virtualbox_vm" "lab-vm" {
  count  = length(var.hostname)
  name   = var.hostname[count.index]
  image  = var.vm_template
  cpus   = var.cpu
  memory = var.memoryMB
  # user_data will be deprecated soon, so disabled for this
  # user_data = file("${path.module}/user_data") 

  network_adapter {
    type           = var.interfaceType
    device         = "IntelPro1000MTDesktop"
    host_interface = var.hostInterface
    # On Windows use this instead
    # host_interface = "VirtualBox Host-Only Ethernet Adapter"
  }

  provisioner "remote-exec" {
    inline = ["sudo apt update", "sudo apt install python3 -y", "sudo hostnamectl set-hostname ${self.name}"]

    connection {
      host     = self.network_adapter.0.ipv4_address
      type     = "ssh"
      user     = "student"
      password = "student"
      # private_key = file(var.pvt_key)
    }
  }

}

# generate inventory file for Ansible
resource "local_file" "hosts_cfg" {
  depends_on = [
    virtualbox_vm.lab-vm
  ]
  filename             = "./ansible/inventory"
  directory_permission = 0644
  file_permission      = 0755
  content = templatefile("${path.module}/ansible/hosts.tpl",
    {
      vm_addresses = virtualbox_vm.lab-vm.*.network_adapter.0.ipv4_address
    }
  )

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i './ansible/inventory' --become-user root ./ansible/playbook.yml"
  }

}




output "IPAddress" {
  value = zipmap(virtualbox_vm.lab-vm.*.name, virtualbox_vm.lab-vm.*.network_adapter.0.ipv4_address)
}