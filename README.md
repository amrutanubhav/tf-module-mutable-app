# tf-module-mutable-app

This contains the code related to spin up the ec2 instances needed to host the backend components. This module is called from the respective components. This is the backend module.

strategy is as below:
>create ec2 instance <half spot and half on demand>
>Install application component inside it <ansible playbook>
>create target group
>attach TG to an ALB
>DNS record to ALB