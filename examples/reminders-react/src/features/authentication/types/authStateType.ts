import User from './userType';

export default interface AuthStateType {
	user: User | null;
	isAnonymous: boolean;
	isAuthenticated: boolean;
}
