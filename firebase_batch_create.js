// Firebase Batch Import Script
// Run this in Firebase Console → Firestore → Browser Developer Console

// 1. Go to Firebase Console Firestore page
// 2. Open Browser Developer Tools (F12)
// 3. Go to Console tab
// 4. Paste this entire script and press Enter

console.log('🚀 Starting Firebase Batch Import...');

// Your insights data (first 10 for testing)
const sampleInsights = [
  {
    "id": "0-test1",
    "number": 0,
    "text": "Your infinite potential-void nature suggests you choose: from zero, all numbers are born.",
    "category": "insight",
    "system": "number",
    "quality_score": 1.0
  },
  {
    "id": "1-test1",
    "number": 1,
    "text": "Leadership flows through you naturally when you trust your authentic voice.",
    "category": "insight",
    "system": "number",
    "quality_score": 1.0
  },
  {
    "id": "2-test1",
    "number": 2,
    "text": "Cooperation and balance create the foundation for lasting partnerships.",
    "category": "insight",
    "system": "number",
    "quality_score": 1.0
  }
];

// Function to create documents using Firebase SDK already loaded in console
async function batchCreate() {
  const db = firebase.firestore();
  const batch = db.batch();

  sampleInsights.forEach(insight => {
    const docRef = db.collection('insights_staging').doc(insight.id);
    batch.set(docRef, {
      text: insight.text,
      number: insight.number,
      category: insight.category,
      system: insight.system,
      quality_score: insight.quality_score,
      created_at: firebase.firestore.FieldValue.serverTimestamp()
    });
  });

  try {
    await batch.commit();
    console.log('✅ Successfully created sample insights!');
    console.log('Check your Firestore Database for insights_staging collection');
  } catch (error) {
    console.error('❌ Error creating insights:', error);
  }
}

// Run the batch creation
batchCreate();
