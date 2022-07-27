require('dotenv').config();
const express = require('express');
const app = express();
const jwt = require('jsonwebtoken');

const mongoose = require('mongoose');
const { ServerApiVersion } = require('mongodb');
const uri = `mongodb+srv://TerraformersFirstDB:${process.env.MONGO_DB_PASSWORD}
@prav-first-cluster.ffwq9.mongodb.net/?retryWrites=true&w=majority`;

async function connectDB() {
    await mongoose.connect(uri, {
        useNewUrlParser: true,
        useUnifiedTopology: true,
        serverApi: ServerApiVersion.v1
    });

    console.log("db connected")
}
connectDB();

const iso = require('iso-3166-1');

var countryISOMap = iso.all();
 
// this takes the post body
app.use(express.json({ extended: false }));

app.get('/', (req, res) => res.send('Experience Server!'));

// get experienceDetails
app.get("/experienceDetails", (req, res) => {
    res.status(200).json(SGExperienceDetails)
})

app.get("/userCountryISO", (req, res) => {
    //TODO: Pass in their user country visas and display only those countries
    userCountryISOMap = {}
    userCountries = ["Singapore", "Japan", "Austria", "Cambodia"]
    userCountries.forEach((countryName) => {
        countryISOMap = iso.whereCountry(countryName)
        userCountryISOMap[countryName] = countryISOMap
    })
    res.status(200).json(userCountryISOMap)
})

// Map of experiences within each country
var SGExperienceDetails = {
    "0": {
      "title": "Bishan",
      "description": "Hi",
      "country": "sg",
      "position": {"lat": 1.3526, "lng": 103.8352},
      "tags": [],
      "localisedScore": 5,
      "authenticScore": 5,
      "intimateScore": 5,
      "photoURL": "",
    },
    "1": {
      "title": "Yishun",
      "description": "Hi",
      "country": "sg",
      "position": {"lat": 1.4304000000000001, "lng": 103.8354},
      "tags": [],
      "localisedScore": 5,
      "authenticScore": 5,
      "intimateScore": 5,
      "photoURL": "",
    },
    "2": {
      "title": "Woodlands",
      "description": "Hi",
      "country": "sg",
      "position": {"lat": 1.4382, "lng": 103.789},
      "tags": [],
      "localisedScore": 5,
      "authenticScore": 5,
      "intimateScore": 5,
      "photoURL": "",
    },
    "3": {
      "title": "Toa Payoh",
      "description": "Hi",
      "country": "sg",
      "position": {"lat": 1.3343, "lng": 103.8563},
      "tags": [],
      "localisedScore": 5,
      "authenticScore": 5,
      "intimateScore": 5,
      "photoURL": "",
    },
    "4": {
      "title": "Pasir Ris",
      "description": "Hi",
      "country": "sg",
      "position": {"lat": 1.3721, "lng": 103.9474},
      "tags": [],
      "localisedScore": 5,
      "authenticScore": 5,
      "intimateScore": 5,
      "photoURL": "",
    },
    "5": {
      "title": "Queenstown",
      "description": "Hi",
      "country": "sg",
      "position": {"lat": 1.2942, "lng": 103.7861},
      "tags": [],
      "localisedScore": 5,
      "authenticScore": 5,
      "intimateScore": 5,
      "photoURL": "",
    },
    "6": {
      "title": "Jurong East",
      "description": "Hi",
      "country": "sg",
      "position": {"lat": 1.3329, "lng": 103.7436},
      "tags": [],
      "localisedScore": 5,
      "authenticScore": 5,
      "intimateScore": 5,
      "photoURL": "",
    },
    "7": {
      "title": "Geylang",
      "description": "Hi",
      "country": "sg",
      "position": {"lat": 1.3201, "lng": 103.8913},
      "tags": [],
      "localisedScore": 5,
      "authenticScore": 5,
      "intimateScore": 5,
      "photoURL": "",
    },
    "8": {
      "title": "Bukit Merah",
      "description": "Hi",
      "country": "sg",
      "position": {"lat": 1.2819, "lng": 103.8239},
      "tags": [],
      "localisedScore": 5,
      "authenticScore": 5,
      "intimateScore": 5,
      "photoURL": "",
    },
    "9": {
      "title": "Central Area",
      "description": "Hi",
      "country": "sg",
      "position": {"lat": 1.2789, "lng": 103.8536},
      "tags": [],
      "localisedScore": 5,
      "authenticScore": 5,
      "intimateScore": 5,
      "photoURL": "",
    }
  };

app.listen(6000, () => console.log('Listening on port 6000...'));