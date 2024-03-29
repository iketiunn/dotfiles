minikube delete --all && \
#minikube start --cpus=6 --memory=20G --disk-size=120G --driver=hyperkit && \
minikube start --kubernetes-version=v1.23.17 --image-repository=auto --cpus=6 --memory=20G --disk-size=120G --driver=hyperkit && \
minikube addons enable ingress
minikube addons enable metrics-server

minikube ssh "sudo sysctl fs.inotify.max_user_watches=1048576"

# For mac
echo "Going to increase inotify limit on MacOS..."
minikube ssh sudo sysctl fs.inotify.max_user_watches=1048576
