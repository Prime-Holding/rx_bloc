import { RouteObject } from 'react-router';
import LoginPage from '../features/authentication/pages/login-page/LoginPage';
import DashboardPage from '../features/reminders/pages/dashboard-page/DashboardPage';
import RemindersListPage from '../features/reminders/pages/reminders-list-page/RemindersListPage';
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
		element: <RemindersLayout />,
		children: [
			{
				index: true,
				element: <DashboardPage />
			},
			{
				path: 'dashboard',
				element: <DashboardPage />
			},
			{
				path: 'reminders',
				element: <RemindersListPage />
			}
		]
	}
];

export default routes;
