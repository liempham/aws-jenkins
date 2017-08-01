#!/bin/bash

#careful
instance_count=1
instance_type="t2.small"

#NOTE: Ubuntu Linux's AMI ID is per region. This works on Singapore. 
#Ubuntu Server 16.04 LTS (HVM)
ami_image_id="ami-6f198a0c"

#change to match your keypair & SG
keypair_name="your-keypair-name"
security_group_name="your-sg-name"

echo "Starting a new EC2 instance for Jenkins..."
echo "Instance type : " $instance_type
#aws ec2 describe-images --image-ids ami-6f198a0c

aws ec2 run-instances --image-id $ami_image_id \
  --count $instance_count \
  --key-name $keypair_name  \
  --security-groups $security_group_name \
  --instance-type $instance_type \
   --block-device-mappings file://block-mapping.json --user-data file://setup_jenkins_https.sh

#describe instance details
echo "aws ec2 describe-instances --instance-ids <instance_ids>"
echo "ssh -i <keypem-file> ubuntu@public-ip"

#elastic ip - get public IP & allocation ID
echo "Assign Elastic IP to you instance if needed"
echo " aws ec2 allocate-address --domain vpc"
echo " aws ec2 associate-address --instance-id <instance-id> --allocation-id <allocation-id>"
