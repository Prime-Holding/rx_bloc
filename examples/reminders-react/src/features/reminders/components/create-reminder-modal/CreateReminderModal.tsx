import { useCallback, useEffect, useState } from 'react';
import getDateForInput from '../../utils/getDateForInput';
import {
	Box,
	Button,
	Dialog,
	DialogActions,
	DialogContent,
	DialogTitle,
	FormLabel,
	Grid,
	TextField
} from '@mui/material';

interface CreateReminderModalProps {
	isOpen: boolean;
	onClose: () => void;
	onCreate: (data: { title: string; date: string }) => void;
}

const CreateReminderModal = ({ isOpen, onClose, onCreate }: CreateReminderModalProps) => {
	const [title, setTitle] = useState('');
	const [date, setDate] = useState(getDateForInput(new Date()));
	const [error, setError] = useState('');

	useEffect(() => {
		setError('');
	}, [isOpen]);

	const handleClickCreate = useCallback(() => {
		if (title.length == 0 || date.length == 0) {
			setError('A title and date must be specified.');
			return;
		}
		onCreate({ title, date });
		setTitle('');
		setDate(getDateForInput(new Date()));
	}, [date, onCreate, title]);

	return (
		<Dialog className="create-reminder-modal" open={isOpen} onClose={onClose}>
			<DialogTitle>Add Reminder</DialogTitle>
			<DialogContent>
				<Grid container spacing={1}>
					<Grid item>
						<TextField
							value={title}
							onChange={(e) => setTitle(e.target.value)}
							variant="standard"
							label="Title"
						/>
					</Grid>
					<Grid item>
						<TextField
							value={date}
							onChange={(e) => setDate(e.target.value)}
							variant="standard"
							label="Date"
							type="date"
						/>
					</Grid>
				</Grid>
				{error && (
					<Box mt={2}>
						<FormLabel color="error" error>
							{error}
						</FormLabel>
					</Box>
				)}
			</DialogContent>
			<DialogActions>
				<Button sx={{ marginLeft: 'auto' }} variant="text" onClick={handleClickCreate}>
					OK
				</Button>
			</DialogActions>
		</Dialog>
	);
};

export default CreateReminderModal;
