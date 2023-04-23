# tf-module-mutable-app

common backend module for all backend components

strategy is as below:
>create ec2 instance <half spot and half on demand>
>Install application component inside it <ansible playbook>
>create target group
>attach TG to an ALB
>DNS record to ALB