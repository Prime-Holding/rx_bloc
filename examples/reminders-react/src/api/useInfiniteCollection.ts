import { useCallback, useState } from 'react';
import {
	collection as getCollection,
	onSnapshot,
	query,
	QueryConstraint
} from 'firebase/firestore';
import { db } from './firebase';

const useInfiniteCollection = <T extends { id: string }>(
	collectionName: string,
	initialLoad: number,
	constraints?: QueryConstraint[]
) => {
	const [data, setData] = useState<T[] | null>(null);
	const [queries, setQueries] = useState([]);

	const createQuery = useCallback(() => {
		const queryRef = query(getCollection(db, collectionName), ...(constraints ?? []));
		const unsubscribe = onSnapshot(queryRef, {
			next: (snapshot) => {
				setData(snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() })) as T[]);
			},
			error: (error) => {
				// TODO
			},
			complete: () => {
				// TODO
			}
		});
	}, [collectionName, constraints]);
};

export default useInfiniteCollection;
