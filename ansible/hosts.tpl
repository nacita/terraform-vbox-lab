[linux]
%{ for ip in vm_addresses ~}
${ip}
%{ endfor ~}

[linux:vars]
ansible_user=student
ansible_password=student
ansible_port=22
