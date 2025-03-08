# aws eks create-cluster --region $region --name $cluster_name --kubernetes-version $kubernetes_Version \
#    --role-arn $cluster_Iam_role \
#    --resources-vpc-config subnetIds=$subnet_ExampleID1,$subnetExampleID2,securityGroupIds=$sg_ExampleID1



# Common Command for Clusters:
# ================================

# Ceate a new cluster:
   a. aws eks create-cluster --region us-east-1 --name rancher --kubernetes-version 1.32 \
      --role-arn arn:aws:iam::357225030460:role/eksctl-staging-cluster-ServiceRole-37k1OOnQMUbM \
      --resources-vpc-config subnetIds=subnet-093594b833c89616f,subnet-03cdbca5c5504f0a9,securityGroupIds=sg-0eb951d8d2d5e789b

   b. eksctl create cluster --name $cluser-name --region $region --version 1.31 --vpc-private-subnets $subnet-id1,$subnet-id2 --managed


# List existing cluster
      aws eks list-clusters

#  update kube config
aws eks update-kubeconfig --region region-code --name Cluster_name


# create Nodegroup

eksctl create nodegroup \
  --cluster my-cluster \
  --region region-code \
  --name my-mng \
  --node-ami-family ami-family \
  --node-type m5.large \
  --nodes 3 \
  --nodes-min 2 \
  --nodes-max 4 \
  --ssh-access \
  --ssh-public-key my-key

  
eksctl create nodegroup \
  --cluster dev-cluster \
  --region us-east-1 \
  --name dev1 \
  --node-type t2.micro \
  --nodes 1 \
  --nodes-min 1 \
  --nodes-max 4 \
  --ssh-access \
  --ssh-public-key terraform \
  --subnet-ids subnet-05112cd245227fc6a,subnet-0570e6017fb0218f2 \
  --privateNetworking true


eksctl create iamidentitymapping \
  --cluster dev-cluster \
  --region us-east-1 \
  --arn arn:aws:iam::357225030460:user/yemi@thecornelis.com \
  --group system:masters \
  --username yemi@thecornelis.com


# Scaling nodegroups up or down
eksctl scale nodegroup \
  --cluster public \
  --nodes 3 \
  --nodes-max \
  --name unprivate


# General Secret Yaml file 

kubectl create secret docker-registry docker-registry-secret \
  --docker-server=https://index.docker.io/v1/ \
  --docker-username=your-dockerhub-username \
  --docker-password=your-dockerhub-password \
  --docker-email=your-email@example.com \
  --dry-run=client -o yaml > secret.yaml

