## Yolt Demo app

This Demo will run a simple python application that print a value mapped from Kubernetes ConfigMap

The docker image used is `flamarion/myapp:beta` and Docker file used to create the image is also available in this repository

### Preparation

It has been tested with Minikube, so take a look at how to install and configure minikube here:

https://kubernetes.io/docs/tasks/tools/install-minikube/

It's necessary to have Terraform installed as well, so follow this link to install the terraform

https://www.terraform.io/intro/getting-started/install.html

### Usage

After installed and the cluster running, get the configuration which you'll need to connect to the cluster

```
cat ~/.kube/config
apiVersion: v1
clusters:
- cluster:
    certificate-authority: /Users/fjorg1/.minikube/ca.crt
    server: https://192.168.99.100:8443
  name: minikube
contexts:
- context:
    cluster: minikube
    user: minikube
  name: minikube
current-context: minikube
kind: Config
preferences: {}
users:
- name: minikube
  user:
    client-certificate: /Users/fjorg1/.minikube/client.crt
    client-key: /Users/fjorg1/.minikube/client.key
```

After that, follow the steps below:

**terraform init**

```
terraform init
```

**terraform plan**

In my case, I'm going to use the values from the `~/.kube/config` file, replace by yours:

```
terraform plan -var 'cluster_ip=https://192.168.99.100:8443' \
  -var 'client_cert=~/.minikube/client.crt' \
  -var 'client_key=~/.minikube/client.key' \
  -var 'ca_crt=~/.minikube/ca.crt' \
  -out demo-app.plan
```

**terraform apply**

Finally, apply the plan previously created

```
terraform apply demo-app.plan
```

**I'm using the state file locally for test purposes, but I'm aware that good practice is storing it in a S3 Bucket, Azure Blob Container, Consul or any other backend supported**

These commands will create the following components in your Minikube cluster

- namespace: demo-app-ns
- pod: pod-demo-app-1
- service: service-demo-app-1
- configmap: cm-demo-app-1

To query each one of the services created you can use the following commands


```
# NameSpaces
kubectl get namespaces
kubectl describe namespace demo-app-ns

# Pods
kubectl get pod -n demo-app-ns pod-demo-app-1
kubectl describe pod -n demo-app-ns pod-demo-app-1

# Services
kubectl get service -n demo-app-ns service-demo-app-1
kubectl describe service -n demo-app-ns service-demo-app-1

# ConfigMaps
kubectl get configmap -n demo-app-ns cm-demo-app-1
kubectl describe configmap -n demo-app-ns cm-demo-app-1
```

To access the service you can use the following command

`minikube service -n demo-app-ns service-demo-app-1`
