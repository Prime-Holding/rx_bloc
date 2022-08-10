import { BrowserRouter } from 'react-router-dom';
import AuthProvider from './features/authentication/state/AuthProvider';
import './style/app.scss';
import AppRoutes from './routes/AppRoutes';
import ModalPortal from './ui-kit/modal/ModalPortal';
import SnackbarProvider from './ui-kit/snackbar/SnackbarProvider';
import SnackbarConsumer from './ui-kit/snackbar/SnackbarConsumer';

const App = () => {
	return (
		<AuthProvider>
			<BrowserRouter>
				<SnackbarProvider>
					<SnackbarConsumer />
					<ModalPortal />
					<AppRoutes />
				</SnackbarProvider>
			</BrowserRouter>
		</AuthProvider>
	);
};

export default App;
