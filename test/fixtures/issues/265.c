int main(void)
{
    im_a_struct.im_a_member = 0; /* works fine */
    im_a_struct.integer_member = 0; /* starts with a variable type "int", no color */
    im_a_struct.size_t_holder = 0; /* does not work too */
    im_a_struct.intra_thread = thread(); /* same issue, starts with "int" */
    im_a_struct.long_array = malloc(10000); /* "long" keyword */
}