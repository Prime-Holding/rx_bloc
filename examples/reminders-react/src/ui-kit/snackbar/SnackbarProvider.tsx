import { createContext, ReactNode, useEffect, useMemo, useState } from 'react';
import { SnackbarType, SnackbarVariant } from './snackbarTypes';

const snackbarTimeout = 3000;

interface SnackbarContextType {
	push: (type: SnackbarVariant, message: string) => void;
	snackbar: SnackbarType | null;
}

export const SnackbarContext = createContext<SnackbarContextType>(
	null as unknown as SnackbarContextType
);

interface SnackbarProviderProps {
	children: ReactNode;
}

const SnackbarProvider = ({ children }: SnackbarProviderProps) => {
	const [snackbar, setSnackbar] = useState<SnackbarType | null>(null);

	useEffect(() => {
		if (snackbar) {
			const id = setTimeout(() => {
				setSnackbar(null);
			}, snackbarTimeout);
			return () => {
				clearTimeout(id);
			};
		}
	}, [snackbar]);

	const context = useMemo(
		(): SnackbarContextType => ({
			push: (variant: SnackbarVariant, message: string) => {
				setSnackbar({ variant, message });
			},
			snackbar
		}),
		[snackbar]
	);

	return <SnackbarContext.Provider value={context}>{children}</SnackbarContext.Provider>;
};

export default SnackbarProvider;
