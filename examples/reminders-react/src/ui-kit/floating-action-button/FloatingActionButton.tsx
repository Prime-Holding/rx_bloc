import './floatingActionButton.scss';
import { JSXElementConstructor } from 'react';

interface FloatingActionButtonProps {
	icon: JSXElementConstructor<any>;
	onClick: () => void;
}

const FloatingActionButton = ({ icon, onClick }: FloatingActionButtonProps) => {
	const Icon = icon;

	return (
		<div className="floating-action-button" onClick={onClick}>
			<Icon />
		</div>
	);
};

export default FloatingActionButton;
