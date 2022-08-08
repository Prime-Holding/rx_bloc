import { signInWithPopup } from 'firebase/auth';
import { facebookAuthProvider, firebaseAuth } from '../../../api/firebase';

const signInWithFacebook = () => {
	return signInWithPopup(firebaseAuth, facebookAuthProvider).then(
		(result) => result.user
	);
};

export default signInWithFacebook;
