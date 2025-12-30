import boto3

def lambda_handler(event, context):
    ec2 = boto3.client('ec2')
    # 테라폼 apply 이후 생성될 때 새 인스턴스 ID를 나중에 삽입
    # 아니면 태그 기반으로 찾도록 수정 가능

    isinstance_id = event.get('instance_id', 'i-')
    action = event.get('action')

    if action == 'start':
        ec2.start_instances(InstanceIds=[isinstance_id])
        return f"Started instance: {isinstance_id}"
    elif action == 'stop':
        ec2.stop_instances(InstanceIds=[isinstance_id])
        return f"Stopped instance: {isinstance_id}"
