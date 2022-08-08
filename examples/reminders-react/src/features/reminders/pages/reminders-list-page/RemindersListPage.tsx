import useGetMyReminders from '../../api/useGetMyReminders';
import { useEffect } from 'react';
import {
	collection as getCollection,
	onSnapshot,
	query,
	where
} from 'firebase/firestore';
import { db } from '../../../../api/firebase';

const RemindersListPage = () => {
	useEffect(() => {
		const queryRef = query(getCollection(db, 'reminders'), where('authorId', '==', null));
		const unsubscribe = onSnapshot(queryRef, {
			next: (snapshot) => {
				console.log(snapshot.docs.map((doc) => ({ ...doc.data() })));
			},
			error: (error) => {},
			complete: () => {}
		});
		return () => {
			unsubscribe();
		};
	}, []);

	return <div>Reminders Pages</div>;
};

export default RemindersListPage;
