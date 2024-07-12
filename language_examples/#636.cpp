#include "MyAwesomeDatabaseLibrary.h"
#include <string>
#include <iostream>

int main(int argc, char** argv)
{
    std::string plate = argv[1];

    AwesomeDBConnection conn;

    conn.Open("myconnectionstring");

    auto query = conn.Execute(R"sql(

        SELECT uid, part_name, install_date FROM CarParts
         WHERE plate = ')sql" + plate + "' ORDER BY install_date");

    for (const auto& entry : query)
    {
        std::cout << entry["uid"] << ": ";
        std::cout << entry["part_name"] << ", ";
        std::cout << entry["install_date"] << std::endl;
    }

    conn.Close();

    return 0;
}