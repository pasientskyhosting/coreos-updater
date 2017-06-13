CoreOS Update server

This server makes sure coreos only runs the version you want

```
docker run -d --restart=always --name=coreos-updater -p 9000:80 -e ADDR=10.50.22.22:9000 pasientskyhosting/coreos-updater:latest
```

First add the ip address to the CoreOS server to grab the update from
```
# cat /etc/coreos/update.conf
SERVER=http://10.50.22.22:9000/1353.7.0/
GROUP=stable
REBOOT_STRATEGY=off
```

Next, trigger an update
```
sudo systemctl unmask update-engine.service
sudo systemctl start update-engine.service
sudo update_engine_client -update
```

After reboot, remove the overlay2 folder
```
sudo systemctl stop kubelet
sudo systemctl stop docker
sudo rm -rf /var/lib/docker/overlay2
```

Reboot again

# Make sure overlay is the storage driver
```
rm /etc/systemd/system/docker.service.d/20-docker.conf


# docker info
Containers: 86
 Running: 80
 Paused: 0
 Stopped: 6
Images: 225
Server Version: 1.12.3
Storage Driver: overlay
 Backing Filesystem: extfs
Logging Driver: json-file
Cgroup Driver: cgroupfs
Plugins:
 Volume: local
 Network: null bridge host overlay
Swarm: inactive
Runtimes: runc
Default Runtime: runc
Security Options: seccomp selinux
Kernel Version: 4.7.3-coreos-r2
Operating System: Container Linux by CoreOS 1235.6.0 (Ladybug)
OSType: linux
Architecture: x86_64
CPUs: 8
Total Memory: 29.46 GiB
Name: kube-node03
ID: HWSW:4ZP2:SQZH:KFYQ:AY7Q:KBP6:CKMH:RRHG:GLA5:UE3V:KJ3C:KFTM
Docker Root Dir: /var/lib/docker
Debug Mode (client): false
Debug Mode (server): false
Registry: https://index.docker.io/v1/
Insecure Registries:
 127.0.0.0/8
```

# Install ISO, OVA etc can be found at
https://stable.release.core-os.net/amd64-usr/1235.6.0/
https://stable.release.core-os.net/amd64-usr/1235.6.0/coreos_production_vmware_ova.ova
