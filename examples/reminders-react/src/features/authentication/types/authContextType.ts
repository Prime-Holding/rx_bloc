import AuthStateType from './authStateType';

export default interface AuthContextType {
	signInAnonymously: () => void;
	signInWithFacebook: () => void;
	signOut: () => void;
	state: AuthStateType;
}
