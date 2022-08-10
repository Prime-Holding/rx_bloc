import { SnackbarVariant } from './snackbarTypes';
import './snackbar.scss';

interface SnackbarProps {
	variant: SnackbarVariant;
	message: string;
}

const Snackbar = ({ variant, message }: SnackbarProps) => {
	return (
		<div className="snackbar-wrapper">
			<div className={`snackbar ${variant}`}>{message}</div>
		</div>
	);
};

export default Snackbar;
