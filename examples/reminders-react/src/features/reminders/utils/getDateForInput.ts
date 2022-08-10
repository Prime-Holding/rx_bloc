// Get only day/month/year
const getDateForInput = (date: Date): string => {
	return date.toISOString().slice(0, -14);
};

export default getDateForInput;
