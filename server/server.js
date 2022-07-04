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

app.get("/posts", authenticateToken, (req, res) => {
    res.json({ response: "Test"})
})


function generateAccessToken(email) {
    jwtuser = { email : email }
    return jwt.sign(jwtuser, process.env.AUTH_TOKEN_SECRET, { expiresIn: '15s'});
}

function generateRefreshToken(email) {
    jwtuser = { email : email }
    return jwt.sign(jwtuser, process.env.REFRESH_TOKEN_SECRET);
}

// authenticate token middleware
function authenticateToken(req, res, next) {
    const authHeader = req.headers['authorization']
    const token = authHeader && authHeader.split(' ')[1]
    if (token == null) return res.sendStatus(401)

    jwt.verify(token, process.env.AUTH_TOKEN_SECRET, (err, jwtuser) => {
        if (err) {
            console.log(err);
            return res.sendStatus(403)
        }
        req.jwtuser = jwtuser
        next()
    })
}

app.listen(5000, () => console.log('Listening on port 5000...'));