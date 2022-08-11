import { BrowserRouter } from 'react-router-dom';
import AuthProvider from './features/authentication/state/AuthProvider';
import './style/app.scss';
import AppRoutes from './routes/AppRoutes';
import { ThemeProvider } from '@mui/material';
import theme from './theme/theme';
import { SnackbarProvider } from 'notistack';

const App = () => {
	return (
		<AuthProvider>
			<ThemeProvider theme={theme}>
				<SnackbarProvider anchorOrigin={{ horizontal: 'center', vertical: 'bottom' }}>
					<BrowserRouter>
						<AppRoutes />
					</BrowserRouter>
				</SnackbarProvider>
			</ThemeProvider>
		</AuthProvider>
	);
};

export default App;
