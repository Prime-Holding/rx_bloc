import useAuth from '../../hooks/useAuth';
import { Navigate } from 'react-router';
import './loginPage.scss';
import Loader from '../../../../ui-kit/loader/Loader';
import FullscreenLoader from '../../../../ui-kit/fullscreen-loader/FullscreenLoader';

const LoginPage = () => {
	const auth = useAuth();

	if (auth.state.isAuth) {
		return <Navigate to="/" />;
	}

	if (auth.isInitialLoading) {
		return <FullscreenLoader />;
	}

	return (
		<div className="login-page">
			<div className="headers">
				<h1>Reminders</h1>
				<h2>Log in</h2>
			</div>
			<div className="buttons">
				<button className="login-anon" onClick={auth.signInAnonymously}>
					Log in as anonymous
				</button>
				<button className="login-facebook" onClick={auth.signInWithFacebook}>
					Log in in with facebook
				</button>
			</div>
			<div className={'login-loader' + (auth.isLoading ? ' visible' : '')}>
				<Loader />
			</div>
		</div>
	);
};

export default LoginPage;
