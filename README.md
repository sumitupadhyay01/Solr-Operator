# Configure Solr Operator in Azure Kubernetes Service

## Prerequisites
- Install Azure CLI

## Quickstart
- run `.\azlogin.ps1` to login az cli to the right subscription
- run `.\deploy-registry.ps1 -acrName sugacr` to create an Azure Container Registry

#### Deploy Azure Kubernetes Cluster

```
.\deploy-akscluster.ps1 -env prd -prefix sitecore -acrname sugacr

az aks get-credentials --resource-group sitecore-infra --name sitecore-aks

kubelogin convert-kubeconfig -l azurecli
```

#### Add the Solr Operator Helm repository. (You should only need to do this once)
```
helm repo add apache-solr https://solr.apache.org/charts`
helm repo update
```

#### Install Solr Operator chart (ZooKeeper is installed by default)
```
# Install the Solr & Zookeeper CRDs

kubectl create -f https://solr.apache.org/operator/downloads/crds/v0.7.1/all-with-dependencies.yaml

kubectl get crds

# Create the namespace where the solr operator will be installed
kubectl create ns solr-operator

helm install solr-operator apache-solr/solr-operator --version 0.7.1 --namespace solr-operator -f .\solr-operator\solroperatorvalues.yaml
```
#### Install SolrCloud
```
# Create the namespace where SolrCloud will be installed
kubectl create ns solr

helm install solr apache-solr/solr --version 0.7.1 --namespace solr -f .\solr-operator\solrcloudvalues.yaml
``` 

#### Populate Solr indexes
```
kubectl apply -f .\solr-operator\solr-init.yaml
```

#### Resources:
- https://solr.apache.org/operator/resources.html
- https://apache.github.io/solr-operator/docs/running-the-operator.html 
- https://github.com/apache/solr-operator#solr-operator
- https://blog.jermdavis.dev/posts/2022/solr-operator-kubernetes