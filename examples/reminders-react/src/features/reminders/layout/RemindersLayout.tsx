import { Link, Outlet } from 'react-router-dom';
import useAuth from '../../authentication/hooks/useAuth';

const RemindersLayout = () => {
	const auth = useAuth();

	return (
		<div>
			<Link to="/dashboard">Dashboard</Link>
			<Link to="/reminders">Reminders</Link>
			<button onClick={auth.signOut}>Logout</button>
			<div>
				<Outlet />
			</div>
		</div>
	);
};

export default RemindersLayout;
