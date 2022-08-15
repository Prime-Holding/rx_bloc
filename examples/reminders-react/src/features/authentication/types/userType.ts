type User =
	| {
			id: null;
			isAnonymous: true;
	  }
	| {
			id: string;
			isAnonymous: false;
	  };

export default User;
