Từ file PDF bạn gửi, mình trích được các yêu cầu của đề như sau:

### Bài tập: **[12/06] Homework_CDO_Monitoring**

**Lưu ý chung:**

* Với mỗi bài tập, chụp màn hình các bước thực hiện và đưa lên GitHub.
* Sau đó dán **link GitHub Public** vào ô nộp bài.

---

## 1. Student ID

* Nhập mã số sinh viên.

---

## 2. CPU Alarm → Email Alert via SNS

Thực hiện cấu hình cảnh báo CPU và gửi email bằng AWS SNS theo kịch bản:

> Gửi email cảnh báo khi EC2 có CPU > 80% trong 5 phút liên tiếp.

### Các bước yêu cầu:

1. **Create SNS Topic & Subscription**

   * Tạo SNS Topic (Standard).
   * Thêm Email Subscription.
   * Xác nhận subscription qua email.

2. **Create CloudWatch Alarm**

   * CloudWatch → Alarms → Create Alarm.
   * Chọn metric:

     * EC2
     * Per-Instance Metrics
     * CPUUtilization

3. **Configure Alarm Conditions**

   * Điều kiện: CPU > 80%.
   * Period: 5 minutes.
   * Evaluation: 1 out of 1 datapoints.

4. **Set SNS Notification Action**

   * Khi Alarm state xảy ra → gửi notification tới SNS Topic.
   * (Tùy chọn) thêm Recovery Notification.

### Nộp bài:

* Đưa screenshot lên GitHub.
* Dán link GitHub Public.

---

## 3. Installing the CloudWatch Agent on EC2

### Các bước yêu cầu:

1. **Install CloudWatch Agent**

Ubuntu:

```bash
sudo apt-get update
sudo apt-get install amazon-cloudwatch-agent -y
```

Amazon Linux:

```bash
sudo yum install amazon-cloudwatch-agent -y
```

2. **Run Configuration Wizard**

```bash
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard
```

3. **Start Agent**

```bash
sudo systemctl enable amazon-cloudwatch-agent
sudo systemctl start amazon-cloudwatch-agent
```

4. **Verify & Check Status**

```bash
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -m ec2 -a status
```

### Nộp bài:

* Chụp màn hình các bước thực hiện.
* Upload lên GitHub public.
* Dán link GitHub vào ô trả lời.

---

### Tóm tắt đầu việc cần làm

1. Tạo SNS Topic + Email Subscription.
2. Tạo CloudWatch Alarm theo điều kiện:

   * CPUUtilization > 80%
   * 5 phút
   * Gửi email qua SNS.
3. Cài CloudWatch Agent trên EC2.
4. Kiểm tra Agent hoạt động.
5. Chụp màn hình toàn bộ quá trình.
6. Upload GitHub Public.
7. Nộp link GitHub.

---

## 4. Alert on AWS Root Account Login

> **Security Best Practice:** Root account gần như không nên được sử dụng. Cần cảnh báo ngay khi có login.

### Mục tiêu:

Thiết lập cảnh báo khi có đăng nhập bằng tài khoản AWS Root Account.

### Các bước yêu cầu:

1. **Enable CloudTrail & Send Logs to CloudWatch**

   * Bật CloudTrail (multi-region).
   * Cấu hình CloudTrail gửi log về CloudWatch Logs.

2. **Create CloudWatch Metric Filter**

   * Tạo Metric Filter trên CloudWatch Log Group nhận log từ CloudTrail.
   * Lọc các sự kiện Root Account (theo CIS AWS Foundations Benchmark):

     ```
     { $.userIdentity.type = "Root" && $.userIdentity.invokedBy NOT EXISTS && $.eventType != "AwsServiceEvent" }
     ```

3. **Create CloudWatch Alarm**

   * Tạo Alarm dựa trên Metric Filter vừa tạo.
   * Điều kiện: `RootAccountEventCount >= 1` trong 5 phút.
   * Khi phát hiện Root Login thì chuyển sang trạng thái Alarm.

4. **Notify via SNS**

   * Kết nối Alarm với SNS Topic.
   * Gửi email thông báo khi có Root Login.

### Nộp bài:

* Chụp ảnh màn hình các bước thực hiện.
* Upload lên GitHub Public.
* Nộp link GitHub vào form.

