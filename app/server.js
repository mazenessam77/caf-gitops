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
    version: process.env.APP_VERSION || "2.0.0",
    feature: "Service History Tracking",
  });
});

app.get("/api/services", (req, res) => {
  res.json([
    { id: 1, type: "Oil Change", interval_km: 10000 },
    { id: 2, type: "Brake Inspection", interval_km: 20000 },
    { id: 3, type: "Tire Rotation", interval_km: 15000 },
  ]);
});

app.listen(PORT, () => {
  console.log(`CAF server running on port ${PORT}`);
});
