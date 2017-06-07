CoreOS Update server

This server makes sure coreos only runs the version you want

First add the ip address to the CoreOS server to grab the update from
```
# cat /etc/coreos/update.conf
SERVER=http://10.50.22.22:9000/1235.6.0/
GROUP=stable
```

Next, trigger an update
```
$ sudo systemctl unmask update-engine.service
$ sudo systemctl start update-engine.service
$ update_engine_client -check_for_update
```

# Note: Make sure to use overlay as storage driver for now

# Install ISO, OVA etc can be found at
https://stable.release.core-os.net/amd64-usr/1235.6.0/
