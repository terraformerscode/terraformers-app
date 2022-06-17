require('dotenv').config();
const express = require('express');
const app = express();

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
const schema = new mongoose.Schema({ email: 'string', username: 'string', password: 'string' });
const User = mongoose.model('User', schema, 'testUsers');

// Hashing
var saltRounds = 15;

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

    // JSON Web Token: To be saved in local cache for user auth
    res.json({terraformersAuthToken: "123456789"});

    //TODO: check db for duplicate email
});

// login route api
app.post('/login', async (req, res) => {
    const { email, password } = req.body;
    
    let user = await User.findOne({ email });
    var pwdAuthenticated = await bcrypt.compare(password, user.password);

    // JSON Web Token: To be saved in local cache for user auth
    res.json({terraformersAuthToken: "123456789"});
});

app.listen(5000, () => console.log('Listening on port 5000...'));