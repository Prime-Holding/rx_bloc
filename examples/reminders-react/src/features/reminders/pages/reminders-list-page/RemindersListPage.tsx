import useGetMyReminders from '../../api/useGetMyReminders';
import { useCallback, useEffect, useMemo, useState } from 'react';
import Reminder from '../../components/reminder/Reminder';
import './reminderList.scss';
import FloatingActionButton from '../../../../ui-kit/floating-action-button/FloatingActionButton';
import CreateReminderModal from '../../components/create-reminder-modal/CreateReminderModal';
import useAddReminder from '../../api/useAddReminder';
import Loader from '../../../../ui-kit/loader/Loader';
import { AddIcon } from '../../../../ui-kit/icons/icons';
import useSnackbar from '../../../../ui-kit/snackbar/useSnackbar';

const RemindersListPage = () => {
	const { data: rawReminders, isLoading, hasMore, next } = useGetMyReminders();
	const addReminder = useAddReminder();
	const snackbar = useSnackbar();

	const [isCreateOpen, setIsCreateOpen] = useState(false);

	const reminders = useMemo(() => {
		const startToday = new Date();
		startToday.setHours(0, 0, 0, 0);

		const endToday = new Date();
		endToday.setHours(23, 59, 59, 999);

		const endMonth = new Date(endToday);
		endMonth.setMonth(endMonth.getMonth() + 1, 0);

		const endYear = new Date(endToday);
		endYear.setMonth(11, 31);

		return {
			overdue: rawReminders.filter((reminder) => {
				const date = reminder.dueDate.toDate();
				return date <= startToday;
			}),
			today: rawReminders.filter((reminder) => {
				const date = reminder.dueDate.toDate();
				return date >= startToday && date <= endToday;
			}),
			thisMonth: rawReminders.filter((reminder) => {
				const date = reminder.dueDate.toDate();
				return date > endToday && date <= endMonth;
			}),
			thisYear: rawReminders.filter((reminder) => {
				const date = reminder.dueDate.toDate();
				return date > endMonth && date <= endYear;
			}),
			future: rawReminders.filter((reminder) => {
				const date = reminder.dueDate.toDate();
				return date > endYear;
			})
		};
	}, [rawReminders]);

	// Initial loading of reminders
	useEffect(() => {
		next(30);
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, []);

	useEffect(() => {
		const handler = () => {
			const scrollTop = document.documentElement.scrollTop;
			const scrollMax =
				document.documentElement.scrollHeight - document.documentElement.clientHeight;

			if (scrollTop > scrollMax - 200) {
				next(25);
			}
		};
		document.addEventListener('scroll', handler);
		return () => {
			document.removeEventListener('scroll', handler);
		};
	}, [next]);

	const handleCreateReminder = useCallback(
		(data: { date: string; title: string }) => {
			addReminder
				.mutate({ title: data.title, dueDate: data.date, complete: false })
				.then(() => {
					snackbar.push('info', `Snackbar with title "${data.title}" was created.`);
				});
			setIsCreateOpen(false);
		},
		[addReminder, snackbar]
	);

	return (
		<div className="reminder-list-page">
			<FloatingActionButton icon={AddIcon} onClick={() => setIsCreateOpen(true)} />
			<CreateReminderModal
				isOpen={isCreateOpen}
				onClose={() => setIsCreateOpen(false)}
				onCreate={handleCreateReminder}
			/>
			<div className="sections">
				{!isLoading && !hasMore && rawReminders.length == 0 && (
					<p>You have no reminders.</p>
				)}
				{reminders.overdue.length > 0 && (
					<div className="section">
						<div className="section-title">Overdue</div>
						<div className="section-items">
							{reminders.overdue.map((reminder) => (
								<Reminder key={reminder.id} reminder={reminder} />
							))}
						</div>
					</div>
				)}

				{reminders.today.length > 0 && (
					<div className="section">
						<div className="section-title">Today</div>
						<div className="section-items">
							{reminders.today.map((reminder) => (
								<Reminder key={reminder.id} reminder={reminder} />
							))}
						</div>
					</div>
				)}

				{reminders.thisMonth.length > 0 && (
					<div className="section">
						<div className="section-title">This month</div>
						<div className="section-items">
							{reminders.thisMonth.map((reminder) => (
								<Reminder key={reminder.id} reminder={reminder} />
							))}
						</div>
					</div>
				)}

				{reminders.thisYear.length > 0 && (
					<div className="section">
						<div className="section-title">This year</div>
						<div className="section-items">
							{reminders.thisYear.map((reminder) => (
								<Reminder key={reminder.id} reminder={reminder} />
							))}
						</div>
					</div>
				)}

				{reminders.future.length > 0 && (
					<div className="section">
						<div className="section-title">Future</div>
						<div className="section-items">
							{reminders.future.map((reminder) => (
								<Reminder key={reminder.id} reminder={reminder} />
							))}
						</div>
					</div>
				)}
			</div>
			{isLoading && (
				<div className="loader-container">
					<Loader />
				</div>
			)}
		</div>
	);
};

export default RemindersListPage;
