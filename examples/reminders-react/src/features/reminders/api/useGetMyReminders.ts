import { where } from 'firebase/firestore';
import useAuth from '../../authentication/hooks/useAuth';
import Reminder from '../types/reminderType';
import useInfiniteCollection from '../../../api/useInfiniteCollection';

const useGetMyReminders = () => {
	const { state } = useAuth();
	if (!state.isAuth) {
		throw 'Must be logged in to get reminders';
	}

	return useInfiniteCollection<Reminder>('reminders', 'dueDate', [
		where('authorId', '==', state.isAnonymous ? null : state.user?.id)
	]);
};

export default useGetMyReminders;
