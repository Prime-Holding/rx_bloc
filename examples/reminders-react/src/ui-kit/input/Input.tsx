import './input.scss';
import { InputHTMLAttributes } from 'react';

const Input = (props: InputHTMLAttributes<HTMLInputElement>) => {
	return <input {...props} className={`input ${props.className ?? ''}`} />;
};

export default Input;
