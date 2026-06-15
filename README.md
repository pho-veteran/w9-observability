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

---

### Bài 4: Alert on AWS Root Account Login

#### 4.1 Enable CloudTrail & Send Logs to CloudWatch

Bật CloudTrail (multi-region) và cấu hình gửi log về CloudWatch Log Group `/aws/cloudtrail/w9-root-login-trail`.

```
Trail Name       : w9-root-login-trail
Multi-region     : Yes
Log Group        : /aws/cloudtrail/w9-root-login-trail
IAM Role         : cloudtrail-to-cloudwatch-role
```

![CloudTrail Created](./evidence/cloudtrail-created.png)
![CloudWatch Log Group](./evidence/cloudtrail-cw-logs.png)

#### 4.2 Create CloudWatch Metric Filter

Tạo Metric Filter trên Log Group để phát hiện sự kiện Root Account (theo CIS AWS Foundations Benchmark):

```
{ $.userIdentity.type = "Root" && $.userIdentity.invokedBy NOT EXISTS && $.eventType != "AwsServiceEvent" }
```

```
Filter Name      : RootLoginFilter
Metric Namespace : CloudTrailMetrics
Metric Name      : RootAccountEventCount
Metric Value     : 1
Default Value    : 0
```

![Metric Filter](./evidence/root-login-metric-filter.png)

#### 4.3 Create CloudWatch Alarm

Tạo Alarm dựa trên metric `RootAccountEventCount`, trigger khi có ít nhất 1 Root login trong 5 phút:

```
Alarm Name       : RootAccountLoginAlarm
Condition        : RootAccountEventCount >= 1
Period           : 5 minutes (300s)
Evaluation       : 1 out of 1 datapoints
Action           : Gửi notification tới SNS Topic root-login-sns-topic
```

![Root Login Alarm Config](./evidence/root-login-alarm.png)

#### 4.4 Notify via SNS

Kết nối Alarm với SNS Topic `root-login-sns-topic`, gửi email cảnh báo khi phát hiện Root Login.

![Email Notification Root Login](./evidence/root-login-email.png)


