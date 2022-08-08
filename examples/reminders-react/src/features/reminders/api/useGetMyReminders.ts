import useCollection from '../../../api/useCollection';
import { where } from 'firebase/firestore';
import useAuth from '../../authentication/hooks/useAuth';
import Reminder from '../types/reminderType';

const useGetMyReminders = () => {
	const { state } = useAuth();
	if (!state.isAuth) {
		throw 'Must be logged in to get reminders';
	}

	return useCollection<Reminder>('reminders', [
		where('authorId', '==', state.isAnonymous ? null : state.user?.id)
	]);
};

export default useGetMyReminders;
