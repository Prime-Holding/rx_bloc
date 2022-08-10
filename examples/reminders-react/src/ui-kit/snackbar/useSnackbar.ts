import { useContext } from 'react';
import { SnackbarContext } from './SnackbarProvider';

const useSnackbar = () => {
	return useContext(SnackbarContext);
};

export default useSnackbar;
