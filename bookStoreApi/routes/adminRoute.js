const express = require('express');
const router = require('express').Router();
const booksModel = require("../models/booksModel.js");
const purchaserModel = require('../models/purchaserModel');


router.get("/", async (req, res) => {
    try {
      const allPurchasers = await purchaserModel.find();
      res.json(allPurchasers);
    } catch (error) {
      //sends back error message to the user as json
      res.status(500).json({ message: error.message });
    }
});

router.post("/", async (req,res)=>{
    try {
        var purchaser = new purchaserModel({
            name: req.body.name,
            phoneNumber: req.body.phoneNumber,
            address: req.body.address,
            purchasedBooks: req.body.purchasedBooks,
            purchasedDate: req.body.purchasedDate,
        });
    } catch (error) {
        res.json({ message: error.message });
    }
    try {
        const newPurchaser = await purchaser.save(); 
        res.status(201).json(newPurchaser);
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
});

router.get("/:id", async (req, res) => {
    let purchaser;
    try {
      purchaser = await purchaserModel.findById(req.params.id);
      if (purchaser == null) {
        return res.status(404).json({ message: "Cannot find purchaser." });
      }
    } catch (error) {
      return res.status(500).json({ message: error.message });
    }
    res.json(purchaser);
});

router.delete("/:id", async (req, res) => {
    let purchaser;
    try {
      purchaser = await purchaserModel.findById(req.params.id);
      if (purchaser == null) {
        return res.status(404).json({ message: "Cannot find purchaser." });
      }
    } catch (error) {
      return res.status(500).json({ message: error.message });
    }
    try {
      //removes the book from mongodb
      await purchaser.remove();
      res.json({ message: "Purchaser removed" });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
});
  

module.exports = router;