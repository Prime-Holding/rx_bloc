import { useMemo } from 'react';
import { doc, DocumentReference, UpdateData, updateDoc } from 'firebase/firestore';
import { db } from './firebase';
import BaseDocumentType from './baseDocumentType';

const useEditDocument = <T extends BaseDocumentType>(collectionName: string) => {
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
