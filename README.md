# W9 Observability - Terraform Setup

## Quick Start

### 1. Cấu hình

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
```

Sửa `terraform.tfvars`:
```hcl
alert_email   = "your-real-email@gmail.com"
aws_region    = "ap-southeast-1"
instance_type = "t2.micro"
key_name      = "your-key-pair"  # để "" nếu không cần SSH
```

### 2. Deploy

```bash
terraform init
terraform plan
terraform apply
```

> ⚠️ Sau khi apply, check email để **confirm SNS subscription**.

### 3. Verify CloudWatch Agent

SSH vào EC2 (hoặc dùng SSM Session Manager):

```bash
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -m ec2 -a status
```

### 4. Trigger CPU Alarm (Stress Test)

```bash
stress --cpu 2 --timeout 600
```

Sau ~5 phút, CloudWatch Alarm chuyển sang state `ALARM` → email notification gửi qua SNS.

### 5. Cleanup

```bash
terraform destroy
```

---

## Evidence Screenshots

### Bài 2: CPU Alarm → Email Alert via SNS

#### 2.1 SNS Topic Created
![SNS Topic](./evidence/sns-topic.png)

#### 2.2 SNS Email Subscription Confirmed
![SNS Subscription](./evidence/sns-subscription-confirmed.png)

#### 2.3 CloudWatch Alarm - Configuration
![CW Alarm Config](./evidence/cloudwatch-alarm-config.png)

#### 2.4 CloudWatch Alarm - In ALARM State
![CW Alarm Triggered](./evidence/cloudwatch-alarm-triggered.png)

#### 2.5 Email Notification Received
![Email Alert](./evidence/email-notification.png)

---

### Bài 3: Installing CloudWatch Agent on EC2

#### 3.1 CloudWatch Agent Installed
![CW Agent Install](./evidence/cw-agent-installed.png)

#### 3.2 CloudWatch Agent Config
![CW Agent Config](./evidence/cw-agent-config.png)

#### 3.3 CloudWatch Agent Running (Status)
![CW Agent Status](./evidence/cw-agent-status.png)

#### 3.4 CloudWatch Metrics - CWAgent Namespace
![CW Metrics](./evidence/cw-agent-metrics.png)

---

## Cấu trúc

```
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── userdata.sh
│   └── terraform.tfvars.example
├── evidence/             ← screenshots go here
│   ├── sns-topic.png
│   ├── sns-subscription-confirmed.png
│   ├── cloudwatch-alarm-config.png
│   ├── cloudwatch-alarm-triggered.png
│   ├── email-notification.png
│   ├── cw-agent-installed.png
│   ├── cw-agent-config.png
│   ├── cw-agent-status.png
│   └── cw-agent-metrics.png
└── README.md
```
