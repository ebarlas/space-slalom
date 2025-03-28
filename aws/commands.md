```
aws ecs create-cluster \
--region us-west-1 \
--cluster-name space-slalom-cluster
```

```
amzn2-ami-ecs-hvm-2.0.20250321-arm64-ebs
ami-02199054a59591d93
```

```
base64 -i user-data.sh > user-data.b64
```

```
aws ec2 create-launch-template \
--region us-west-1 \
--launch-template-name space-slalom-template \
--version-description "Initial version" \
--launch-template-data file://launch-template.json
```

```
aws ec2 create-key-pair \
--region us-west-1 \
--key-name space-slalom-key \
--query 'KeyMaterial' \
--output text > space-slalom-key.pem
chmod 400 space-slalom-key.pem
```

```
aws ec2 create-security-group \
--region us-west-1 \
--group-name space-slalom-sg \
--description "Allow HTTP and WebSocket access for Space Slalom"
aws ec2 authorize-security-group-ingress \
--region us-west-1 \
--group-name space-slalom-sg \
--protocol tcp --port 3000 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress \
--region us-west-1 \
--group-name space-slalom-sg \
--protocol tcp --port 80 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress \
--region us-west-1 \
--group-name space-slalom-sg \
--protocol tcp --port 443 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress \
--region us-west-1 \
--group-name space-slalom-sg \
--protocol tcp --port 22 --cidr 0.0.0.0/0
```

```
aws ec2 run-instances \
--region us-west-1 \
--launch-template LaunchTemplateName=space-slalom-template \
--key-name space-slalom-key \
--security-groups space-slalom-sg
```

```
aws ecr create-repository \
--region us-west-1 \
--repository-name space-slalom
```

```
aws ecr get-login-password --region us-west-1 | docker login --username AWS --password-stdin 394119789999.dkr.ecr.us-west-1.amazonaws.com
docker build -t space-slalom .
docker tag space-slalom:latest 394119789999.dkr.ecr.us-west-1.amazonaws.com/space-slalom:latest
docker push 394119789999.dkr.ecr.us-west-1.amazonaws.com/space-slalom:latest
```

```
aws ecs register-task-definition \
--region us-west-1 \
--cli-input-json file://space-slalom-task.json
```

```
aws ecs create-service \
--region us-west-1 \
--cluster space-slalom-cluster \
--service-name space-slalom-service \
--task-definition space-slalom-task:3 \
--desired-count 1 \
--launch-type EC2
```

```
aws ecs update-service \
--region us-west-1 \
--cluster space-slalom-cluster \
--service space-slalom-service \
--task-definition space-slalom-task:3 \
--force-new-deployment \
--deployment-configuration minimumHealthyPercent=0,maximumPercent=100
```

```
aws route53 change-resource-record-sets \
--hosted-zone-id Z3C4OVAPZYSKDP \
--change-batch file://record-set.json
```