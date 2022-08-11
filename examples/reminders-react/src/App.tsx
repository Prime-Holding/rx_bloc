import { BrowserRouter } from 'react-router-dom';
import AuthProvider from './features/authentication/state/AuthProvider';
import './style/app.scss';
import AppRoutes from './routes/AppRoutes';

const App = () => {
	return (
		<AuthProvider>
			<BrowserRouter>
				<AppRoutes />
			</BrowserRouter>
		</AuthProvider>
	);
};

export default App;
