import { useMemo } from 'react';
import { deleteDoc, doc } from 'firebase/firestore';
import { db } from './firebase';

const useDeleteDocument = (collectionName: string) => {
	return useMemo(
		() => ({
			mutate: (id: string) => {
				return deleteDoc(doc(db, collectionName, id));
			}
		}),
		[collectionName]
	);
};

export default useDeleteDocument;
