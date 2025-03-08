# KUBERNETES SECURITY
===================================================

# Understanding RBAC in AWS
===============================
    - This is granting access based on  the need to have or principle of least privilege.
        Example:
            User A. An Administrator
                Need admin access to function as Administrator
            User B. A Developer
                Need developer access to developer resources or tools such as:
                    - EC2 Instance
                    - Lambda
                    - Relational Database(RDS)

            Group C. A Security Engineering Team
                Need acccess to read logs and configuration tools such as:
                    - AWS Cloudtrail
                    - AWS Guard duty 
                    - Security Hub

            Resources D. A EC2 Instance
                Need access to send logs or data to S3 Bucket.

            
# Kubernetes Security for Applications
Core components of kubernetes security
    - RBAC
        * Authorization mechanism for managing permission around k8s resources.
        * RBAC allows configuration of flexible authorization policy that can be updated without restarting the k8s cluster
        * When you create a role, you have to specify the namespace where it belongs in

    - IRSA( IAM Role for Service Accounts)
        * Creating an IAM Roles specific for workloads requirement in K8s 
        * Allow to grant fine grain permission at the pod level isstead of at node level.

    - ClusterRole
        * Contains roles that represent a set of permissions
        * A none namespace resources
        * Used to create a permission for none namespace resources. 
        * If you want to define a permission within a namespace, use role but if you want to defined a role cluster-wide, use clusterrole

    - ClusterRoleBinding
        * Grant permission defined in a role to a user or set of users.
        * It hold a list of subjects such as users, groups or service account and a reference to the role being granted. 
        * Grant access cluster-wide.

    - RoleBinding
        * A Rolebinding Grant permission within a specific namespace. 
        * May reference any role in the same namespace
        * A Rolebinding can reference a clusterRole and bind cluster role to the namespace of the rolebinding


# Understanding AWS-IAM-Autenticator
    Enable AWS Resources to use it AWS Role to authenticate
   
    a. edit the kube-system config/aws-auth
        kubectl edit -n kube-system configmap/aws-auth

          mapUsers: |
            - userarn: arn:aws:iam::357225030460:user/terraform
            username: <username>
            groups:
                - system:nodes

    b. Use eksctl create iamidentitymapping command

eksctl create iamidentitymapping \
    --cluster dev-cluster \
    --region us-east-1 \
    --arn arn:aws:sts::357225030460:assumed-role/eks \
    --group system:masters \
    --username eks

# Working With RBAC
  a. Granting Admin Access to User
  b. Granting RBAC to User

  # Granting Admin Access to user
    Follow this steps to grant admin access to users
    a. Create IAM User
    b. Map Users to K8s Role
        - Retrive the list of the configuration file to see you have aws-auth using this command:
            kubectl -n kube-system get cm
        - Get the content of the aws-auth authentication configuration in aws-auht.yaml file with this command:
            kubectl -n kube-system get cm aws-auth -o yaml > aws-auth.yaml

        - Add a new user or role to the aws-auth yaml file using the format below:          
            mapUsers:  |
                - groups:
                    - system:masters
                    userarn: arn:aws:iam::357225030460:user/eks
                    username: eks
       - add changes to the aws-auth using:
            kubectl apply -n kube-system -f <aws-auth-file-name> or
            kubectl edit cm -n kube-system aws-auth -o yaml
       - Verify that new user has been added:
            kubectl get cm -n kube-system -o yaml
            kubectl describe cm -n kube-system

    c Test the use access to see it works:
        - Switch to the user using aws configure
        - kubectl get pods
        - kubectl get nodes


# Granting RBAC access to User for a dedicated Namespace
  Follow this steps to grant namespace restricted access
  a. Create Namespace
     - Create a namespace
        - kubectl create namespace rancher
     - Confirm the namespace using:
        kubectl get namespaces
  b. Crete IAM User
  c. Create a Role and Rolebinding
     - Follow the steps to create K8s Role
       - Create a role.yaml file
       - Apply the role using:  kubectl apply -f role.yaml
     - Follow the steps to create Rolebinding. That is bind role and users:
       - Create a rolebinding.yaml file
       - Apply the role using:
            kubectl apply -f rolebinding.yaml
  d. Map users to K8s Role
        Follow this steps to updated the configmap to map the user and the role
        a. open the configmap
           kubectl -n kube-system get cm aws-auth -o yaml > aws-auth.yaml
        b. add new users to the configmap
        c. apply the changes:
            kubectl apply -f aws-auth.yaml
           
  e. Test Setup

# Understanding Role Policy
  The Role Policy Array contains 3 main things:
    a. apiGroups
    b. Resources
    c. verb

# apiGroups
The apiGroups field specifies the API group which the resource you want to grant access to belongs. 
    use the following commands to see the group a resources belong to
    kubectl api-resources  or kubectl api-versions
    - Some resources belong to the core group which is v1. For those resources use [""] to declare there apiGroups
    Example:
        a. For Pod
            apiGroups: [""]
        b. For Deployment
            apiGroups: ["app"]
     

# Resources
The resources field specifies which Kubernetes objects the role applies to. 
    use this command to get all resources
    kubectl api-resources  or
    use this command to get a specific resource
    kubectl get <resource-name> --all-namespaces
    E.g
    a.Pod  
        resources: ["pod"]
    b. Deployment
        resources: ["Deployment"]
    c. all
        resources: ["*"]


# Verb
The verbs field defines what actions the role can perform on the specified resources. Common verbs include:
   - Read-only access: "get", "list", "watch"
   - Write access: "create", "update", "patch", "delete"
   - All actions: "*"
   Example:
    For Read Only:
        verbs: ["get", "list", "watch"]
    For Write-Access:
        verbs: ["create", "update", "patch", "delete"]
    For All:
        verbs: ["*"]


# Rolebinding
A role binding grants the permissions defined in a role to a user or set of users.
- It holds a list of subjects (users, groups, or service accounts), and a reference to the role being granted.
- RoleBinding grants permissions within a specific namespace
- A RoleBinding may reference any Role in the same namespace
- RoleBinding can reference a ClusterRole and bind that ClusterRole to the namespace of the RoleBinding.

