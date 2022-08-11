import Loader from '../loader/Loader';
import './fullscreenLoader.scss';

const FullscreenLoader = () => {
	return (
		<div className="fullscreen-loader">
			<Loader />
		</div>
	);
};

export default FullscreenLoader;
