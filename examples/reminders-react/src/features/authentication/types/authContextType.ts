import AuthStateType from './authStateType';

export default interface AuthContextType {
	isInitialLoading: boolean;
	isLoading: boolean;
	signInAnonymously: () => void;
	signInWithFacebook: () => void;
	signOut: () => void;
	state: AuthStateType;
}
