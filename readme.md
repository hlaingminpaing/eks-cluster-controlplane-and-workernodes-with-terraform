# How to implement EKS cluster with terraform

Firstly create vpc,eks-cluster, worker-node and addons, comment for alb-controller module in root main.tf

## Initialize the terraform

```sh
terraform init
terraform plan
terraform apply
```
After created vpc,eks-cluster, worker-node and addons, uncomment for alb-controller module in root main.tf and run again 

## After created the cluster you can access this way

```sh
aws eks update-kubeconfig --name <your-cluster-name> --region <your-region>
kubectl get nodes
```