import { RouteObject } from 'react-router';
import LoginPage from '../features/authentication/pages/login-page/LoginPage';
import { firebaseAuth } from '../api/firebase';

export interface AppRoute extends RouteObject {
	onlyAuth?: boolean;
	children?: AppRoute[];
}

const routes: AppRoute[] = [
	{
		path: '/login',
		element: <LoginPage />
	},
	{
		path: '/',
		onlyAuth: true,
		// Temporary
		element: (
			<div>
				<button onClick={() => firebaseAuth.signOut()}>Logout</button>
			</div>
		)
	}
];

export default routes;
