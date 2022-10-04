const functions = require("firebase-functions");

// The Firebase Admin SDK to access Firestore.
const admin = require("firebase-admin");
admin.initializeApp();

exports.createUser = functions.auth.user().onCreate(async (user) => {
  console.log(user);
  await admin
    .firestore()
    .collection("user")
    .doc(user)
    .set({email: user.email, name: user.displayName});
});
