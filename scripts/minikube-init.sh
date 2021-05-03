minikube delete --all && \
minikube start --cpus 4 --memory 16384 && \
minikube addons enable ingress && \
kubectl delete -A ValidatingWebhookConfiguration ingress-nginx-admission # bug from ...

