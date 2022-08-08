import { Link, Outlet } from 'react-router-dom';

const RemindersLayout = () => {
	return (
		<div>
			<Link to="/dashboard">Dashboard</Link>
			<Link to="/reminders">Reminders</Link>
			<div>
				<Outlet />
			</div>
		</div>
	);
};

export default RemindersLayout;
