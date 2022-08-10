import useAuth from '../features/authentication/hooks/useAuth';
import {
	matchRoutes,
	RouteMatch,
	useLocation,
	Navigate,
	renderMatches
} from 'react-router';
import routes, { AppRoute } from './routes';

interface AppRouteMatch extends RouteMatch {
	route: AppRoute;
}

const AppRoutes = () => {
	const { state } = useAuth();
	const location = useLocation();
	const matches = matchRoutes(routes, location) as AppRouteMatch[] | null;

	if (matches) {
		for (const match of matches) {
			if (!state.isAuthenticated) {
				if (match.route.allowOnlyAuthenticated) {
					return <Navigate to="/login" replace={true} />;
				}
			}
		}
	}

	return renderMatches(matches);
};

export default AppRoutes;
