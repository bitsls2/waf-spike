const axios = require('axios');
const { faker } = require('@faker-js/faker');

const API_URL = 'http://localhost:9999';

const incidentTypes = [
    'Security Breach',
    'System Outage',
    'Network Issue',
    'Data Loss',
    'Application Error'
];

async function generateRequests() {
    try {
        // Get all incidents
        const getAllResponse = await axios.get(`${API_URL}/incidents`);
        console.log('GET all incidents:', getAllResponse.status);

        // Create new incident
        const newIncident = {
            createdAt: faker.date.past(),
            type: faker.helpers.arrayElement(incidentTypes),
            title: faker.helpers.fake('{{company.catchPhrase}} - {{hacker.verb}} Issue'),
            description: faker.helpers.multiple(() => faker.hacker.phrase(), {
                count: { min: 3, max: 6 }
            }).join(' ')
        };

        const createResponse = await axios.post(`${API_URL}/incidents`, newIncident);
        console.log('Created incident:', createResponse.data);

        // Update an existing incident
        const updateId = getAllResponse.data[0].id;
        const updateResponse = await axios.patch(`${API_URL}/incidents/${updateId}`, {
            description: faker.helpers.multiple(() => faker.hacker.phrase(), {
                count: { min: 2, max: 4 }
            }).join(' ')
        });
        console.log('Updated incident:', updateResponse.data);

        // Delete an incident
        const deleteId = getAllResponse.data[1].id;
        const deleteResponse = await axios.delete(`${API_URL}/incidents/${deleteId}`);
        console.log('Deleted incident:', deleteId);

    } catch (error) {
        console.error('Error:', error.message);
    }
}

generateRequests();