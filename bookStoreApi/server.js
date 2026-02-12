const express = require("express");
const app = express();
const booksRouter = require("./routes/booksRoute.js");
const adminRouter = require("./routes/adminRoute");
//mongoose
const mongoose = require("mongoose");
mongoose.connect(
  "mongodb+srv://henoksmekuria_db_user:63jQabDnBeUDpXfB@devcluster.hofqh3w.mongodb.net/bookStore?appName=DevCluster"
);
//creates a variable that holds the mongodb connection
const db = mongoose.connection;
//it will log if there was an error while connecting to db
db.on("error", (error) => console.error(error));
//it will log if the db was opened successfully
db.once("open", () => console.log("connected to database"));

//lets our server to accept json
app.use(express.json());
//import the booksRoute from the routes folder
app.use("/books", booksRouter);
//route is going to look like localhost:3000/books
app.use("/admin",adminRouter);

//api port
const myPort = process.env.port || 4000;
app.listen(myPort, () => console.log(`server started at port http://localhost:${myPort}`));
