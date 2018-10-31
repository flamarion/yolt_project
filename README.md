## Yolt Demo app

This Demo will run a simple python application that print a value mapped from Kubernetes ConfigMap

The docker image used is `flamarion/myapp:beta`

### Preparation

It has been tested with Minikube for a while, so take a look how to install and configure minikube here:

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

In my case, I'm going to use the values from the `kube/config` file, replace by yours:

```
terraform plan -var 'cluster_ip=https://192.168.99.100:8443' -var 'client_cert=/Users/fjorg1/.minikube/client.crt' -var 'client_key=/Users/fjorg1/.minikube/client.key' -var 'ca_crt=/Users/fjorg1/.minikube/ca.crt'
```

**terraform apply**

Finally, apply the plan previously created

```
terraform plan -var 'cluster_ip=https://192.168.99.100:8443' -var 'client_cert=/Users/fjorg1/.minikube/client.crt' -var 'client_key=/Users/fjorg1/.minikube/client.key' -var 'ca_crt=/Users/fjorg1/.minikube/ca.crt'
```

These commands will create the following components in your Minikube cluster

- namespace: demo-app-ns
- pod: pod-demo-app-1
- service: service-demo-app-1
- configmap: cm-demo-app-1

To query each one of the services created you can use the following commands

```
# Name space
kubectl describe namespace demo-app-ns

# Pods
kubectl get pods -n demo-app-ns
kubectl describe pods -n demo-app-ns

# Services
kubectl get services -n demo-app-ns
kubectl describe services -n demo-app-ns

# ConfigMaps
kubectl get configmaps -n demo-app-ns
kubectl describe configmaps -n demo-app-ns
```


To check
