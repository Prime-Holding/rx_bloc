import { initializeApp } from 'firebase/app';
import { getAuth } from 'firebase/auth';

const firebaseConfig = {
	apiKey: 'AIzaSyDfVKNr-Zjw160xR-HhU5CE1g0uguRs_a0',
	authDomain: 'reminders-app-dev-22840.firebaseapp.com',
	projectId: 'reminders-app-dev-22840',
	storageBucket: 'reminders-app-dev-22840.appspot.com',
	messagingSenderId: '422301301950',
	appId: '1:422301301950:web:49a4d149a52d52608272ef',
	measurementId: 'G-CLPM2G325B'
};

// Initialize Firebase
export const firebaseApp = initializeApp(firebaseConfig);
export const firebaseAuth = getAuth(firebaseApp);
