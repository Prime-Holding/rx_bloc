import './checkbox.scss';
import { CheckmarkIcon } from '../icons/icons';

interface CheckboxProps {
	checked: boolean;
	onClick?: () => void;
}

const Checkbox = ({ checked, onClick }: CheckboxProps) => {
	return (
		<div onClick={onClick} className={`checkbox ${checked ? 'checked' : ''}`}>
			<CheckmarkIcon className="checkmark" />
		</div>
	);
};

export default Checkbox;
