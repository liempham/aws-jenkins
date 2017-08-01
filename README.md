# aws-jenkins
Use this script to setup Jenkins via AWS Cloud Init. You will have a new Jenkins behind a reversed proxy with HTTPs access after a few minutes (~2 minutes on a t2.small)
Options:
- Create EC2 instance automatically
- Put the script manually into cloud init when creating new EC2 instance

Assumption:
- Ubuntu AMI
- VPC security group: port 80 & 443 open to public (0.0.0.0/0). You will need port 22 for getting the initial password; another way to get this is via EC2 Instance Settings > Get System Log
- If creating EC2 instance automatically:
 Default region: Singapore. Please update AMI ID and block snapshot ID if using other regions or AMI.
 -> prepare your keypair and security in advance, then update it in create-ec2-instance.sh

Input:
- Change your domain name in the script
- Setup valid SSL cert if needed
