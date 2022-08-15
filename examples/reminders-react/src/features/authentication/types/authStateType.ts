import User from './userType';

export default interface AuthStateType {
	user: User;
	isAuthenticated: boolean;
}
