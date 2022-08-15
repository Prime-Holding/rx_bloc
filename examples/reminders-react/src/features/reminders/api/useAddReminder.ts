import useAddDocument from '../../../api/useAddDocument';
import { useCallback, useMemo } from 'react';
import useAuth from '../../authentication/hooks/useAuth';
import useReminderCounters from './useReminderCounters';

interface CreateReminderType {
	authorId: string | null;
	title: string;
	dueDate: Date | string;
	complete: boolean;
}

const useAddReminder = () => {
	const { updateCounters } = useReminderCounters();
	const { state } = useAuth();

	const addDocument = useAddDocument<CreateReminderType>('reminders');

	const newMutate = useCallback(
		(data: Omit<CreateReminderType, 'authorId'>) => {
			return addDocument
				.mutate({
					title: data.title,
					dueDate: new Date(data.dueDate),
					complete: data.complete,
					authorId: state.user.id
				})
				.then(() => {
					updateCounters(() => ({
						total: +1,
						complete: data.complete ? +1 : 0,
						incomplete: data.complete ? 0 : +1
					}));
				});
		},
		[addDocument, updateCounters, state.user.id]
	);

	return useMemo(
		() => ({
			...addDocument,
			mutate: newMutate
		}),
		[addDocument, newMutate]
	);
};

export default useAddReminder;
