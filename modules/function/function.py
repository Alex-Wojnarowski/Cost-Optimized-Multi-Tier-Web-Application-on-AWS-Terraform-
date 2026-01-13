import boto3

dynamodb = boto3.client('dynamodb')

def lambda_handler(event, context):
    response = dynamodb.update_item(
        TableName='Hit_Count',
        Key={'Hit': {'S': 'Counter'}},
        UpdateExpression='ADD #c :inc',
        ExpressionAttributeNames={'#c': 'Count'},
        ExpressionAttributeValues={':inc': {'N': '1'}},
        ReturnValues='UPDATED_NEW'
    )

    return {
        'statusCode': 200,
        'headers': {
            'Access-Control-Allow-Origin': '*'
        },
    }
