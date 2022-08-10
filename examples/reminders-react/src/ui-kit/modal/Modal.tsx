import { createPortal } from 'react-dom';
import { ReactNode } from 'react';
import './modal.scss';

interface ModalProps {
	isOpen: boolean;
	className?: string;
	children: ReactNode;
	onClose: () => void;
}

const Modal = ({ isOpen, children, onClose, className }: ModalProps) => {
	const portal = document.querySelector('.modal-portal');

	if (!isOpen) return null;

	if (!portal) {
		throw 'Modal portal is missing';
	}

	return createPortal(
		<div className="modal-wrapper" onMouseDown={onClose}>
			<div
				className={`modal ${className ?? ''}`}
				onMouseDown={(e) => e.stopPropagation()}
			>
				{children}
			</div>
		</div>,
		portal
	);
};

export default Modal;
