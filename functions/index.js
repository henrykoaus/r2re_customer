/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

const admin = require("firebase-admin");

const serviceAccount = require(
    "./r2re-75417-firebase-adminsdk-qjgdb-3bfb334a23.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)});

exports.createCustomToken = onRequest({
  region: ["asia-northeast3"]},
async (request, response) => {
  const user = request.body;
  const uid = `social:${user.uid}`;
  const updateParams = {
    email: user.email,
    photoURL: user.photoURL,
    displayName: user.displayName,
  };
  try {
    await admin.auth().updateUser(uid, updateParams);
  } catch (e) {
    updateParams["uid"] = uid;
    await admin.auth().createUser(updateParams);
  }
  const customToken = await admin.auth().createCustomToken(uid);
  response.send(customToken);
});
