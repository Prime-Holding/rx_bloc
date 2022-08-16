import { useNavigate, useParams } from 'react-router-dom';
import useAuth from '../../authentication/hooks/useAuth';
import { AppBar, IconButton, Tab, Tabs, Toolbar } from '@mui/material';
import LogoutIcon from '@mui/icons-material/Logout';
import DashboardPage from '../pages/dashboard-page/DashboardPage';
import RemindersListPage from '../pages/reminders-list-page/RemindersListPage';

const RemindersLayout = () => {
	const auth = useAuth();
	const { tab } = useParams();
	const navigate = useNavigate();

	return (
		<div>
			<AppBar position="sticky">
				<Toolbar variant="dense">
					<IconButton sx={{ marginLeft: 'auto' }} color="inherit" onClick={auth.signOut}>
						<LogoutIcon />
					</IconButton>
				</Toolbar>
				<Tabs
					value={tab ?? 'dashboard'}
					onChange={(e, tab) => navigate(`/${tab}`)}
					textColor="inherit"
					variant="fullWidth"
				>
					<Tab value="dashboard" label="Dashboard" />
					<Tab value="reminders" label="reminders" />
				</Tabs>
			</AppBar>
			<div>
				{(tab === undefined || tab === 'dashboard') && <DashboardPage />}
				{tab === 'reminders' && <RemindersListPage />}
			</div>
		</div>
	);
};

export default RemindersLayout;
