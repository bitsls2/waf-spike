const axios = require('axios');
const fs = require('fs');
const path = require('path');

const API_URL = 'http://localhost';
const REQUEST_DATA_PATH = path.join(__dirname, '../data/data.json');

async function processIncident(incident) {
    try {
        // Create new incident (without the id field)
        const { id, ...newIncident } = incident;
        const createResponse = await axios.post(`${API_URL}/incidents`, newIncident);
        console.log('Created incident:', createResponse.data.id);

        // Update the incident with a modified description
        const updateData = {
            description: `Updated: ${incident.description}`
        };
        const updateResponse = await axios.patch(
            `${API_URL}/incidents/${createResponse.data.id}`,
            updateData
        );
        console.log('Updated incident:', updateResponse.data.id);

        return createResponse.data.id;
    } catch (error) {
        console.error(`Error processing incident: ${error.message}`);
        return null;
    }
}

async function generateRequests() {
    try {
        // Read sample incident data
        const rawData = fs.readFileSync(REQUEST_DATA_PATH);
        const sampleData = JSON.parse(rawData);

        // Get initial count
        const initialResponse = await axios.get(`${API_URL}/incidents`);
        console.log('Initial incident count:', initialResponse.data.length);

        // Process each incident in sequence
        const createdIds = [];
        for (const incident of sampleData.incidents) {
            const id = await processIncident(incident);
            if (id) createdIds.push(id);
        }

        // Get final count
        const finalResponse = await axios.get(`${API_URL}/incidents`);
        console.log('Final incident count:', finalResponse.data.length);
        console.log('Successfully processed incidents:', createdIds.length);

    } catch (error) {
        console.error('Error:', error.message);
    }
}

generateRequests();