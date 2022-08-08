import { useCallback, useEffect, useMemo, useRef, useState } from 'react';
import {
	collection,
	onSnapshot,
	query,
	orderBy,
	startAfter,
	limit,
	QueryConstraint,
	QuerySnapshot,
	Unsubscribe
} from 'firebase/firestore';
import { db } from './firebase';

interface QueryEntry<T> {
	index: number;
	startAfter: T | undefined;
	limit: number;
	unsubscribe: Unsubscribe;
}

const useInfiniteCollection = <T extends { id: string }>(
	collectionName: string,
	orderByKey: keyof T & string,
	constraints?: QueryConstraint[]
) => {
	const queries = useRef<QueryEntry<T>[]>([]);
	const [queryData, setQueryData] = useState<T[][]>([]);
	const [isLoading, setIsLoading] = useState(false);

	const data = useMemo<T[]>(() => {
		return queryData.reduce((prev, current) => [...prev, ...current], []);
	}, [queryData]);

	const hasMore = useMemo(() => {
		return queryData.at(-1)?.length != 0;
	}, [queryData]);

	const handleNextQueryData = useCallback((index: number, snapshot: QuerySnapshot) => {
		setQueryData((prev) => {
			const data = [...prev];
			data[index] = snapshot.docs.map((doc) => ({
				id: doc.id,
				...doc.data()
			})) as T[];
			return data;
		});

		// Check if some items were removed
		const hasRemoved = snapshot.docChanges().some((change) => change.type == 'removed');

		// If some items are removed, this means that every query after this one must be recreated
		if (hasRemoved) {
			const toRemove = queries.current.slice(index + 1);
			const totalRemovedItems = toRemove.reduce(
				(prev, current) => prev + current.limit,
				0
			);
			toRemove.forEach((query) => query.unsubscribe());
			setQueryData((data) => [
				...data.slice(0, index + 1), // Get data for queries after this one
				data.slice(index + 1).reduce((prev, current) => [...prev, ...current], []) // Combine data for every query after this one into one
			]);

			queries.current = [
				...queries.current.slice(0, index + 1),
				createQuery(index + 1, totalRemovedItems, snapshot.docs.at(-1)?.data() as T)
			];
		}

		setIsLoading(false);
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, []);

	const createQuery = useCallback(
		(index: number, limitCount: number, startAfterRef?: T) => {
			setIsLoading(true);

			const queryConstraints = [
				...(constraints ?? []),
				orderBy(orderByKey, 'asc'),
				limit(limitCount)
			];
			if (startAfterRef) {
				queryConstraints.push(startAfter(startAfterRef[orderByKey]));
			}

			const queryRef = query(collection(db, collectionName), ...queryConstraints);
			const unsubscribe = onSnapshot(queryRef, {
				next: (snapshot) => {
					handleNextQueryData(index, snapshot);
				}
			});

			return {
				index,
				unsubscribe,
				limit: limitCount,
				startAfter: startAfterRef
			};
		},
		[collectionName, constraints, handleNextQueryData, orderByKey]
	);

	const next = useCallback(
		(count: number) => {
			if (isLoading || !hasMore) {
				return;
			}
			let lastItem: T | undefined = data.at(-1);
			const queryEntry = createQuery(queries.current.length, count, lastItem);
			queries.current = [...queries.current, queryEntry];
		},
		[createQuery, data, hasMore, isLoading]
	);

	useEffect(() => {
		return () => {
			queries.current.forEach((query) => query.unsubscribe());
		};
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, []);

	return useMemo(
		() => ({
			isLoading,
			hasMore,
			next,
			data
		}),
		[isLoading, hasMore, next, data]
	);
};

export default useInfiniteCollection;
