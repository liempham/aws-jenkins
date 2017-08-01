# aws-jenkins
Use this script to setup Jenkins via AWS Cloud Init. You will have a new Jenkins with HTTPs access after a few minutes (~2 minutes on a t2.small)

Assumption:
- Ubuntu AMI
- VPC security group: port 80 & 443 open to public (0.0.0.0/0). You will need port 22 for getting the initial password; another way to get this is via EC2 Instance Settings > Get System Log

Input: 
- Change your domain name in the script
- Setup valid SSL cert if needed
