import { ReactNode } from 'react';
import './inputGroup.scss';

interface InputGroupProps {
	children: ReactNode;
}

const InputGroup = ({ children }: InputGroupProps) => {
	return <div className="input-group">{children}</div>;
};

export default InputGroup;
