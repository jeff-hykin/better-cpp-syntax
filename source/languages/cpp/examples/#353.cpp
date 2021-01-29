/**
 * @brief performs a "foo" action
 * @param a the action to preform
 * @retval ERROR_SUCCESS action performed successfully
 * @retval EPERM permission error
 * @note if \c a is zero, something \b bad happens
 */
int foo(int a);

/**
 * SECTION:meepapp
 * @short_description: the application class
 * @title: Meep application
 * @section_id:
 * @see_also: #MeepSettings
 * @stability: Stable
 * @include: meep/app.h
 * @image: application.png
 *
 * The application class handles ...
 */