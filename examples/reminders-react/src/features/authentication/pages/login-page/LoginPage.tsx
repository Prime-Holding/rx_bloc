import useAuth from '../../hooks/useAuth';
import { Navigate } from 'react-router';
import './loginPage.scss';

const LoginPage = () => {
	const auth = useAuth();

	if (auth.state.isAuth) {
		return <Navigate to="/" />;
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
				<button className="login-facebook">Log in in with facebook</button>
			</div>
		</div>
	);
};

export default LoginPage;
