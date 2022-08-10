import Modal from '../../../../ui-kit/modal/Modal';
import Input from '../../../../ui-kit/input/Input';
import ModalButton from '../../../../ui-kit/modal/modal-button/ModalButton';
import { useCallback, useEffect, useState } from 'react';
import getDateForInput from '../../utils/getDateForInput';
import './createReminderModal.scss';
import InputGroup from '../../../../ui-kit/input-group/InputGroup';

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
		<Modal className="create-reminder-modal" isOpen={isOpen} onClose={onClose}>
			<h2 className="modal-title">Add Reminder</h2>
			<div className="inputs">
				<InputGroup>
					<label htmlFor="title">Title:</label>
					<Input
						id="title"
						maxLength={50}
						value={title}
						onChange={(e) => setTitle(e.target.value)}
						type="text"
					/>
				</InputGroup>
				<InputGroup>
					<label htmlFor="date">Date:</label>
					<Input
						id="date"
						value={date}
						onChange={(e) => setDate(e.target.value)}
						type="date"
					/>
				</InputGroup>
			</div>
			{error && <p className="error">{error}</p>}
			<div className="modal-buttons">
				<ModalButton alignRight onClick={handleClickCreate}>
					OK
				</ModalButton>
			</div>
		</Modal>
	);
};

export default CreateReminderModal;
