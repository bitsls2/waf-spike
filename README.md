# Create a REST API Stub

## Goal
This project shall: 
- Create a REST API Stub for Incident Creations and will support basic CRUD.
- Incidents will contain a: create data, Id, type, title, description
- The stub will use javascipt and node
- The stub should use json-serve container image
- A data file called db.json should be used to seed the rest API
- The datafile should be generated using faker-js
- Generating a realistic description for incidents is the key as this will allow us to test the WAF


I'll help you set up a Node.js project to generate incident data using Faker.js. Here are the steps:

1. First, create the project structure and initialize npm:

```bash
mkdir -p src
npm init -y
npm install @faker-js/faker
```

2. Create a generator script:

````javascript
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

fs.writeFileSync('db.json', JSON.stringify(db, null, 2));
console.log(`Generated ${INCIDENT_COUNT} incidents in db.json`);
````

3. Add a script to your package.json:

````json
{
  "scripts": {
    "generate": "node src/generator.js"
  }
}
````

Run the generator:

```bash
npm run generate
```

This will create a `db.json` file with randomly generated incidents. Each incident will have:
- A unique UUID
- Creation date
- Incident type from predefined list
- Generated title combining company and tech terms
- Multi-sentence description using tech-related phrases

To run the script:

```bash
npm run test-api
```

This script will:

- Get all incidents
- Create a new incident
- Update an existing incident's description
- Delete an incident

Make sure your json-server is running before executing this script. The script assumes json-server is running on the default port 3000.

Faker-js was used to create initial test data. Then copilot was used to create additional test data. The following descriptions were used to generate test data.

Update the descriptions in each incident so that the description describes customer service incidents which involve bad language , abusive behavior and has raised concerns for customers service representatives

Create 20 further incidents items based on the existing entries. Use characters and words that are likely to cause 403 response from the OWASP core rule set, which could be consider to be false positives. 

Create an additional 40 incidents so that the description describes customer service incidents which involve bad language , abusive behavior and has raised safeguarding concerns for customers service representatives. Each description could contain multiple paragraphs and punctuation.
