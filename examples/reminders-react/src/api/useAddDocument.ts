import { useMemo } from 'react';
import { addDoc, collection } from 'firebase/firestore';
import { db } from './firebase';

const useAddDocument = <T>(collectionName: string) => {
	return useMemo(
		() => ({
			mutate: (data: T) => {
				return addDoc(collection(db, collectionName), data);
			}
		}),
		[collectionName]
	);
};

export default useAddDocument;
