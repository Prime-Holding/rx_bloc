import { useMemo } from 'react';
import { doc, updateDoc, DocumentReference, UpdateData } from 'firebase/firestore';
import { db } from './firebase';

const useEditDocument = <T extends { id: string }>(collectionName: string) => {
	return useMemo(
		() => ({
			mutate: (id: string, data: UpdateData<Exclude<T, 'id'>>) => {
				const docRef = doc(db, collectionName, id) as DocumentReference<Exclude<T, 'id'>>;
				return updateDoc<Exclude<T, 'id'>>(docRef, data);
			}
		}),
		[collectionName]
	);
};

export default useEditDocument;
