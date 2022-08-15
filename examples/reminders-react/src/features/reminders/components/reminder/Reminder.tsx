import ReminderType from '../../types/reminderType';
import './reminder.scss';
import EditableText from '../../../../ui-kit/editable-text/EditableText';
import { useCallback, useMemo, useState } from 'react';
import useEditReminder from '../../api/useEditReminder';
import getDateForInput from '../../utils/getDateForInput';
import useDeleteReminder from '../../api/useDeleteReminder';
import {
	IconButton,
	ListItem,
	ListItemIcon,
	ListItemText,
	Menu,
	MenuItem
} from '@mui/material';
import MoreVertIcon from '@mui/icons-material/MoreVert';
import DeleteIcon from '@mui/icons-material/DeleteOutline';
import CheckBoxOutlineBlankIcon from '@mui/icons-material/CheckBoxOutlineBlank';
import CheckBoxIcon from '@mui/icons-material/CheckBox';
import { useSnackbar } from 'notistack';

interface ReminderProps {
	reminder: ReminderType;
}

const Reminder = ({ reminder }: ReminderProps) => {
	const editReminder = useEditReminder();
	const deleteReminder = useDeleteReminder();
	const { enqueueSnackbar } = useSnackbar();

	const [menuAnchorEl, setMenuAnchorEl] = useState<Element | null>(null);
	const isMenuOpen = !!menuAnchorEl;

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
			if (date.length == 0) return;
			return editReminder.mutate(reminder.id, { dueDate: new Date(date) });
		},
		[editReminder, reminder.id]
	);

	const handleToggleComplete = () => {
		editReminder.mutate(reminder.id, { complete: !reminder.complete });
	};

	const handleClickDelete = () => {
		deleteReminder.mutate(reminder.id, reminder.complete).then(() => {
			enqueueSnackbar(`Reminder with title "${reminder.title}" was deleted`);
		});
	};

	return (
		<ListItem className={`reminder ${reminder.complete ? 'complete' : ''}`}>
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
			<IconButton onClick={(event) => setMenuAnchorEl(event.currentTarget)}>
				<MoreVertIcon />
			</IconButton>
			<Menu
				open={isMenuOpen}
				anchorEl={menuAnchorEl}
				anchorOrigin={{ horizontal: 'right', vertical: 'bottom' }}
				onClose={() => setMenuAnchorEl(null)}
			>
				<MenuItem onClick={handleToggleComplete}>
					<ListItemIcon>
						{!reminder.complete ? (
							<CheckBoxOutlineBlankIcon />
						) : (
							<CheckBoxIcon color="success" />
						)}
					</ListItemIcon>
					<ListItemText primary={reminder.complete ? 'Uncomplete' : 'Complete'} />
				</MenuItem>
				<MenuItem onClick={handleClickDelete}>
					<ListItemIcon>
						<DeleteIcon color="error" />
					</ListItemIcon>
					<ListItemText primary="Delete" />
				</MenuItem>
			</Menu>
		</ListItem>
	);
};

export default Reminder;
