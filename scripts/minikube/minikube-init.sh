minikube delete --all && \
minikube start --vm-driver=hyperkit --cpus=4 --memory=4096 --disk-size=20G && \
minikube addons enable ingress
#minikube ssh docker pull bitnami/keycloak:12.0.4-debian-10-r52 # incase your network sucks
