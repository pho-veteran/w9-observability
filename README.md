# W9 Observability - Terraform Setup

### Bài 2: CPU Alarm → Email Alert via SNS

#### 2.1 SNS Topic Created
![SNS Topic](./evidence/sns-topic.png)

#### 2.2 SNS Email Subscription Confirmed
![SNS Subscription](./evidence/sns-subscription-confirmed.png)

#### 2.3 CloudWatch Alarm - Configuration
![CW Alarm Config](./evidence/cloudwatch-alarm-config.png)

#### 2.4 CloudWatch Alarm - In ALARM State

Chạy `stress` trên EC2 để trigger alarm, sau đó kiểm tra status của CloudWatch Agent:

```bash
stress --cpu 2 --timeout 600
```

![Stress Test](./evidence/stress-test.png)
![CW Alarm Triggered](./evidence/cloudwatch-alarm-triggered.png)

#### 2.5 Email Notification Received
![Email Alert](./evidence/email-notification.png)

---

### Bài 3: Installing CloudWatch Agent on EC2

#### 3.1 Verify CloudWatch Agent Installed 

```bash
sudo systemctl status amazon-cloudwatch-agent
```

![CW Agent Install](./evidence/cw-agent-installed.png)

#### 3.2 CloudWatch Agent Config

```bash
cat > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json << 'EOF'
{
  "agent": {
    "metrics_collection_interval": 60,
    "run_as_user": "root"
  },
  "metrics": {
    "namespace": "CWAgent",
    "metrics_collected": {
      "cpu": {
        "resources": ["*"],
        "measurement": [
          "cpu_usage_idle",
          "cpu_usage_user",
          "cpu_usage_system"
        ],
        "totalcpu": true,
        "metrics_collection_interval": 60
      },
      "mem": {
        "measurement": [
          "mem_used_percent",
          "mem_total",
          "mem_used"
        ],
        "metrics_collection_interval": 60
      },
      "disk": {
        "resources": ["/"],
        "measurement": [
          "disk_used_percent"
        ],
        "metrics_collection_interval": 60
      }
    }
  }
}
EOF
```

#### 3.4 CloudWatch Metrics - CWAgent Namespace
![CW Metrics](./evidence/cw-agent-metrics.png)
