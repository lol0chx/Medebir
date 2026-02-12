const express = require("express");
//imports the router module from the express package
const router = express.Router();

//imports the books model from the models folder
const booksModel = require("../models/booksModel.js");

//imports cloudinary and multer from utils
const cloudinary = require("../utils/cloudinary.js");
const upload = require("../utils/multer.js");

//getting all books
router.get("/", async (req, res) => {
  try {
    const allBooks = await booksModel.find();
    res.json(allBooks);
  } catch (error) {
    //sends back error message to the user as json
    res.status(500).json({ message: error.message });
  }
});

//creating a book
router.post("/", upload.single("image"), async (req, res) => {
  try {
    //will get an image file from req.file.path then uploads it into cloudinary
    //and stores the json response from cloudinary server to result variable
    //so later we can get the secure url to access the image
    const result = await cloudinary.uploader.upload(req.file.path);
    const newImageUrl = result.secure_url.replace(/v[0-9]+/, "t_global");
    //default url with out modification
    // const url =
    //   "https://res.cloudinary.com/df8icafxq/image/upload/v1612432543/myr6ply5ylzottggh3ua.jpg";
    // // const regEx = /v[1-9]+/;
    //url after modification
    // //   https://res.cloudinary.com/df8icafxq/image/upload/t_global/myr6ply5ylzottggh3ua.jpg
    // let newUrl = url.replace(/v[1-9]+/, "t_global");
    // console.log(newUrl);

    // https://res.cloudinary.com/df8icafxq/image/upload/v1612432543/myr6ply5ylzottggh3ua.jpg
    //will create a new book object based on the info probided from the body using the booksModel
    var book = new booksModel({
      title: req.body.title,
      category: req.body.category,
      description: req.body.description,
      author: req.body.author,
      rating: req.body.rating,
      price: req.body.price,
      posterImage: newImageUrl,
      posterPublicId: result.public_id,
    });
  } catch (error) {
    res.json({ message: error.message });
  }

  try {
    //will save the newly created book to the database
    const newBook = await book.save();
    //status 201 means successfully created an object
    res.status(201).json(newBook);
  } catch (error) {
    //status 400 means there is a user error
    res.status(400).json({ message: error.message });
  }
});

//getting one book
router.get("/:id", getBooks, (req, res) => {
  res.json(res.book);
});
//updating a book
router.patch("/:id", getBooks, upload.single("image"), async (req, res) => {
  if (req.body.title != null) {
    res.book.title = req.body.title;
  }
  if (req.body.category != null) {
    res.book.category = req.body.category;
  }
  if (req.body.description != null) {
    res.book.description = req.body.description;
  }
  if (req.body.price != null) {
    res.book.price = req.body.price;
  }
  if (req.body.author != null) {
    res.book.author = req.body.author;
  }
  if (req.body.rating != null) {
    res.book.rating = req.body.rating;
  }
  try {
    // await cloudinary.uploader.destroy(res.book.posterPublicId);
    // const result = await cloudinary.uploader.upload(req.file.path);
    const updatedBook = await res.book.save();
    res.json(updatedBook);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});
//deleting a book
router.delete("/:id", getBooks, async (req, res) => {
  try {
    //deletes the image from the cloudinary image database
    await cloudinary.uploader.destroy(res.book.posterPublicId);
    //removes the book from mongodb
    await res.book.remove();
    res.json({ message: "book removed" });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

//
async function getBooks(req, res, next) {
  let book;
  try {
    book = await booksModel.findById(req.params.id);
    if (book == null) {
      return res.status(404).json({ message: "Cannot find Book." });
    }
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
  res.book = book;
  next();
}

//exports the router
module.exports = router;
