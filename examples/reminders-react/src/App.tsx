import { BrowserRouter } from 'react-router-dom';
import AuthProvider from './features/authentication/state/AuthProvider';
import './style/app.scss';
import AppRoutes from './routes/AppRoutes';
import ModalPortal from './ui-kit/modal/ModalPortal';

const App = () => {
	return (
		<AuthProvider>
			<BrowserRouter>
				<ModalPortal />
				<AppRoutes />
			</BrowserRouter>
		</AuthProvider>
	);
};

export default App;
