import useAddDocument from '../../../api/useAddDocument';
import { useCallback, useMemo } from 'react';
import useAuth from '../../authentication/hooks/useAuth';

interface CreateReminderType {
	authorId: string | null;
	title: string;
	dueDate: Date | string;
	complete: boolean;
}

// TODO UPDATE COUNTER
const useAddReminder = () => {
	const { state } = useAuth();

	const addDocument = useAddDocument<CreateReminderType>('reminders');

	const newMutate = useCallback(
		(data: Omit<CreateReminderType, 'authorId'>) => {
			return addDocument.mutate({
				title: data.title,
				dueDate: new Date(data.dueDate),
				complete: data.complete,
				authorId: state.user.id
			});
		},
		[addDocument, state.user]
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
