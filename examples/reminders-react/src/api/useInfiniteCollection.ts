import { useCallback, useEffect, useMemo, useRef, useState } from 'react';
import {
	collection,
	onSnapshot,
	query,
	orderBy,
	startAfter,
	endAt,
	limit,
	QueryConstraint,
	QuerySnapshot,
	Unsubscribe
} from 'firebase/firestore';
import { db } from './firebase';

interface QueryEntry<T> {
	index: number;
	startAfter?: T;
	endAt?: T;
	limit?: number;
	unsubscribe: Unsubscribe;
}

interface QueryConfig<T> {
	index: number;
	startAfter?: T;
	endAt?: T;
	limit?: number;
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

	const handleNextSnapshot = useCallback((index: number, snapshot: QuerySnapshot) => {
		setQueryData((prev) => {
			const data = [...prev];
			data[index] = snapshot.docs.map((doc) => ({
				id: doc.id,
				...doc.data()
			})) as T[];
			return data;
		});
		const currentQuery = queries.current[index];
		currentQuery.endAt = snapshot.docs.at(-1)?.data() as T;

		// Check if some items were removed
		const hasRemoved = snapshot.docChanges().some((change) => change.type == 'removed');

		// If some items are removed, this means that the next query should be refreshed
		if (hasRemoved) {
			const nextQuery = queries.current[index + 1];
			if (nextQuery) {
				nextQuery.unsubscribe();
				// Replace the next query with a new query
				queries.current[index + 1] = createQuery({
					index: index + 1,
					startAfter: snapshot.docs.at(-1)?.data() as T,
					endAt: nextQuery.endAt
				});
			}
		}

		setIsLoading(false);
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, []);

	const createQuery = useCallback(
		(config: QueryConfig<T>): QueryEntry<T> => {
			setIsLoading(true);

			const queryConstraints = [...(constraints ?? []), orderBy(orderByKey, 'asc')];
			if (config.limit) {
				queryConstraints.push(limit(config.limit));
			}
			if (config.startAfter) {
				queryConstraints.push(startAfter(config.startAfter[orderByKey]));
			}
			if (config.endAt) {
				queryConstraints.push(endAt(config.endAt[orderByKey]));
			}

			const queryRef = query(collection(db, collectionName), ...queryConstraints);
			const unsubscribe = onSnapshot(queryRef, {
				next: (snapshot) => {
					handleNextSnapshot(config.index, snapshot);
				}
			});

			return {
				index: config.index,
				unsubscribe,
				limit: config.limit,
				startAfter: config.startAfter
			};
		},
		[collectionName, constraints, handleNextSnapshot, orderByKey]
	);

	const next = useCallback(
		(count: number) => {
			if (isLoading || !hasMore) {
				return;
			}
			let lastItem: T | undefined = data.at(-1);
			const queryEntry = createQuery({
				index: queries.current.length,
				limit: count,
				startAfter: lastItem
			});
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
