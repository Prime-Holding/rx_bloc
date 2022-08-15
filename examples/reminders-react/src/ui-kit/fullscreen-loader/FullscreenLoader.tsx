import './fullscreenLoader.scss';
import { CircularProgress } from '@mui/material';

const FullscreenLoader = () => {
	return (
		<div className="fullscreen-loader">
			<CircularProgress />
		</div>
	);
};

export default FullscreenLoader;
