
importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-messaging.js");

///TODO: Make sure you replace this configuration with your own
// If using flavors, you need to manually replace this config before launching the app
var config = {
    apiKey: "replace_me",
    authDomain: "replace_me",
    databaseURL: "replace_me",
    projectId: "replace_me",
    storageBucket: "replace_me",
    messagingSenderId: "replace_me",
    appId: "replace_me",
    measurementId: "replace_me"
};
firebase.initializeApp(config);

const messaging = firebase.messaging();

/// This callback is executed once we receive a message notification while the app is in background
messaging.onBackgroundMessage((m) => {
  console.log("Background message received on Web browser ", m);
});
