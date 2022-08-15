import { RouteObject } from 'react-router';
import LoginPage from '../features/authentication/pages/login-page/LoginPage';
import RemindersLayout from '../features/reminders/layout/RemindersLayout';

export interface AppRoute extends RouteObject {
	allowOnlyAuthenticated?: boolean;
	children?: AppRoute[];
}

const routes: AppRoute[] = [
	{
		path: '/login',
		element: <LoginPage />
	},
	{
		path: '/',
		allowOnlyAuthenticated: true,
		children: [
			{
				index: true,
				element: <RemindersLayout />
			},
			{
				path: ':tab',
				element: <RemindersLayout />
			}
		]
	}
];

export default routes;
