
lambda_role_name   = "resource_inventory_lambda_role"
lambda_filename    = "lambda_function.zip"
lambda_function_name = "resource_inventory_lambda"
lambda_handler     = "ShowService.lambda_handler"
lambda_runtime     = "python3.12"
lambda_environment_variables = {
  ENV = "prod"
}
schedule_expression = "cron(0 1 * * ? *)"  # 1 AM UTC daily

lambda_code = <<EOF
import boto3
import json
from botocore.config import Config

def get_active_services():
    return ['ec2', 's3', 'lambda', 'rds', 'dynamodb', 'ecs', 'eks', 'elasticache', 'redshift', 'sqs']

def get_ec2_resources(ec2):
    instances = ec2.describe_instances(MaxResults=1000)
    return [instance['InstanceId'] for reservation in instances['Reservations'] for instance in reservation['Instances']]

def get_s3_resources(s3):
    buckets = s3.list_buckets()
    return [bucket['Name'] for bucket in buckets['Buckets']]

def get_lambda_resources(lambda_client):
    functions = lambda_client.list_functions(MaxItems=1000)
    return [function['FunctionName'] for function in functions['Functions']]

def get_rds_resources(rds):
    instances = rds.describe_db_instances()
    return [instance['DBInstanceIdentifier'] for instance in instances['DBInstances']]

def get_dynamodb_resources(dynamodb):
    tables = dynamodb.list_tables()
    return tables['TableNames']

def get_ecs_resources(ecs):
    clusters = ecs.list_clusters()
    return clusters['clusterArns']

def get_eks_resources(eks):
    clusters = eks.list_clusters()
    return clusters['clusters']

def get_elasticache_resources(elasticache):
    clusters = elasticache.describe_cache_clusters()
    return [cluster['CacheClusterId'] for cluster in clusters['CacheClusters']]

def get_redshift_resources(redshift):
    clusters = redshift.describe_clusters()
    return [cluster['ClusterIdentifier'] for cluster in clusters['Clusters']]

def get_sqs_resources(sqs):
    queues = sqs.list_queues()
    return queues.get('QueueUrls', [])

def lambda_handler(event, context):
    config = Config(
        retries = {'max_attempts': 2},
        connect_timeout=5, 
        read_timeout=5
    )
    
    session = boto3.Session()
    clients = {
        'ec2': session.client('ec2', config=config),
        's3': session.client('s3', config=config),
        'lambda': session.client('lambda', config=config),
        'rds': session.client('rds', config=config),
        'dynamodb': session.client('dynamodb', config=config),
        'ecs': session.client('ecs', config=config),
        'eks': session.client('eks', config=config),
        'elasticache': session.client('elasticache', config=config),
        'redshift': session.client('redshift', config=config),
        'sqs': session.client('sqs', config=config)
    }
    
    try:
        resources = {
            'ec2_instances': get_ec2_resources(clients['ec2']),
            's3_buckets': get_s3_resources(clients['s3']),
            'lambda_functions': get_lambda_resources(clients['lambda']),
            'rds_instances': get_rds_resources(clients['rds']),
            'dynamodb_tables': get_dynamodb_resources(clients['dynamodb']),
            'ecs_clusters': get_ecs_resources(clients['ecs']),
            'eks_clusters': get_eks_resources(clients['eks']),
            'elasticache_clusters': get_elasticache_resources(clients['elasticache']),
            'redshift_clusters': get_redshift_resources(clients['redshift']),
            'sqs_queues': get_sqs_resources(clients['sqs'])
        }

        resource_counts = {f"{key}_count": len(value) for key, value in resources.items()}
        total_count = sum(resource_counts.values())

        summary = {
            'resource_counts': resource_counts,
            'total_resources': total_count
        }

        result = {
            'summary': summary,
            'details': resources
        }
        
        return {
            'statusCode': 200,
            'body': json.dumps(result, indent=2)
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({
                'error': str(e)
            })
        }
EOF
