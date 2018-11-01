## Yolt Demo app

This Demo will run a simple python application that print a value mapped from Kubernetes ConfigMap

The docker image used is `flamarion/myapp:beta` and Docker file used to create the image is also available in this repository

### Preparation

It has been tested with Minikube, so take a look at how to install and run minikube here:

https://github.com/kubernetes/minikube/blob/v0.30.0/README.md

It's necessary to have Terraform installed as well, so follow this link to install the terraform

https://www.terraform.io/intro/getting-started/install.html

### Usage

After installed and the cluster running, get the configuration which you'll need to connect to the cluster and set the terraform provider properlly

```
kubectl config get-contexts
CURRENT   NAME       CLUSTER    AUTHINFO   NAMESPACE
*         minikube   minikube   minikube
```

In `main.tf` set the following properties according the results which you get from `get-contexts`

```
provider "kubernetes" {
  config_context_auth_info = "minikube"
  config_context_cluster   = "minikube"
}
```

After that, follow the steps below to init, validate, plan and apply the terraform configuration in order to deploy the application

**terraform init**

```
terraform init
```

**terraform validate**
```
terraform validate
```

**terraform plan**

```
terraform plan -out demo-app.plan
```

**terraform apply**

Finally, apply the plan previously created

```
terraform apply demo-app.plan
```

**I'm using the state file locally for test purposes, but I'm aware that good practice is storing it in a S3 Bucket, Azure Blob Container, Consul or any other backend supported**

These commands will create the following components in your Minikube cluster

- namespace: demo-app-ns
- replication controller: pod-demo-app
- service: service-demo-app
- configmap: cm-demo-app

You can scale out the pods changing the `replica_count` variable number in `variables.tf`

To query each the resources created you can use the following commands

```
# NameSpaces
kubectl get namespaces
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

# Repplication Controller
kubectl get replicationcontrollera -n demo-app-ns
kubectl describe replicationcontrollera -n demo-app-ns
```

To access the the application you can use the following command

`minikube service -n demo-app-ns service-demo-app`

This application is accessing the value assigned to the `app_name` key configured in ConfigMap `cm-demo-app`.

To destroy the whole resources created you can perform the following command:

```
terraform destroy
```
