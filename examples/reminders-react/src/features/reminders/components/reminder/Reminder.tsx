import ReminderType from '../../types/reminderType';
import './reminder.scss';
import EditableText from '../../../../ui-kit/editable-text/EditableText';
import { useCallback, useMemo, useState } from 'react';
import useEditReminder from '../../api/useEditReminder';
import Checkbox from '../../../../ui-kit/checkbox/Checkbox';
import getDateForInput from '../../utils/getDateForInput';
import useDeleteReminder from '../../api/useDeleteReminder';
import { TrashIcon } from '../../../../ui-kit/icons/icons';
import useSnackbar from '../../../../ui-kit/snackbar/useSnackbar';

interface ReminderProps {
	reminder: ReminderType;
}

const Reminder = ({ reminder }: ReminderProps) => {
	const editReminder = useEditReminder();
	const deleteReminder = useDeleteReminder();
	const snackbar = useSnackbar();

	const dueDate = useMemo(() => {
		return reminder.dueDate.toDate();
	}, [reminder.dueDate]);

	const handleTitleChange = useCallback(
		(title: string) => {
			return editReminder.mutate(reminder.id, { title });
		},
		[editReminder, reminder.id]
	);

	const handleDateChange = useCallback(
		(date: string) => {
			if (date.length == 0) return Promise.reject();
			return editReminder.mutate(reminder.id, { dueDate: new Date(date) });
		},
		[editReminder, reminder.id]
	);

	const handleClickCheckbox = () => {
		editReminder.mutate(reminder.id, { complete: !reminder.complete });
	};

	const handleClickDelete = () => {
		deleteReminder.mutate(reminder.id).then(() => {
			snackbar.push('info', `Reminder with title "${reminder.title}" was deleted`);
		});
	};

	return (
		<div className="reminder">
			<Checkbox checked={reminder.complete} onClick={handleClickCheckbox} />
			<EditableText
				value={reminder.title}
				onChange={handleTitleChange}
				type="text"
				className="title"
			>
				{reminder.title}
			</EditableText>
			<EditableText
				value={getDateForInput(dueDate)}
				onChange={handleDateChange}
				type="date"
				className="date"
			>
				{dueDate.toLocaleDateString()}
			</EditableText>
			<TrashIcon onClick={handleClickDelete} className="delete" />
		</div>
	);
};

export default Reminder;
