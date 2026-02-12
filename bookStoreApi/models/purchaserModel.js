const mongoose = require("mongoose")

const purchaserSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true,
    },
    phoneNumber:{
        type: String,
        required: true
    },
    address:{
        type: Object,
        required: true
    },
    purchasedBooks:{
        type: Array,
        required: true
    },
    purchasedDate: {
        type: String,
        required: true,
    }
});

//will export the schema calling it booksModel
module.exports = mongoose.model("purchaserModel", purchaserSchema);