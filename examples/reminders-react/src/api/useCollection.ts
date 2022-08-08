import { useEffect, useMemo, useState } from 'react';
import {
	collection as getCollection,
	FirestoreError,
	onSnapshot,
	query,
	QueryConstraint
} from 'firebase/firestore';
import { db } from './firebase';

/**
 * Fetch a collection from the firestore
 * @param collectionName
 * @param constraints
 */
const useCollection = <T extends { id: string }>(
	collectionName: string,
	constraints?: QueryConstraint[]
) => {
	const [data, setData] = useState<T[] | null>();
	const [isLoading, setIsLoading] = useState(false);
	const [error, setError] = useState<FirestoreError | null>(null);

	useEffect(() => {
		setIsLoading(true);
		const queryRef = query(getCollection(db, collectionName), ...(constraints ?? []));
		const unsubscribe = onSnapshot(queryRef, {
			next: (snapshot) => {
				setData(snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() })) as T[]);
				setIsLoading(false);
			},
			error: (error) => {
				setError(error);
			}
		});
		return () => {
			unsubscribe();
		};
		//eslint-disable-next-line react-hooks/exhaustive-deps
	}, [collectionName]);

	return useMemo(
		() => ({
			data,
			isLoading,
			error
		}),
		[data, error, isLoading]
	);
};

export default useCollection;
