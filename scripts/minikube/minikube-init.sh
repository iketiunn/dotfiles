minikube delete --all && \
minikube start --driver=hyperkit --container-runtime=docker --cpus=6 --memory=12G --disk-size=100G && \
minikube addons enable ingress
minikube ssh docker pull bitnami/keycloak:12.0.4-debian-10-r52 # incase your network sucks
