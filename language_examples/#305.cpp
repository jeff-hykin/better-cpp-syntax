class ThisTest {
	ThisTest()
	    : someMember(true),  // here is a comment that is formatted incorrectly
	      anotherOne(false),
	      quiteALotOfMembers(false),  // here's another one
	      soManyThatTheConstructorIsLong(true),
	      iMeanReallyLong(false) {
	}

	bool someMember;
	bool anotherOne;
	bool quiteALotOfMembers;
	bool soManyThatTheConstructorIsLong;
	bool iMeanReallyLong;
};