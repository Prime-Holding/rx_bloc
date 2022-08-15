import { Link, Outlet } from 'react-router-dom';
import useAuth from '../../authentication/hooks/useAuth';
import { AppBar, IconButton, Toolbar } from '@mui/material';
import RefreshIcon from '@mui/icons-material/Refresh';
import LogoutIcon from '@mui/icons-material/Logout';

const RemindersLayout = () => {
	const auth = useAuth();

	return (
		<div>
			<AppBar position="sticky">
				<Toolbar variant="dense">
					<IconButton color="inherit">
						<RefreshIcon />
					</IconButton>
					<IconButton sx={{ marginLeft: 'auto' }} color="inherit" onClick={auth.signOut}>
						<LogoutIcon />
					</IconButton>
				</Toolbar>
			</AppBar>
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
