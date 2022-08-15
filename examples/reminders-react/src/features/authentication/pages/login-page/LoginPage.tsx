import useAuth from '../../hooks/useAuth';
import { Navigate } from 'react-router';
import './loginPage.scss';
import FullscreenLoader from '../../../../ui-kit/fullscreen-loader/FullscreenLoader';
import { ButtonBase, CircularProgress, Typography } from '@mui/material';

const LoginPage = () => {
	const auth = useAuth();

	if (auth.state?.isAuthenticated) {
		return <Navigate to="/" />;
	}

	if (auth.isInitialLoading) {
		return <FullscreenLoader />;
	}

	return (
		<div className="login-page">
			<div className="headers">
				<Typography
					component="h1"
					variant="h4"
					color="primary"
					fontWeight="bold"
					align="center"
				>
					Reminders
				</Typography>
				<Typography
					component="h2"
					variant="h6"
					color="primary"
					fontWeight="bold"
					align="center"
				>
					Log in
				</Typography>
			</div>
			<div className="buttons">
				<ButtonBase className="login-anon" onClick={auth.signInAnonymously}>
					Log in as anonymous
				</ButtonBase>
				<ButtonBase className="login-facebook" onClick={auth.signInWithFacebook}>
					Log in in with facebook
				</ButtonBase>
			</div>
			<div className={'login-loader' + (auth.isLoading ? ' visible' : '')}>
				<CircularProgress />
			</div>
		</div>
	);
};

export default LoginPage;
