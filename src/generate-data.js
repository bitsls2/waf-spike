const { faker } = require('@faker-js/faker');
const fs = require('fs');

const INCIDENT_COUNT = 100;

const incidentTypes = [
    'Security Breach',
    'System Outage',
    'Network Issue',
    'Data Loss',
    'Application Error'
];

function generateIncident() {
    return {
        id: faker.string.uuid(),
        createdAt: faker.date.past(),
        type: faker.helpers.arrayElement(incidentTypes),
        title: faker.helpers.fake('{{company.catchPhrase}} - {{hacker.verb}} Issue'),
        description: faker.helpers.multiple(() => faker.hacker.phrase(), {
            count: { min: 3, max: 6 }
        }).join(' ')
    };
}

const incidents = Array.from({ length: INCIDENT_COUNT }, generateIncident);

const db = {
    incidents: incidents
};

fs.writeFileSync('./data/db.json', JSON.stringify(db, null, 2));
console.log(`Generated ${INCIDENT_COUNT} incidents in db.json`);