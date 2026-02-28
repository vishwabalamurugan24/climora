const admin = require('firebase-admin');
const fs = require('fs');

// IMPORTANT: Path to your service account key file
const serviceAccount = require('./serviceAccountKey.json');

// Your project's database URL
const databaseURL = 'https://climora-app-default-rtdb.firebaseio.com'; // Replace with your actual database URL

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: databaseURL
});

const db = admin.firestore();
const destinations = JSON.parse(fs.readFileSync('destinations.json', 'utf8'));

async function uploadDestinations() {
  console.log('Starting to upload destinations...');
  const collectionRef = db.collection('tourist_destinations');

  for (const dest of destinations) {
    // Firestore needs a GeoPoint object for locations
    // For this example, we'll generate random coordinates.
    // In a real scenario, you'd have these in your JSON.
    const lat = 34.0522 + (Math.random() - 0.5);
    const lon = -118.2437 + (Math.random() - 0.5);

    const docData = {
      ...dest,
      location: new admin.firestore.GeoPoint(lat, lon)
    };

    await collectionRef.add(docData);
    console.log(`Added: ${dest.name}`);
  }

  console.log('All destinations have been uploaded successfully!');
}

uploadDestinations().catch(console.error);