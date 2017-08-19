#!/usr/bin/env bash

await() {
    COMMAND=$@

    for i in {1..150} # timeout for 5 minutes
    do
       $COMMAND
       if [ $? -ne 1 ]; then
          break
      fi
      sleep 2
    done
}

if command -v minikube >/dev/null; then
    echo "minikube already present"
else
    curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    chmod +x minikube
fi

if command -v kubectl >/dev/null; then
    echo "kubectl already present"
else
    curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
    chmod +x kubectl
fi

export MINIKUBE_WANTUPDATENOTIFICATION=false
export MINIKUBE_WANTREPORTERRORPROMPT=false
export MINIKUBE_HOME=$HOME
export CHANGE_MINIKUBE_NONE_USER=true

mkdir $HOME/.kube || true
touch $HOME/.kube/config

export KUBECONFIG=$HOME/.kube/config
if [ "$(sudo -E minikube status | head -n 1 )" != "minikube: Running" ]; then
    minikube start --vm-driver=none
fi

# this for loop waits until kubectl can access the api server that minikube has created
await kubectl get po

# kubectl commands are now able to interact with minikube cluster

case "$1" in
    -p)
        registry=$(kubectl get po -n kube-system | grep kube-registry-v0 | awk '{print $1;}')

        if [ $registry ]; then
            echo $registry
        else
            kubectl create -f kube-registry.yaml
        fi

        # see https://blog.hasura.io/sharing-a-local-registry-for-minikube-37c7240d0615
        await kubectl port-forward --namespace kube-system $registry 5000:5000
    ;;
esac