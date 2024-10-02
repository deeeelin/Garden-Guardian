// const { logger, https } = require("firebase-functions/v2");

// const admin = require("firebase-admin");
// const { FieldValue } = require("firebase-admin/firestore");
// const {
//   onDocumentCreated,
//   onDocumentDeleted,
//   onDocumentUpdated,
// } = require("firebase-functions/v2/firestore");
// const { user } = require("firebase-functions/v1/auth");

// admin.initializeApp({
//   credential: admin.credential.applicationDefault(),
// });
// const db = admin.firestore();
// const userCollection = db.collection('user');

// exports.storeInDatabase = https.onCall(async (req) => {
//   try {
//     const { role, text, base64ImageUrl, timeStamp, imageDescription, stringtoEmbed } = req.data;

//     logger.log('Received request to store in database', { role, text, base64ImageUrl, timeStamp, imageDescription, stringtoEmbed });

//     await userCollection.add({
//       role: role || 'user',
//       text: text || '',
//       base64ImageUrl: base64ImageUrl || '',
//       timeStamp: timeStamp || new Date().toISOString(),
//       imageDescription: imageDescription || '',
//       stringtoEmbed: stringtoEmbed || '',
//       servertimeStamp: FieldValue.serverTimestamp() || ''
//     });

//     logger.log('Data stored successfully in Firestore', { role, text });

//     return { success: true, message: 'Data stored successfully' };
//   } catch (error) {
//     logger.error("storeInDatabase: Error processing HTTP request", error);
//     throw new https.HttpsError("internal", "Internal server error.");
//   }
// });
