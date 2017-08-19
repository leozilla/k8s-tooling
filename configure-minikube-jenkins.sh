#!/usr/bin/env bash

cp -R .minikube /var/lib/jenkins/
cp -R .minikube /home/jenkins/

kubectl config set clusters.cluster.certificate-authority /var/lib/jenkins/.minikube/ca.crt
kubectl config set clusters.cluster.server https://192.168.99.101:8443

kubectl config set users.name minikube
kubectl config set users.user.client-certificate /var/lib/jenkins/.minikube/apiserver.crt
kubectl config set users.user.client-key /var/lib/jenkins/.minikube/apiserver.key

kubectl config set-context minikube