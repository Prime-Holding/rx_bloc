import {
	addDoc,
	collection,
	CollectionReference,
	DocumentReference,
	onSnapshot,
	query,
	updateDoc,
	where
} from 'firebase/firestore';
import { useCallback, useEffect, useMemo, useState } from 'react';
import { db } from '../../../api/firebase';
import useAuth from '../../authentication/hooks/useAuth';
import Counters from '../types/countersType';
import RemindersLength from '../types/remidnersLengthType';

const countersCollection = 'counters';
const totalCollection = 'remindersLengths';

type CountersDeltaCallback = () => {
	total?: number;
	incomplete?: number;
	complete?: number;
};

interface CountersDelta {
	total: number;
	incomplete: number;
	complete: number;
}

const useReminderCounters = () => {
	const auth = useAuth();

	const [total, setTotal] = useState<number | null>(null);
	const [complete, setComplete] = useState<number | null>(null);
	const [incomplete, setIncomplete] = useState<number | null>(null);

	const [isLoadingCounters, setIsLoadingCounters] = useState(true);
	const [isLoadingLength, setIsLoadingLength] = useState(true);

	// If a counter or total object exists in database
	const [countersRef, setCountersRef] = useState<DocumentReference<Counters> | null>(
		null
	);
	const [totalRef, setTotalRef] = useState<DocumentReference<RemindersLength> | null>(
		null
	);

	const isLoading = isLoadingCounters || isLoadingLength;

	const [countersDelta, setCountersDelta] = useState<CountersDelta>({
		total: 0,
		incomplete: 0,
		complete: 0
	});

	useEffect(() => {
		setIsLoadingLength(true);
		setIsLoadingCounters(true);
		// Get complete/incomplete counter
		const countersQuery = query(
			collection(db, countersCollection) as CollectionReference<Counters>,
			where('authorId', '==', auth.state.user?.id)
		);
		const unsubscribeCounters = onSnapshot(countersQuery, {
			next: (snapshot) => {
				const doc = snapshot.docs[0];
				if (doc) {
					const data = doc.data();
					setComplete(data.complete);
					setIncomplete(data.incomplete);
					setCountersRef(doc.ref);
				} else {
					setComplete(0);
					setIncomplete(0);
					setCountersRef(null);
				}
				setIsLoadingCounters(false);
			},
			error: () => {
				setIsLoadingCounters(false);
			}
		});

		// Get total reminders length
		const totalQuery = query(
			collection(db, totalCollection) as CollectionReference<RemindersLength>,
			where('authorId', '==', auth.state.user.id)
		);

		const unsubscribeTotal = onSnapshot(totalQuery, {
			next: (snapshot) => {
				const doc = snapshot.docs[0];
				if (doc) {
					setTotal(doc.data().length);
					setTotalRef(doc.ref);
				} else {
					setTotal(0);
					setTotalRef(null);
				}
				setIsLoadingLength(false);
			},
			error: () => {
				setIsLoadingCounters(false);
			}
		});

		return () => {
			unsubscribeCounters();
			unsubscribeTotal();
		};
	}, [auth.state.user]);

	const updateCounters = useCallback(
		(incomplete: number, complete: number) => {
			if (countersRef) {
				return updateDoc<Counters>(countersRef, {
					incomplete: Math.max(0, incomplete),
					complete: Math.max(0, complete)
				});
			} else {
				return addDoc<Omit<Counters, 'id'>>(
					collection(db, countersCollection) as CollectionReference<Counters>,
					{
						authorId: auth.state.user.id,
						incomplete: Math.max(0, incomplete),
						complete: Math.max(0, complete)
					}
				);
			}
		},
		[auth.state.user.id, countersRef]
	);

	const updateTotal = useCallback(
		(total: number) => {
			if (totalRef) {
				return updateDoc<RemindersLength>(totalRef, {
					length: Math.max(total, 0)
				});
			} else {
				return addDoc<Omit<RemindersLength, 'id'>>(
					collection(db, totalCollection) as CollectionReference<RemindersLength>,
					{
						authorId: auth.state.user.id,
						length: Math.max(total, 0)
					}
				);
			}
		},
		[auth.state.user.id, totalRef]
	);

	// Apple counters delta values
	useEffect(() => {
		if (isLoading || total === null || incomplete === null || complete === null) {
			return;
		}

		if (
			countersDelta.total === 0 &&
			countersDelta.incomplete === 0 &&
			countersDelta.complete === 0
		) {
			return;
		}

		updateTotal(total + countersDelta.total);
		updateCounters(
			incomplete + countersDelta.incomplete,
			complete + countersDelta.complete
		);

		setCountersDelta({
			total: 0,
			incomplete: 0,
			complete: 0
		});
	}, [
		complete,
		incomplete,
		isLoading,
		countersDelta,
		total,
		updateCounters,
		updateTotal
	]);

	return useMemo(
		() => ({
			isLoading,
			total,
			complete,
			incomplete,
			updateCounters: (fn: CountersDeltaCallback) => {
				const newDelta = fn();
				setCountersDelta((delta) => {
					return {
						total: delta.total + (newDelta.total ?? 0),
						complete: delta.complete + (newDelta.complete ?? 0),
						incomplete: delta.incomplete + (newDelta.incomplete ?? 0)
					};
				});
			}
		}),
		[isLoading, total, complete, incomplete]
	);
};

export default useReminderCounters;
