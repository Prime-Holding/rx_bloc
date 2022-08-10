import './modalButton.scss';
import { ReactNode } from 'react';

interface ModalButtonProps {
	children: ReactNode;
	alignRight?: boolean;
	onClick: () => void;
}

const ModalButton = ({ children, alignRight, onClick }: ModalButtonProps) => {
	return (
		<button
			className={`modal-button ${alignRight ? 'align-right' : ''}`}
			onClick={onClick}
		>
			{children}
		</button>
	);
};

export default ModalButton;
