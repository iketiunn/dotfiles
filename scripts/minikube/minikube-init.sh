minikube delete --all && \
minikube start --cpus=6 --memory=8G --disk-size=120G && \
minikube addons enable ingress

minikube ssh "sudo sysctl fs.inotify.max_user_watches=1048576"

# For mac
echo "Going to increase inotify limit on MacOS..."
minikube ssh sudo sysctl fs.inotify.max_user_watches=1048576
