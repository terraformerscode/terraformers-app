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

// this takes the post body
app.use(express.json({ extended: false }));

app.get('/', (req, res) => res.send('Hello World!'));

// User model
const schema = new mongoose.Schema({ email: 'string', password: 'string' });
const User = mongoose.model('User', schema);

// signup route api
app.post('/signup', async (req, res) => {
    const { email, password } = req.body;
    
    let user = new User({
        email,
        password,
    });
    console.log(user);
    await user.save();

    // JSON Web Token
    // To be saved in local cache for user auth
    res.json({authToken: "123456789"});

    // check db for duplicate email
    // return res.send('Hello World!')
});

app.listen(5000, () => console.log('Listening on port 5000...'));