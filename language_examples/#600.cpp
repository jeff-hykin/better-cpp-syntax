class ClassA{};
struct StructA{};

ClassA FunctionOne(int& number_one, const int& number_two, int const& number_three);

const ClassA& FunctionTwo(StructA const& struct_one,
                            const StructA& struct_two,
                            int& number_one,
                            const int& number_two,
                            int const& number_three
                            );

ClassA const& FunctionThree(StructA const& struct_one,
                            const StructA& struct_two,
                            int& number_one,
                            const int& number_two,
                            int const& number_three
                            );
