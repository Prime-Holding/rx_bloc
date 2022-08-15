import useEditDocument from '../../../api/useEditDocument';
import Reminder from '../types/reminderType';
import { useMemo } from 'react';
import {
	collection,
	CollectionReference,
	doc,
	getDoc,
	UpdateData
} from 'firebase/firestore';
import useReminderCounters from './useReminderCounters';
import { db } from '../../../api/firebase';

const useEditReminder = () => {
	const { updateCounters } = useReminderCounters();
	const { mutate, ...other } = useEditDocument<Reminder>('reminders');

	return useMemo(
		() => ({
			mutate: (id: string, data: UpdateData<Exclude<Reminder, 'id'>>) => {
				return getDoc(
					doc(collection(db, 'reminders') as CollectionReference<Reminder>, id)
				).then((doc) => {
					if (doc.exists()) {
						const isComplete = doc.data().complete;
						if (data.complete === true && !isComplete) {
							updateCounters(() => ({ complete: +1, incomplete: -1 }));
						}
						if (data.complete === false && isComplete) {
							updateCounters(() => ({ complete: -1, incomplete: +1 }));
						}
					}
					return mutate(id, data);
				});
			},
			...other
		}),
		[mutate, other, updateCounters]
	);
};

export default useEditReminder;
