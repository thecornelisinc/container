# Understanding ROle Based Access Control
# Kubernetes secritiy for application
# Configguring Kubeconfig
# Understanding AWS-IAM-Authenticator
# Granting Admin Privileges to Other Users
# Granting Custom Privileges to Other Users using RBAC


# Granting Admin Privileges to Other Users
To add new users:
    - Edit the configmap file with the below command: 
        kubectl get configmap aws-auth -n kube-system -o yaml > aws-auth.yaml
    - add new users. See example below


        apiVersion: v1
        kind: ConfigMap
        metadata:
        name: aws-auth
        namespace: kube-system
        data:
        mapRoles: |
            - rolearn: arn:aws:iam::ACCOUNT_ID:role/EKSNodeRole
            username: system:node:{{EC2PrivateDNSName}}
            groups:
                - system:bootstrappers
                - system:nodes
        mapUsers: |                                                     ===> New users starts from here
            - userarn: arn:aws:iam::ACCOUNT_ID:user/YourUserName       
            username: YourUserName
            groups:
                - system:masters                                        ===> New users ends from here


    - apply changes with the below command
        kubectl apply -f aws-auth.yaml



# Granting Custom Privileges to Other Users using RBAC