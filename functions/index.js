
const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendNotification = functions.https.onCall(async (data, context) => {
    await admin.messaging().sendToTopic(
        data.topic,
        {
            data: {
                title: data.title,
                body: data.body,
            },
            notification: {
                title: data.title,
                body: data.body,
                sound: "default",
            },
        },
    );
});

