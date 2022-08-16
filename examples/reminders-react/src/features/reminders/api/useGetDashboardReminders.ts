import useCollection from '../../../api/useCollection';
import { limit, orderBy, where } from 'firebase/firestore';
import useAuth from '../../authentication/hooks/useAuth';
import Reminder from '../types/reminderType';

const days10 = 10 * 24 * 60 * 60 * 1000;

const useGetDashboardReminders = () => {
	const auth = useAuth();

	return useCollection<Reminder>('reminders', [
		where('authorId', '==', auth.state.user.id),
		where('complete', '==', false),
		where('dueDate', '<=', new Date()),
		where('dueDate', '>=', new Date(Date.now() - days10)),
		orderBy('dueDate'),
		limit(10)
	]);
};

export default useGetDashboardReminders;
