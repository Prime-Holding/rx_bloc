import { BrowserRouter } from 'react-router-dom';
import AuthProvider from './features/authentication/state/AuthProvider';
import './style/app.scss';
import AppRoutes from './routes/AppRoutes';
import { SnackbarProvider } from 'notistack';

const App = () => {
	return (
		<AuthProvider>
			<SnackbarProvider anchorOrigin={{ horizontal: 'center', vertical: 'bottom' }}>
				<BrowserRouter>
					<AppRoutes />
				</BrowserRouter>
			</SnackbarProvider>
		</AuthProvider>
	);
};

export default App;
