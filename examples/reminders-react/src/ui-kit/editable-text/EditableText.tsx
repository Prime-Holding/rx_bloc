import { HTMLInputTypeAttribute, ReactNode, useEffect, useRef, useState } from 'react';
import './editableText.scss';
import Input from '../input/Input';
import { EditIcon } from '../icons/icons';

interface EditableTextProps {
	value: string;
	onChange: (value: string) => Promise<any> | void;
	children: ReactNode;
	type: HTMLInputTypeAttribute;
	className?: string;
}

const EditableText = ({
	value,
	onChange,
	children,
	type = 'text',
	className
}: EditableTextProps) => {
	const [isEditing, setIsEditing] = useState(false);
	const [rawValue, setRawValue] = useState(value);
	const containerRef = useRef<HTMLDivElement | null>(null);

	const handleClick = () => {
		if (!isEditing) {
			setIsEditing(true);
			setRawValue(value);
		}
	};

	useEffect(() => {
		if (isEditing) {
			const listener = (e: MouseEvent) => {
				if (!e.target) return;
				if (!containerRef.current?.contains(e.target as Node)) {
					Promise.all([onChange(rawValue)]).then(() => {
						setIsEditing(false);
					});
				}
			};
			document.addEventListener('mousedown', listener);
			return () => {
				document.removeEventListener('mousedown', listener);
			};
		}
	}, [isEditing, onChange, rawValue]);

	return (
		<div
			ref={containerRef}
			className={`editable-text ${className ?? ''} ${isEditing ? 'editing' : ''}`}
			onClick={handleClick}
		>
			{!isEditing && children}
			{isEditing && (
				<Input
					value={rawValue}
					onChange={(e) => setRawValue(e.target.value)}
					type={type}
					maxLength={50}
					autoFocus
				/>
			)}
			<EditIcon className="edit-icon" />
		</div>
	);
};

export default EditableText;
