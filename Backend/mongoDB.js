 
const mongoose = require('mongoose')
 
 
async function connectToDB() {
    try {
        await mongoose.connect("mongodb+srv://chandramoulipanyam_db_user:FLgi8ErFu6i10NfL@cluster0.ykndijd.mongodb.net/?appName=Cluster0")
 
        console.log("Connected To Database")
    }
 
    catch (err) {
        console.log(err)
    }
}
 
connectToDB();
module.exports = connectToDB
 
 
 
 
 
 