import { Timestamp } from 'firebase/firestore';

export default interface Reminder {
	id: string;
	authorId: string | null;
	complete: boolean;
	dueDate: Timestamp;
	title: string;
}
