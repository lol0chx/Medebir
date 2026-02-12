const mongoose = require("mongoose");

const booksSchema = new mongoose.Schema({
  title: {
    type: String,
    required: true,
  },
  category: {
    type: String,
    required: true,
  },
  description: {
    type: String,
    required: true,
  },
  author: {
    type: String,
    require: true,
  },
  rating: {
    type: String,
    require: true,
  },
  price: {
    type: String,
    required: true,
  },
  posterImage: {
    type: String,
    require: true,
  },
  posterPublicId: {
    type: String,
    require: true,
  },
  postDate: {
    type: Date,
    required: true,
    default: Date.now,
  },
});

//will export the schema calling it booksModel
module.exports = mongoose.model("booksModel", booksSchema);
