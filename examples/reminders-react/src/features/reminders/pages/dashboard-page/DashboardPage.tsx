import { Box, Grid, List, Typography } from '@mui/material';
import './dashboard-page.scss';
import useGetDashboardReminders from '../../api/useGetDashboardReminders';
import useReminderCounters from '../../api/useReminderCounters';
import Reminder from '../../components/reminder/Reminder';
import AssignmentTurnedInIcon from '@mui/icons-material/AssignmentTurnedIn';
import HourglassEmptyIcon from '@mui/icons-material/HourglassEmpty';
import FullscreenLoader from '../../../../ui-kit/fullscreen-loader/FullscreenLoader';

const DashboardPage = () => {
	const { complete, incomplete, isLoading: isLoadingCounters } = useReminderCounters();
	const { data: reminders, isLoading: isLoadingReminders } = useGetDashboardReminders();

	const isLoading = isLoadingCounters || isLoadingReminders;

	return (
		<div className="dashboard-page">
			{isLoading ? (
				<FullscreenLoader />
			) : (
				<Grid container spacing={3}>
					<Grid item xs={12} md={6}>
						<Typography align="center">Incomplete</Typography>
						<Box className="counter">
							<HourglassEmptyIcon />
							<span>{incomplete}</span>
						</Box>
					</Grid>
					<Grid item xs={12} md={6}>
						<Typography align="center">Complete</Typography>
						<Box className="counter">
							<AssignmentTurnedInIcon />
							<span>{complete}</span>
						</Box>
					</Grid>
					{reminders && reminders.length > 0 ? (
						<Grid item xs={12}>
							<Typography variant="h5" fontWeight="bold">
								Overdue
							</Typography>
							<List className="reminders-list">
								{reminders.map((reminder) => (
									<Reminder key={reminder.id} reminder={reminder} />
								))}
							</List>
						</Grid>
					) : (
						<Grid item xs={12}>
							<Typography align="center">You have no reminders due soon</Typography>
						</Grid>
					)}
				</Grid>
			)}
		</div>
	);
};

export default DashboardPage;
