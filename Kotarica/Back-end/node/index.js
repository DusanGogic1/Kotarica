const os = require("os");
const express = require("express");
const bodyParser = require("body-parser");
const ipfsClient = require("ipfs-http-client");
const fileUpload = require("express-fileupload");
const ipfsAPI = require('ipfs-api');
const cors = require('cors');

const ipfsUpload = new ipfsClient({host: 'localhost', port: '5001', protocol: 'http'})
const ipfsDownload = ipfsAPI("localhost", "5001", {protocol: "http"});

var app = express();
// Find local IP
var interfaces = os.networkInterfaces();
var selectedInterface;
var ipAddress;
for (let key of Object.keys(interfaces)) {
    if (
        key === 'eth0'                  // Linux
        || key === 'en0'                // OS X / iOS
        || key.startsWith('enp')        // Linux
        || key.startsWith('Ethernet')   // Windows

        || key.startsWith('wlan')       // Android
        || key.startsWith('ap')         // OS X / iOS
        || key.startsWith('Wi-Fi')
    ) {
        selectedInterface = key;
        for (let i of Object.keys(interfaces[key])) {
            if (interfaces[key][i]['family'] === 'IPv4') {
                ipAddress = interfaces[key][i]['address'];
                break;
            }
        }
        break;
    }
}
console.log(`Using IP address ${ipAddress} from interface ${selectedInterface}`);

app.listen(3000, ipAddress, () => {
    console.log("Server is listening on port 3000");
});

app.use(fileUpload());

app.use(bodyParser.urlencoded({extended: true, limit: "50mb"}));

app.use(cors());

app.post("/image", async (req, res) => {
    var name = req.body.name;
    var img = req.body.image;
    //var realFile = Buffer.from(img, "base64");
    const fileHash = addFile(name, img, res);
});

app.post("/download", async (req, res) => {
    const cid = req.body.hash;
    //console.log(cid);
    ipfsDownload.files.get(cid, function (err, files) {
        files.forEach((file) => {
            if (cid == 'QmZws7HW1TZVP54LfoKRLWVDtfrk2nUz3MYCJKU67HtkG2') {
                res.json({content: file.content.toString("base64")});
            }
            else {
                res.json({content: file.content.toString("utf-8")});
            }
            console.log(cid);
        });
    });
})

const addFile = async (fileName, file, res) => {
    const fileAdded = await ipfsUpload.add({path: fileName, content: file})
    const fileHash = fileAdded.cid.string;
    res.json({hash: fileHash});
    console.log(fileHash);
    return fileHash;
}
