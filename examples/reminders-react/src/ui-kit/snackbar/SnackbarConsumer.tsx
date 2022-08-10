import { useContext } from 'react';
import { SnackbarContext } from './SnackbarProvider';
import Snackbar from './Snackbar';

const SnackbarConsumer = () => {
	const { snackbar } = useContext(SnackbarContext);

	if (!snackbar) {
		return null;
	} else {
		return <Snackbar variant={snackbar.variant} message={snackbar.message} />;
	}
};

export default SnackbarConsumer;
