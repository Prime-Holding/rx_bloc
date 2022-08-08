import { createContext, ReactNode, useCallback, useMemo, useState } from 'react';
import AuthContextType from '../types/authContextType';
import AuthStateType from '../types/authStateType';

export const AuthContext = createContext<AuthContextType>(
	null as unknown as AuthContextType
);

interface AuthProviderProps {
	children: ReactNode;
}

const AuthProvider = ({ children }: AuthProviderProps) => {
	const [state, setState] = useState<AuthStateType>({
		user: null,
		isAuth: false,
		isAnonymous: false
	});

	const signInWithFacebook = useCallback(() => {}, []);

	const signInAnonymously = useCallback(() => {
		setState({
			user: null,
			isAuth: true,
			isAnonymous: true
		});
	}, []);

	const signOut = useCallback(() => {
		setState({
			user: null,
			isAuth: false,
			isAnonymous: false
		});
	}, []);

	const context = useMemo<AuthContextType>(
		() => ({
			state,
			signInWithFacebook,
			signInAnonymously,
			signOut
		}),
		[signInAnonymously, signInWithFacebook, signOut, state]
	);

	return <AuthContext.Provider value={context}>{children}</AuthContext.Provider>;
};

export default AuthProvider;
