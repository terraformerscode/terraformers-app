// const AWS = require('aws-sdk');
// const dynamo = new AWS.DynamoDB.DocumentClient();

const MONGO_DB_PASSWORD = 'nmaQqihEsNFoXByG';
const mongoose = require('mongoose');
const { ServerApiVersion } = require('mongodb');
const uri = `mongodb+srv://TerraformersFirstDB:${MONGO_DB_PASSWORD}
@prav-first-cluster.ffwq9.mongodb.net/?retryWrites=true&w=majority`;

const bcrypt = require('bcrypt');

exports.handler = async (event, context) => {
    let body;
    let yo;
    let statusCode = '200';
    const headers = {
        'Content-Type': 'application/json',
    };

    try {
        switch (event.httpMethod) {
            case 'POST':
                // body = await dynamo.delete(JSON.parse(event.body)).promise();
                break;
            default:
                throw new Error(`Unsupported method "${event.httpMethod}. Use POST"`);
        }
    } catch (err) {
        statusCode = '400';
        body = err.message;
    } finally {
        body = JSON.stringify(body);
        event = JSON.stringify(event);
    }

    return {
        statusCode,
        body,
        headers,
        event
    };
};
