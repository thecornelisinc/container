
# Kubernetes
    - Cluster
        * Control Plane 
            - Kube-ApiServer : The front-end for the Kubernetes control plane that exposes the Kubernetes API.
            - etcd : A consistent and highly-available key-value store used as Kubernetes’ backing store for all cluster data.
            - kube-scheduler: Responsible for assigning pods to nodes based on resource availability, policies, and constraints.
            - kube-control-manager: Runs controller processes that handle routine tasks such as replication, node management, and endpoint management.
            - cloud-controller-manager(optional): Manages interactions with the underlying cloud provider (only needed when running in a cloud environment).
        * Worker Node
            - kubelet: An agent running on each node that ensures containers are up and running as defined in the Pod specs.
            - kube-proxy: Handles network proxying and load balancing, maintaining network rules to allow communication to and from pods.
            - Container Runtime: The software responsible for running containers (e.g., Docker, containerd, or others).

# Kubernetes tools installation
    - kubectl
    - aws cli
    - eksctl

# Useful documentation links

    - Kubernetes main Documentation
        https://kubernetes.io/docs/home/

    - Kubernetes API
        https://kubernetes.io/docs/reference/kubernetes-api/
        https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.32/

    - eksctl documentation
        https://eksctl.io/usage/creating-and-managing-clusters/
        https://github.com/eksctl-io/eksctl/tree/main/examples

    - kubectl API
        https://kubernetes.io/docs/reference/kubectl/generated/
        
    - 
# How to create a cluster
    Follow these steps to create an Elastic Kubernetes cluster in AWS
        - Ensure to have install eksctl ==>  https://eksctl.io/installation/
        - Ensure to have Cluster Role with the following policy created:
            * AmazonEKSServiceRolePolicy
            * AmazonEKSVPCResourceController(Optional)
            * Set the trusted Relation policy to "eks.amazonaws.com"
        - You can use aws eks cli command
            * Examples:
                a. eksctl create cluster 
                b. see one in the commands.sh file 
                c. or use this link https://docs.aws.amazon.com/eks/latest/userguide/create-cluster.html
        - You can also use yaml file with a kind of clusterconfig
            * Examples:
                a. See one in commands.sh
                b. you run this using eksctl create cluster -f <your-yaml-file-name>

        - You can get multiple sample cluster creation here https://github.com/eksctl-io/eksctl/tree/main/examples

# EKS Networking Endpoint
An EKS Cluster Endpoint is the API server endpoint of an Amazon Elastic Kubernetes Service (EKS) cluster. This endpoint is used by kubectl, AWS SDKs, and other Kubernetes tools to communicate with the Kubernetes API server.
There are three endpoints for your EKS Cluster:
    a. Public
       Mean your worker nodes are exposed to the internet. 
    b. Private
       Means you can't expose your application to the internet
    c. Public and Private
       When this is used, the Worker node are deployed in the private subnet which public facing devices like Load Balancer are deployed in the Public Subnet. 

 # Common Command for Clusters:
        a. Ceate a new cluster:
            eksctl create cluster --name $cluser-name --region $region --version 1.31 --vpc-private-subnets $subnet-id1,$subnet-id2 --managed
        b. List existing cluster( CLI)
            aws eks list-clusters


# Generate or update KubeConfig file
    aws eks update-kubeconfig --region region-code --name my-cluster

# Understand KubeConfig File
    This connect kubectl to kubernetes cluster api-server.The file is located in ~/.kube/config
    - if you there is no kube config file, you have to specify ther server, the user and the authentication credentials in the kubectl command such as:
    kubectl get pod \
        --Server name:port \
        --client-key user_name.key \
        --client-certificate user_name.crt \
        --certificate-authority-data <base64 encoded string>
    - The above is how the kubectl know which cluster and api server to talk to. 

    - kubeconfig component are:
        a. Clusters:
            contains:
                * Certificates
                * Server(dns/ip)
                * name
            sample server name:
                a. rancher-eks-cluster
                b. my-dev-cluster
        b. Users
            contains: 
                * name
                * user
                    execs
            sample user name: 
                a. rancher-admin-user
                b. dev-user
        c. Contexts
            The contexts, link the user and the cluster together 
                * cluser
                * user
                * name
            sample context construct: 
            * rancher-admin-user@rancher-eks-cluster
            * dev-user@my-demo-cluster



