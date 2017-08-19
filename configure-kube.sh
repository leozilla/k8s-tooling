#!/usr/bin/env bash

cp -R ./minikube ~/.minikube/

kubectl config set clusters.cluster.certificate-authority ~/.minikube/ca.crt
kubectl config set clusters.cluster.server https://192.168.99.101:8443

kubectl config set contexts.context.cluster minikube
kubectl config set contexts.context.user minikube

kubectl config set current-context [ minikube ]

kubectl config set users.name minikube
kubectl config set users.user.client-certificate ~/.minikube/apiserver.crt
kubectl config set users.user.client-key ~/.minikube/apiserver.key

kubectl config set-context minikube