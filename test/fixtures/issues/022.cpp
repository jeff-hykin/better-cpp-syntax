sscanf(user_input, "%c %[^\n]", &arg0, arg_str); // reads char into arg0, the remainder until \n to arg_str
void test()
{
    t = time(NULL);
    tmp = localtime(&t);
    strftime(timestr, sizeof(timestr), "%Y-%m-%d %H:%M:%s", tmp);
}