# view the kube config file 
    kubectl config view

# switching between multiple cluster
    run the following command to switch from one cluster to another
        - kubectl config use-context <context-name>

         
# Kubernetes has a broad set of resources types that organizations can use based on their requirements
    - Pods - 
    - Deployments
    - Services
    - ConfigMap 
    - Secret
    - PersistentVolume
    - PersistentVolumeClaim
    - Ingress
    - NameSpace
    - and many more

    use this command to view k8s cluster resources:
        kubectl api-resources












# Ways to create resources in kubernetes cluster.
    There are multiple ways of creating resources/object in kubernetes:
        a. You can create objects directly using kubectl without needing a YAML file.
            Example:
                - kubectl create deployment nginx --image=nginx [-o yaml] [--dry-run=client]
                  * -o yaml: Retrieve the yaml manifest used to create the object.
                  * --dry-run: Simulates the execution of a command without actually applying it to the cluster.

        b. a. kubectl run nginx --image=nginx   ( for more examples run "kubectl run --help)
            * you can run kubectl with --dry-run=client to validate the kubectl command without applying it to your cluster e.g kubectl run nginx --image=nginx --dry-run=client( will only deploy if it is valid command or not.)
            * use kubectl with -o yaml to get the full manifest used by yaml to create the object.
        b. Manifect yaml file e.g kubectl apply -f /path/to/pod.yaml ( The file must me already created)
        - resource api*

# Introduction to NameSpace
    - Namespaces in Kubernetes allow for logical separation of resources within a cluster
    - They help organize workloads and enforce resource limits.
    - You can create a namespace using kubectl or YAML.
    - Follow this command to create namespace with kubectl
        kubectl create namespace dev
    - See namespace yaml file to create namespace using yaml
    - Run kubectl apply -f namespace.yaml to apply the namespace created in yaml
    - Run kubectl get namespace to get all namespace
    - Default namespace is default
    - Run kubectl describe namespaces <name-of-namespace> to describe namespaces
    - To deply a resource or object in a specific namespace, add the namespace in the metadata of the object. 
       Example:
        apiVersion: v1
        kind: Pod
        metadata:
            name: nginx
            namespace: dev



# Basic structure of Manifest file
    What to include in a manifest file depends on the API specification of the object your are defining. However, every k8s manifest usaully includes:
        - apiVersion: Defines the version of the Kubernetes API to use.
        - kind: Specifies the type of object you are creating (e.g., Pod, Deployment, Service). To get other kinds of resources you can create, run kubectl api-resources
        - metadata: Provides information about resource you are creating like the resource/object's name, namespace, labels, and annotations.
        - spec: Outlines the desired state and configuration of the object, which varies based on the type.
    * use this command to to learn more about each object "kubectl explain <resource>" and kubectl api-resources to get information about the api and the kind

#  Working with label
    - Label help you to indentify or diffenciate objects in kubernetes
    - You can create label using the kubectl cli or in the manifest yaml file. 
    - Below are the few commands for labels:
        - To how objects with their label, add --show-labels flag
        - To add label in kubectl cli e.g kubectl label pod $pod-name key=value
        - To add label to your manifest file, include it in the metadata.label section

# How to get already made manifest yaml file
    - google
    - kubernetes documentation
    - vscode plugins
    - generate using kubectl with -o yaml flag

# How to create multi container Pods
    - To create multiple container in a pod, you can only user manifest yaml file and not kubectl cli
    - In the containers obect session of the manifest file, add the second container to the pod. 
    - To see containers running more than one pod, run kubectl get pods, and check the READY section it will show 2/2. Pod running one container will show 1/1
    - You can also see this by running kubectl describe pods <pod-name>, then look under the containers of the response. 

# Accesing or login into container
    - To connect to the container, you can run:
        - kubectl exec -it <pod-name> -- bash   # 

# Connecting to multiple-container pod
    - If you run more than one container in a pod, by default when you connect to the pod, you will be connect to default container. 
    - However, to connect to a specific container, you include -c $container-name in your command:
        Example:
        kubectl exec -it $pod-name -c $container-name




# Induction to Replicaset
A controller that ensures a specified number of IDENTICAL Pod replicas are running at any given time
    - Use to ensures high availability and fault tolerance
    - Automatically replaces failed Pods.
    - Scales Pods up or down based on defined replicas.
    - you can create a replicaset using kubectl command line or using a manifest file
        * For Kubectl cli
            - kubectl create deployment $deployment-name --image=$image-tag:version --replica=1
                example: kubectl create deployment nginx-replicaset --image=nginx:latest --replicas=3
        * For Manifest file: 
            use this sample: https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/
        ** Recommendation: It is recommended to use deployment to create replicaset or pod.
    - Use the following command to scaleup or down using replicaset
        - kubectl scale replicaset $replica-name --replicas=3
        - kubectl get replicasets


# Challenges with Replicaset
    - ReplicaSets are good for ensuring and maintaining high availability and fault tolerance, they are not meant to updates or change exiting pod configuration
        Examples:
            - If you already used a replicaset to scale up some pod, if you update the pod template used by the replicaset, the update will not apply to already running pods.
    - No Built-in Rollback mechanism
        Examples:
    - Label Collision with Replicaset selectors
        If an already existing pod use have thesame selector Matchlabel with replicaset, replicaset authomatically manage that pod even if it wasn't created by the replicaset. 
        Example: A Pod nginx-container created outside of a replicaset but with a spec.selector.matchlabels.app=Frontend and A replicaset with a with a spec.selector.matchlabels.app=Frontend, the replicaset will automatically continue the managament of the nginx-container pod because of the same spec.selector.matchlabels.app of frontend. To overcome this specific challenge, ensure to have a unique label for the replicaset.

# Introduction to Deployment
    - A Deployment manages a set of Pods to run an application workload, usually one that doesn't maintain state.
    - Deployment manages replicaset and pods
    - It provides advance features like rolling updates, rollbacks and versioning.
    - Use case of Deployment:
        * Create a Deployment to rollout a ReplicaSet
        * Declare the new state of the Pods by updating the PodTemplateSpec of the Deployment
        * Rollback to an earlier Deployment revision if the current state of the Deployment is not stable
            ** To role back to a previous version, you can use these commands:
                - Check the history of the deployment
                    a. kubectl rollout history deployment <deployment-name>
                - If you want to revert to the last successful deployment, use:
                    b. kubectl rollout undo deployment $deployment-name
                - Rollback to a Specific Revision
                    c. kubectl rollout undo deployment <deployment-name> --to-revision=<revision-number>

# Multiple Worker Nodes as part of K8s Cluster
    - Worker node are the node where your pods actually run in the cluster
    - To see the number of worker nodes you currently have, run these command:
        * kubectl get nodes
    - You can select a specific node for your application using:
        a. Node Selector
            * To use node select, first ensure that your node have a specific label. such as env=prod. Use the command to add a label
                - kubectl label nodes <node-name> env=production
            * In the pod creation using deployment or replicaset, use same label as the one your created for the node. 
        
        b. Using nodeName (Direct Assignment)
            * Add the node name to the spec defination of the pods
                pod.spec.nodeName: $Node-Name


# Introduction to K8s Service
   - A Service is a gateway that distributes incoming traffic between a logical set of Pods' endpoints.
   - Since Pods can be created and destroyed dynamically, their IP addresses change. A Service ensures that clients can always reach the application, even if the underlying Pods change.

# Benefits of Service:
    a. It help to prevent direct cummunication between two ephemeral pods
    b. It helps to distribute traffic among pods such as 
        * between clusters
        * From internet to multiple backend pods
    c. This act like a load balancer.

# Type of Services   
   - There are 4 types of Services:
        a. Cluster-IP
        b. NodePort
        c. Load balancer
        d. ExternalName – Maps to an External DNS

# ClusterIP Service
    These is the default and it mainly for Internal Communication. Use to:
    - Exposes the service internally within the cluster.
    - Cannot be accessed from outside the cluster.
    - Used for internal microservices communication.
