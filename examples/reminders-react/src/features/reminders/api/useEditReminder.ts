import useEditDocument from '../../../api/useEditDocument';
import Reminder from '../types/reminderType';

const useEditReminder = () => {
	return useEditDocument<Reminder>('reminders');
};

export default useEditReminder;
