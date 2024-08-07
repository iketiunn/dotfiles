minikube delete --all && \
#minikube start --cpus=6 --memory=20G --disk-size=120G --driver=hyperkit && \
minikube start --cpus=6 --memory=12G --disk-size=60G --network=socket_vmnet
minikube addons enable ingress
minikube addons enable metrics-server

minikube ssh "sudo sysctl fs.inotify.max_user_watches=1048576"
