# use ssh to execute mosh-server and get the shared key to let mosh to connect
mosh --ssh="ssh -p 22" minipc@192.168.50.140 --server="env LANG=c.UTF-8 mosh-server"
