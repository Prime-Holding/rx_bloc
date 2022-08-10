import useDeleteDocument from '../../../api/useDeleteDocument';

// TODO UPDATE COUNTERS

const useDeleteReminder = () => {
	return useDeleteDocument('reminders');
};

export default useDeleteReminder;
