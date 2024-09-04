minikube delete --all && \
#minikube start --cpus=6 --memory=20G --disk-size=120G --driver=hyperkit && \
#minikube start --cpus=6 --memory=12G --disk-size=120G --driver=qemu --network=socket_vmnet && \

minikube start --cpus=6 --memory=12G --disk-size=60G --driver=docker

#podman machine init
#podman machine start
#minikube start --cpus=6 --disk-size=60G --driver=podman --container-runtime=containerd --rootless=true

minikube addons enable ingress
#minikube addons enable ingress-dns
#minikube addons enable metrics-server

#minikube ssh "sudo sysctl fs.inotify.max_user_watches=1048576"
#minikube ssh "sudo apt-get update && sudo apt-get -y install qemu-user-static"
#minikube stop
#minikube start
