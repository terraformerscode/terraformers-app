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

const bcrypt = require('bcrypt');

// this takes the post body
app.use(express.json({ extended: false }));

app.get('/', (req, res) => res.send('Hello World!'));

// User model
const userSchema = new mongoose.Schema({ email: 'string', username: 'string', password: 'string' });
const User = mongoose.model('User', userSchema, 'testUsers');

// Hashing
var saltRounds = 15;

// TODO: CHANGE TO DATABASE STORAGE
let refreshTokens = []

// signup route api
app.post('/signup', async (req, res) => {
    const { email, username, password } = req.body;
    
    const hashPwd = await bcrypt.hash(password, saltRounds)
        .then(hash => {
            return hash;
        })
        .catch(err => {
            console.log(err);
            return null;
        })
        ?? "Hashing failed";
    
    let user = new User({
        email: email,
        username: username,
        password: hashPwd
    });
    console.log(user);
    await user.save();

    //TODO: check db for duplicate email
});

// login route api
app.post('/login', async (req, res) => {
    const { email, password } = req.body;

    let user = await User.findOne({ email });
    var emailExists = false;
    var pwdAuthenticated = false;
    var authToken = "0";
    var refreshToken = "0";
    if (user != null) {
        emailExists = true;
        pwdAuthenticated = await bcrypt.compare(password, user.password);
    }

    if (pwdAuthenticated) {
        // JSON Web Token: To be saved in local cache for user auth
        authToken = generateAccessToken(email);
        refreshToken = generateRefreshToken(email);
        refreshTokens.push(refreshToken);
        console.log(email + ' logged in');
    }

    res.json({
        terraformersAuthToken: authToken,
        terraformersRefreshToken: refreshToken,
        pwdAuthenticated: pwdAuthenticated,
        emailExists: emailExists
    });
});

// reset password route api
app.put('/resetPassword', async (req, res) => {
    const { email, password } = req.body;

    const hashPwd = await bcrypt.hash(password, saltRounds)
        .then(hash => {
            return hash;
        })
        .catch(err => {
            console.log(err);
            return null;
        })
        ?? "Hashing failed";

    let user = await User.findOne({ email: email });
    var resetSuccess = false;
    if (user != null) {
        user.password = hashPwd;
        await user.save();
        resetSuccess = true;
    }

    res.json({
        resetSuccess: resetSuccess,
    });
});

// check if user exists route api
app.put('/userExists', async (req, res) => {
    const { email } = req.body;

    let user = await User.findOne({ email: email });
    var exists = false;
    if (user != null) {
        exists = true;
    }

    res.json({
        userExists: exists
    });
});

// logout route api
app.delete('/logout', (req, res) => {
    console.log("user logged out")
    refreshTokens = refreshTokens.filter(token => token !== req.body.terraformersRefreshToken)
    res.sendStatus(204)
})

// regenerate access token
app.post("/token", (req, res) => {
    const refreshToken = req.body.terraformersRefreshToken
    if (refreshToken == null) return res.sendStatus(401)
    if (!refreshTokens.includes(refreshToken)) return res.sendStatus(403)
    jwt.verify(refreshToken, process.env.REFRESH_TOKEN_SECRET, (err, jwtuser) => {
        if (err) return res.sendStatus(403)
        const authToken = generateAccessToken(jwtuser.email)
        res.json({ terraformersAuthToken: authToken})
    });
});

// reauthenticate logged in user
app.get("/loggedInUser", authenticateAuthToken, (req, res) => {
    res.sendStatus(204)
})


function generateAccessToken(email) {
    //TODO: Make the auth token expire during production
    jwtuser = { email : email }
    return jwt.sign(jwtuser, process.env.AUTH_TOKEN_SECRET/*, { expiresIn: '15m'}*/);
}

function generateRefreshToken(email) {
    jwtuser = { email : email }
    return jwt.sign(jwtuser, process.env.REFRESH_TOKEN_SECRET);
}

// authenticate authtoken middleware
function authenticateAuthToken(req, res, next) {
    const authHeader = req.headers['authorization']
    const token = authHeader && authHeader.split(' ')[1]
    if (token == null) return res.sendStatus(401)

    jwt.verify(token, process.env.AUTH_TOKEN_SECRET, (err, jwtuser) => {
        if (err) {
            return res.sendStatus(403)
        }
        req.jwtuser = jwtuser
        next()
    })
}

//====================COUNTRY VISA STUFF=======================
const iso = require('iso-3166-1');

var countryISOMap = iso.all();

// get experienceDetails
app.get("/experienceDetails", (req, res) => {
    res.status(200).json(SGExperienceDetails)
})

app.get("/userCountryISO", (req, res) => {
    //TODO: Pass in their user country visas and display only those countries
    userCountryISOMap = {}
    userCountries = ["Singapore", "Japan", "Vietnam", "Cambodia"]
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

app.listen(5000, () => console.log('Listening on port 5000...'));