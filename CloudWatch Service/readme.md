## Table of Contents
* [What is AWS CloudWatch?](#item1)
* [What is an alarm?](#item2)
* [What is a metric?](#item3)
* [What are logs?](#item4)
* [What are X-Ray traces?](#item5)
* [What is an event?](#item6)
* [What is Application Signal?](#item7)
* [What is Network Monitoring?](#item8)
* [What are Insights?](#item9)
* [CloudWatch configuration with IaC](#item10)

<a name="item1"></a>
## What is AWS CloudWatch?
AWS CloudWatch is a monitoring and observability service from Amazon Web Services (AWS) that allows you to collect, monitor, and analyze metrics, logs, and events to get a complete view of your cloud resources and applications.

<a name="item2"></a>
## What is an alarm?
A CloudWatch alarm allows you to monitor a specific metric and automatically perform actions when the metric meets certain criteria. Alarms can send notifications, trigger Auto Scaling actions, or execute Lambda functions.

<a name="item3"></a>
## What is a metric?
A metric is a representative data point that indicates the performance of a resource. CloudWatch collects metrics from many AWS services (such as EC2, RDS, S3) and allows you to define and send your own custom metrics.

<a name="item4"></a>
## What are logs?
Logs in CloudWatch Logs allow you to collect, monitor, and analyze logs from your applications and services. You can create metrics based on log patterns and perform queries to get detailed information about your applications' behavior.

<a name="item5"></a>
## What are X-Ray traces?
AWS X-Ray is a service that allows you to analyze and debug distributed applications. Traces are records of all requests that traverse the services in your application, providing a detailed view of request flow and latency in each component.

<a name="item6"></a>
## What is an event?
CloudWatch Events (now part of Amazon EventBridge) allows you to react to changes in your AWS environment almost in real-time. You can configure rules that detect operational events and trigger actions such as invoking Lambda functions or sending notifications.

<a name="item7"></a>
## What is Application Signal?
Application Signals are indicators of an application's health and performance. In the context of CloudWatch, you can monitor signals such as performance metrics, application logs, and X-Ray traces to get a complete view of your application's status.

<a name="item8"></a>
## What is Network Monitoring?
Network Monitoring in CloudWatch allows you to monitor and diagnose network issues in your AWS resources. You can use network metrics from services like VPC, CloudFront, and ELB to get information about traffic and latency.

<a name="item9"></a>
## What are Insights?
CloudWatch Insights provides tools for performing advanced queries and analysis on logs and metrics. Log Insights allows you to quickly search and analyze large volumes of logs, while Metric Insights helps you identify patterns and trends in metrics.

<a name="item10"></a>
## CloudWatch configuration with IaC
This repository includes Terraform and CloudFormation configuration that creates the following resources:
- A CloudWatch alarm to monitor CPU utilization of a specific EC2 instance.
- An SNS topic and an email subscription to receive notifications.
- A CloudWatch dashboard to visualize metrics.

![Diagram](https://github.com/Andherson333333/AWS-IAC/blob/main/CloudWatch%20Service/imagenes/cloudwatch.png)
![Diagram](https://github.com/Andherson333333/AWS-IAC/blob/main/CloudWatch%20Service/imagenes/cloudwatch-1.png)
