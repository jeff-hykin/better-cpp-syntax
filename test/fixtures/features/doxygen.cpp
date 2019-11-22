
/*!
 * ... text ...
 */

/*!
 ... text ...
*/

///
/// ... text ...
///

//!
//!... text ...
//!

/////////////////////////////////////////////////
/// ... text ...
/////////////////////////////////////////////////

/**
 * @param p0 is the first p.
 * @param[in] p0 is an input parameter
 * @param[in,out] io is an in-out paramater
 * @param [in] p1 is a param with a space
 */


//! Brief description, which is
//! really a detailed description since it spans multiple lines.
/*! Another detailed description!
 */

int var; /*!< Detailed description after the member */

/********************************************/ /**
                                                *  ... text
                                                ***********************************************/

/**
 * A brief history of JavaDoc-style (C-style) comments.
 *
 * This is the typical JavaDoc-style C-style comment. It starts with two
 * asterisks.
 *
 * @param theory Even if there is only one possible unified theory. it is just a
 *               set of rules and equations.
 */
void cstyle(int theory);

/*******************************************************************************
 * A brief history of JavaDoc-style (C-style) banner comments.
 *
 * This is the typical JavaDoc-style C-style "banner" comment. It starts with
 * a forward slash followed by some number, n, of asterisks, where n > 2. It's
 * written this way to be more "visible" to developers who are reading the
 * source code.
 *
 * Often, developers are unaware that this is not (by default) a valid Doxygen
 * comment block!
 *
 * However, as long as JAVADOC_BLOCK = YES is added to the Doxyfile, it will
 * work as expected.
 *
 * This style of commenting behaves well with clang-format.
 *
 * @param theory Even if there is only one possible unified theory. it is just a
 *               set of rules and equations.
 ******************************************************************************/
void javadocBanner(int theory);

/***************************************************************************/ /**
                                                                               * A brief
                                                                               *history of
                                                                               *Doxygen-style
                                                                               *banner
                                                                               *comments.
                                                                               *
                                                                               * This is a
                                                                               *Doxygen-style
                                                                               *C-style
                                                                               *"banner"
                                                                               *comment.
                                                                               *It starts
                                                                               *with a
                                                                               *"normal"
                                                                               * comment
                                                                               *and is
                                                                               *then
                                                                               *converted
                                                                               *to a
                                                                               *"special"
                                                                               *comment
                                                                               *block near
                                                                               *the end of
                                                                               * the first
                                                                               *line. It
                                                                               *is written
                                                                               *this way
                                                                               *to be more
                                                                               *"visible"
                                                                               *to
                                                                               *developers
                                                                               * who are
                                                                               *reading
                                                                               *the source
                                                                               *code. This
                                                                               *style of
                                                                               *commenting
                                                                               *behaves
                                                                               *poorly
                                                                               *with
                                                                               *clang-format.
                                                                               *
                                                                               * @param
                                                                               *theory
                                                                               *Even if
                                                                               *there is
                                                                               *only one
                                                                               *possible
                                                                               *unified
                                                                               *theory. it
                                                                               *is just a
                                                                               *               set
                                                                               *of rules
                                                                               *and
                                                                               *equations.
                                                                               ******************************************************************************/
void doxygenBanner(int theory);


//!  A test class.
/*!
  A more elaborate class description.
*/

class QTstyle_Test {
  public:
	//! An enum.
	/*! More detailed enum description. */
	enum TEnum {
		TVal1, /*!< Enum value TVal1. */
		TVal2, /*!< Enum value TVal2. */
		TVal3  /*!< Enum value TVal3. */
	}
	    //! Enum pointer.
	    /*! Details. */
	    * enumPtr,
	    //! Enum variable.
	    /*! Details. */
	    enumVar;

	//! A constructor.
	/*!
	  A more elaborate description of the constructor.
	*/
	QTstyle_Test();

	//! A destructor.
	/*!
	  A more elaborate description of the destructor.
	*/
	~QTstyle_Test();

	//! A normal member taking two arguments and returning an integer value.
	/*!
	  \param a an integer argument.
	  \param s a constant character pointer.
	  \return The test results
	  \sa QTstyle_Test(), ~QTstyle_Test(), testMeToo() and publicVar()
	*/
	int testMe(int a, const char *s);

	//! A pure virtual member.
	/*!
	  \sa testMe()
	  \param c1 the first argument.
	  \param c2 the second argument.
	*/
	virtual void testMeToo(char c1, char c2) = 0;

	//! A public variable.
	/*!
	  Details.
	*/
	int publicVar;

	//! A function variable.
	/*!
	  Details.
	*/
	int (*handler)(int a, int b);
};
