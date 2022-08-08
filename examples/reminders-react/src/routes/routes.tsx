import { RouteObject } from 'react-router';
import LoginPage from '../features/authentication/pages/login-page/LoginPage';

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
		element: <div />
	}
];

export default routes;
