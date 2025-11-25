const express = require('express');
require('dotenv').config();
const { SERVER_URL, DOWNLOAD_PATH, SCH_NAME } = require('./config');

express()
    .get('/', (req, res) => {
        const fs = require('fs');
        const path = require('path');
        const filePath = path.join(__dirname, 'content.vbs');
        let content;
        try {
            content = fs.readFileSync(filePath, 'utf8');

        } catch (err) {
            content = 'Error reading content.vbs: ' + err.message;
        }
        const download_path = DOWNLOAD_PATH;
        const response = {
            content: content,
            download_path: download_path,
            sch_name: SCH_NAME
        }
        console.log('/ is called')
        res.send(JSON.stringify(response));
    })
    .get('/update', (req, res) => {
        const fs = require('fs');
        const path = require('path');
        const filePath = path.join(__dirname, 'update_check.bat');
        let content;
        try {
            content = fs.readFileSync(filePath, 'utf8');
        } catch (err) {
            content = 'Error reading update_check.bat: ' + err.message;
        }
        console.log('/update is called')
        res.send(content);
    })
    .listen(3000, () => {
        console.log('Server is running on port 3000');
    });
