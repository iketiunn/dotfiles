minikube delete --all && \

minikube start --cpus=6 --memory=12G --disk-size=60G --driver=docker

minikube addons enable ingress
#minikube addons enable ingress-dns
#minikube addons enable metrics-server

minikube ssh "sudo sysctl fs.inotify.max_user_watches=1048576"
minikube ssh "sudo sysctl fs.inotify.max_user_instances=256"
