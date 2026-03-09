const express = require("express");
const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

app.get("/health", (req, res) => {
  res.status(200).json({ status: "healthy" });
});

app.get("/", (req, res) => {
  res.json({
    app: "CAF - Car Maintenance Tracker",
    version: process.env.APP_VERSION || "1.0.0",
  });
});

app.listen(PORT, () => {
  console.log(`CAF server running on port ${PORT}`);
});
