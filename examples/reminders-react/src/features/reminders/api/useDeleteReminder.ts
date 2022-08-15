import useDeleteDocument from '../../../api/useDeleteDocument';
import { useCallback, useMemo } from 'react';
import useReminderCounters from './useReminderCounters';

const useDeleteReminder = () => {
	const { updateCounters } = useReminderCounters();
	const { mutate, ...other } = useDeleteDocument('reminders');

	const newMutate = useCallback(
		(id: string, isComplete: boolean) => {
			updateCounters(() => ({
				total: -1,
				complete: isComplete ? -1 : 0,
				incomplete: isComplete ? 0 : -1
			}));
			return mutate(id);
		},
		[mutate, updateCounters]
	);

	return useMemo(
		() => ({
			mutate: newMutate,
			...other
		}),
		[newMutate, other]
	);
};

export default useDeleteReminder;
