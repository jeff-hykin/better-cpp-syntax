// 
// CEKO LIBRARY
// This is a library written and maintained by Jeff Hykin
// the handlful of outside sources that were used are cited in the definition of functions that used them
// 

#ifndef CEKO_LIBRARY 
#define CEKO_LIBRARY
// includes 
    #include <ios>                   // part of creating clear_cin
    #include <istream>               // part of creating clear_cin
    #include <iostream>              // cout , getline 
    #include <string>                // strings 
    #include <sstream>               // stringstreams 
    #include <vector>                // vectors
    #include <cmath>                 // abs , pow 
    #include <regex>                 // regular expressions 
    #include <stdlib.h>              // exit(0) 
    #include <stdio.h>               //
    #include <iomanip>               // setw , setprecision , showpoint , fixed 
    #include <limits>                // inf, max:: 
    #include <fstream>               // fstream , .open() , .close()
    #include <algorithm>             // min ()
    #include <random>                // rand()
    #include <cctype>                // isalpha()
    #include <sys/time.h>            // gettimeofday()
    #include <time.h>                // time()
    #include <ctime>                 // time stuff
    #include <chrono>                // sleep_for() , sleep_until
    #include <thread>                // system_clock, seconds
    #include <map>                   // maps / dictionarys 
    #include <bitset>                // binary output/input
    #include <sys/mman.h>            // used in ReadFile
    #include <sys/stat.h>            // used in ReadFile
    #include <fcntl.h>               // used in ReadFile, used in Threads
    #include <pthread.h>             // threads 
    #include <type_traits>           // used in converting lambda to function pointer 
    #include <utility>               // used in converting lambda to function pointer 

// defines 
    // name space 
        using namespace std;
        using namespace this_thread; // sleep_for, sleep_until
        using namespace chrono;      // nanoseconds, system_clock, seconds  

    // Constants
        #define Infinite    numeric_limits<long double>::infinity()
        #define DoubleMax   1.79769e+308
        #define Pi          3.1415926535897932384626

// ToDo 
    // range
    // timing functions
    // vector 
        // add -- overload to vector 
    // bool 
        // make it a thing!!
        // Custom Yes/No
        // [] overload 
        // implicit overload
        // = overload  
    // Number  
        // handle big numbers
        // correct comparison 
    // String  
        // make it a thing!!
        // [] overload w/ -1 working 
        // Regex, make XD regex 
            // find , replace , for 
    // Grid    
        // make it a thing!!
        // overload multiple []
        // lots of member functions 
        // * , / , +  <> << >>
    // List    
        // add AskList()
        // overload list {} so it can be declared like a vector 
        // add more member functions to list, 
            // RemoveDuplicates()
            // Reverse()
            // add math functions to lists (Sum, Average, Mean, Max, Min, Random, etc)
        // implicit conversion for lists 
        // allow range-based loop
        // operator overloads for list
            // +
            // != 
            // ++
            // <<   // for non-streams
            // >>   // for non-streams
            // <
            // >
            // == 
            // <=
            // <<=
            // =>>
            // &&   // and 'and' operator 
            // , 
            // . 
        // allow for removal of items via a negative index .Remove(-1)
        // think about adding dual vector_ data holders, so that AddToTop can be as efficient as AddToBottom
    // Item    
        // add AskItem()!
        // add VisualFormat 
        // overload item[] so they can reference lists!!
        // add more memeber functions to item 
            // Math 
                // Abs  
        // overload moar things!
            // ++
            // --
            // != 
            // <<   // for non-streams
            // >>   // for non-streams
            // <
            // >
            // == 
            // <=
            // <<=
            // =>>
            // , 
            // . 
        // make item deal in_ long double type
        // make item fix a lot of the precision issues 
        // Explore possibilty of using pointers to create Item references 
    
        






// function declares and variables
    void            ClearScreen                ();
    streamsize      FlushCin                   ();
    void            Pause                      ();
    void            System                     (string input_string);
    string          Getline                    ();
    string          Getline                    ( string&  input_string  );
    string          Getline                    ( istream& input_stream  );
    string          Getline                    ( istream& input_stream, string& input_string );
    string          StreamAsString             ( istream& in_ );
    string          StreamStatus               ( istream& in_ );
    string          Literal                    ( string input );
    string          Literal                    ( char   input );
    bool            IsAllUpperCase             ( string input );
    bool            IsAllUpperCase             ( char   input );
    bool            Is__CharIn__String         ( char   test_val , string input_string );
    string          EverythingUpTo             ( char end_symbol, istream& input_stream);
    string          EverythingUpTo             ( char end_symbol);
    void            EndProgram                 ();
    void            Poke                       ( string id_ );
    istream&        StreamFailed               ( istream& input_stream );
    bool            DidStreamFail              ( istream& input_stream );
    bool            EndOfStream                ( istream& input_stream );
    bool            StreamMatchesString        ( istream& input_stream, string  input_string );
    template <class ANYTYPE> string          Type(ANYTYPE input);
    template <class ANYTYPE> string AsString(const ANYTYPE& input);
    pthread_mutex_t mutex_for_output = PTHREAD_MUTEX_INITIALIZER;
    

////////////////////////
//
//  Functions
//
////////////////////////
    // Debugging and errors 
        // there is one more Debugging tool inside the , operator overload 
        // (should be in the 'print' section near the bottom)
        bool Debugging = true; // a switch for turning Debugging on and off 
        struct Errors
            {
                string info;
                Errors(string input_error) { info = input_error; }
            };
                ostream& operator<<(ostream& output_stream, const Errors& input_error)
                    {   return output_stream << input_error.info; }
                void Error( string input_error )
                    {
                        throw Errors( input_error );
                    }
                void error( string input_error )
                    {
                        throw Errors(input_error);
                    }
        #define POKE cout << "here"; EndProgram(); 
        int COUNTER =0;
    // advanced things
        // Convertion of lambda into function pointer
            // https://stackoverflow.com/a/45365798/4367134
            // depends on:
            //    #include<type_traits>
            //    #include<utility>
            // example usage:
                // int i = 42;
                // // string is the return type of the lambda function
                // auto function_ptr_1 = convertToFuncPtr<string()>([&]{cout << i; return "hello;";});
            template<typename Callable>
            union storage
                {
                    storage() {}
                    decay_t<Callable> callable;
                };
            
            template<int, typename Callable, typename Ret, typename... Args>
            auto internalConversionToFuncPtr(Callable&& a_callable, Ret (*)(Args...))
                {
                    static bool used = false;
                    static storage<Callable> a_storage_of_callable;
                    using type = decltype(a_storage_of_callable.callable);

                    if(used) {
                        a_storage_of_callable.callable.~type();
                    }
                    new (&a_storage_of_callable.callable) type(forward<Callable>(a_callable));
                    used = true;

                    return [](Args... args) -> Ret {
                        return Ret(a_storage_of_callable.callable(forward<Args>(args)...));
                    };
                }

            template<typename RETURN_TYPE, int N = 0, typename Callable>
            RETURN_TYPE* convertToFunctionPointer(Callable&& c)
                {
                    return internalConversionToFuncPtr<N>(forward<Callable>(c), (RETURN_TYPE*)nullptr);
                }

    // Operator Overloads
        // vector 
            // << >>
                // template <class ANYTYPE> ostream& operator<<(ostream& output_stream, const vector<ANYTYPE>& input_vector)
                //     {
                //         for ( int LoopNumber = 1 ; LoopNumber <= input_vector.size(); LoopNumber++ ) 
                //             { 
                //                 output_stream << input_vector[LoopNumber-1] << '\n';
                //             }
                //         return output_stream;
                //     }
                // alternative output for vector
                template <class ANYTYPE> ostream& operator<<(ostream& output_stream, const vector<ANYTYPE>& input_vector)
                    {
                        output_stream << "[ ";
                        for ( int LoopNumber = 1 ; LoopNumber <= input_vector.size(); LoopNumber++ ) 
                            { 
                                output_stream << input_vector[LoopNumber-1] << ", ";
                            }
                        return output_stream << "]";
                    }
                template <class ANYTYPE> istream& operator>>(istream& input_stream,     vector<ANYTYPE>& input_ )
                    {
                        input_ = {};
                        ANYTYPE element_holder;
                        char should_always_be_a_newline;
                        while(input_stream >> element_holder) 
                        { 
                            input_.push_back(element_holder);
                            input_stream.get(should_always_be_a_newline);
                            if (should_always_be_a_newline != '\n')
                                return StreamFailed(input_stream);
                        }
                        return input_stream;
                    }
            // +    
                template <class ANYTYPE> vector<ANYTYPE> operator+(const vector<ANYTYPE>& vec1, const vector<ANYTYPE>& vec2)
                    {
                        vector<ANYTYPE> vec3 = vec1;
                        vec3.reserve(vec1.size()+vec2.size());
                        for ( ANYTYPE each : vec2 ) 
                            vec3.push_back(each);
                        return vec3;
                    }
                template <class ANYTYPE> vector<ANYTYPE> operator+(const vector<ANYTYPE>& vec1, const ANYTYPE input_)
                    {   
                        vector<ANYTYPE> vec2 = vec1;
                        vec2.push_back(input_);
                        return vec2;
                    }
                template <class ANYTYPE> vector<ANYTYPE> operator+( const ANYTYPE input_, const vector<ANYTYPE>& vec1)
                    {   
                        vector<ANYTYPE> vec2 = vec1;
                        vec2.insert(vec2.begin(),input_);
                        return vec2;
                    }
        // map    
            template <class ANYTYPE, class ANYSECONDTYPE> ostream& operator<<(ostream& output_stream, const pair<ANYSECONDTYPE, ANYTYPE>& input_pair)
                {
                    return output_stream << input_pair.first << ':' << input_pair.second;
                }        
            template <class ANYTYPE, class ANYSECONDTYPE> ostream& operator<<(ostream& output_stream, const map<ANYSECONDTYPE , ANYTYPE>& input_map )
                {
                    for ( pair<ANYSECONDTYPE, ANYTYPE> each : input_map ) 
                    { 
                        output_stream << each << '\n';
                    }
                    return output_stream;
                }
            template <class ANYTYPE, class ANYSECONDTYPE> istream& operator>>(istream& input_stream,    pair<ANYSECONDTYPE, ANYTYPE>& input_pair)
                {
                    char should_always_be_a_colon;
                    ANYTYPE first_value;
                    ANYSECONDTYPE second_value;
                    input_stream >> first_value >> should_always_be_a_colon >> second_value;
                    input_pair.second = second_value;
                    input_pair.first = first_value;
                    return input_stream;
                }
            template <class ANYTYPE, class ANYSECONDTYPE> istream& operator>>(istream& input_stream,     map<ANYSECONDTYPE , ANYTYPE>& input_map )
                {
                    input_map.clear();
                    pair<ANYTYPE,ANYSECONDTYPE> pair_holder;
                    char should_always_be_a_newline;
                    while(input_stream >> pair_holder) 
                    { 
                        input_map[pair_holder.first] = pair_holder.second;
                        input_stream.get(should_always_be_a_newline);
                        if (should_always_be_a_newline != '\n')
                            return StreamFailed(input_stream);
                    }
                    return input_stream;
                }

    // Core helper functions 
        // indent           
            // data for indent 
            int    const INDENT_SIZE = 4;
            string const INDENT      = string(INDENT_SIZE, ' ');
            // functions 
            template <class ANYTYPE> string        Indent                     (ANYTYPE input_)
                {
                    stringstream a_stream;
                    a_stream << input_;
                    char a_char;
                    string output_string = INDENT;
                    while (a_stream.get(a_char))
                        {
                            if (a_char == '\n')
                                {
                                    output_string = output_string + "\n" + INDENT;
                                }
                            else 
                                output_string = output_string + a_char;
                        }
                    return output_string;
                }
            string          Indent                     (istream& input_)
                {
                    string output = StreamAsString(input_);
                    return Indent(output);
                }
            string          Indent                     (stringstream& input_)
            {
                string output = StreamAsString(input_);
                return Indent(output);
            }
            
            // create an unindent for streams only
            // should always return a \n at the end 
            // if it returns "" it failed
            string        Input_Unindent             (istream& in_)
                {
                    bool local_debug = false;
                    if (local_debug) cout << "starting Input_Unindent()\n";
                    char char_holder;
                    string unindented_stuff ="";
                    // for each line 
                    while(true)
                        {
                            // get the first char
                            in_.get(char_holder);
                            
                            // break if end of file 
                            if (in_.eof()) 
                                {
                                    if (local_debug) cout << "exiting via end of input\n";
                                    break;
                                }
                            // put the char back into the stream 
                            in_.unget();

                            if (local_debug) cout << "char is:" << Literal(char_holder) << '\n';

                            // if it doesn start with an indent, break
                            if (char_holder != ' ') 
                                {
                                    if (local_debug) cout << "exiting via no indent start\n";
                                    break;
                                }
                            // if for some reason the stream has a space 
                            // but is not fully indented
                            // then fail (this will mess up the stream because)
                            // the spaces cannot be (reliably) un-got
                            if (!StreamMatchesString(in_, INDENT)) 
                                    {
                                        if (local_debug) cout << "exiting via started with space but not indent\n";
                                        if (local_debug) cout << "counter is:" << COUNTER << '\n';
                                        return "";
                                    }

                            // put the whole line into a string
                            string next_line = EverythingUpTo('\n',in_);

                            // if there wasnt a newline at the end then fail 
                            if (next_line[next_line.size()-1] != '\n') 
                                {
                                    if (local_debug) cout << "exiting via no newline at end of string\n";
                                    if (local_debug) cout << "line was:\n" << Literal(next_line);
                                    return "";
                                }


                            unindented_stuff += next_line;
                        }
                    return unindented_stuff;
                }
        // Random numbers   
            float Rand  ( ) { return ( rand() % 10000 ) / 10000.0;                         }
            float Randn ( ) { return sqrt( -2 * log( Rand() )  ) * cos( 2 * Pi * Rand() ); } 
        // Time
            long long    CurrentTimeInMicroSeconds()
                {
                    struct timeval a_time;
                    gettimeofday(&a_time, 0);
                    return a_time.tv_sec * 1000000 + a_time.tv_usec;
                }
            long         NumberOfMicrosecondsBetween(struct timeval& start_time, struct timeval& end_time)
                {
                    long seconds       = end_time.tv_sec  - start_time.tv_sec;
                    long micro_seconds = end_time.tv_usec - start_time.tv_usec;
                    if (micro_seconds < 0)
                        {
                            micro_seconds += (int)1e6;
                            seconds--;
                        }
                    return (seconds * 1000000 + micro_seconds);
                }
            void         BriefDelay (               ) { sleep_for( milliseconds(           200                   ) ); }
            void         BriefDelay (double seconds_) { sleep_for( milliseconds(static_cast<int>(seconds_ * 100) ) ); }
            void         LittleRandomDelay ()         { BriefDelay( Randn() + 1 ); }
            const string currentDateTime   () 
                {
                    //  modified this a bit from http://stackoverflow.com/questions/997946/how-to-get-current-time-and-date-in_-c
                    // depends on:
                    //     #include <iostream>
                    //     #include <string>
                    //     #include <stdio.h>
                    //     #include <time.h>
                    time_t     now = time(0);
                    struct tm  tstruct;
                    char       buf[80];
                    tstruct = *localtime(&now);
                    // Visit http://en.cppreference.com/w/cpp/chrono/c/strftime
                    // for more information about date/time format
                    strftime(buf, sizeof(buf), "%Y-%m-%d  %X", &tstruct);

                    return buf;
                }
        // Stream functions 
            // mostly for cout, cin 
                template <typename ANYTYPE> streamsize FlushStream (basic_istream   <ANYTYPE>& input_stream,   bool always_discard = false )
                    {
                        //  this code is a visually modified version of the code from: 
                        //  https://www.daniweb.com/programming/software-development/threads/90228/flushing-the-input-stream
                        //  (which is a great explaination of the process ) 
                        //  it allows correct clearing of the cin buffer 
                        //  
                        //  depends on:
                        //         #include <ios>
                        //         #include <istream>
                        //         #include <limits>
                        streamsize num_of_chars_discarded = 0;
                        if     ( always_discard 
                            || (    input_stream.rdbuf()->sungetc() != char_traits<ANYTYPE>::eof()
                                 && input_stream.get()              != input_stream.widen ( '\n' )       ) )
                        {
                                // The stream is good, and we haven't
                                // read a full line yet, so clear it out
                                input_stream.ignore ( numeric_limits<streamsize>::max(), input_stream.widen ( '\n' ) );
                                num_of_chars_discarded = input_stream.gcount();
                        }
                        return num_of_chars_discarded;
                    }
                void            ClearScreen                ()
                    {
                        cout << "\033[2J\033[1;1H"; // http://stackoverflow.com/questions/17335816/clear-screen-using-c
                    } 
                streamsize      FlushCin                   ()
                    { 
                        return FlushStream ( cin ); 
                    }
                string          Getline                    ()
                    {
                        string input_data;
                        FlushCin();
                        getline(cin, input_data);
                        return input_data;
                    }
                string          Getline                    ( string&  input_string  )
                    {
                        FlushCin();
                        getline(cin, input_string);
                        return input_string;
                    }
                string          Getline                    ( istream& input_stream  )
                    {
                        string input_string;
                        FlushCin();
                        getline(input_stream, input_string);
                        return input_string;
                    }
                string          Getline                    ( istream& input_stream, string& input_string )
                    {
                        FlushCin();
                        getline(input_stream, input_string);
                        return input_string;
                    }
                void            Pause                      ()
                    {
                        FlushCin();
                        if (!cin)
                            cin.clear();
                        cin.ignore();
                    } 
                void BackSpace (int    number_of_places )
                    { 
                        { int Max_Value =  number_of_places     ; for (int LoopNumber=1; LoopNumber <= Max_Value ; LoopNumber++) { 
                            cout << '\b';
                            cout << ' ';
                            cout << '\b';
                            cout.flush();
                            LittleRandomDelay();
                         } } 
                    } 
                void TypeOut   (string input_string     )
                    {
                        { int Max_Value =  input_string .size()     ; for (int LoopNumber=1; LoopNumber <= Max_Value ; LoopNumber++) { int EachChar = LoopNumber - 1;  
                            cout.flush();
                            cout << input_string[ EachChar ];
                            cout.flush();
                            LittleRandomDelay();
                        } }
                        BriefDelay(7);
                    }
            // stream helpers 
                string          StreamAsString             ( istream& in_ )
                    {
                        stringstream output;
                        char each_char;
                        while ( in_.get(each_char) ) 
                            output << each_char;
                        string output_str = output.str();
                        return output_str;
                    }
                string          StreamStatus               ( istream& in_ )
                    {
                        string output;
                        // good
                        if (in_.good())
                            output += "Good: Yes\n";
                        else 
                            output += "Good: No\n";
                        // eof
                        if (in_.eof ())
                            output += "EOF : Yes\n";
                        else
                            output += "EOF : No\n";
                        // fail 
                        if (in_.fail())
                            output += "Fail: Yes\n";
                        else
                            output += "Fail: No\n";
                        // bad
                        if (in_.bad ())
                            output += "Bad : Yes\n";
                        else
                            output += "Bad : No\n";
                        return output;
                    }
                istream&        StreamFailed               ( istream& input_stream )
                    {
                        input_stream.clear();
                        input_stream.clear(ios_base::failbit);
                        return input_stream;
                    }
                bool            DidStreamFail              ( istream& input_stream )
                    {
                        if (input_stream.eof())
                            {
                                return false;
                            }
                        else if (input_stream.fail())
                            {
                                return true ;
                            }
                    }
                bool            EndOfStream                ( istream& input_stream )
                    {
                        if (input_stream.eof())
                            return true;
                        return false;
                    }
                bool            StreamMatchesString        ( istream& input_stream, string  input_string )
                    {
                        char char_;
                        { int Max_Value =  input_string.size()     ; for (int LoopNumber=1; LoopNumber <= Max_Value ; LoopNumber++) {
                                // if the stream runs out of characters, false 
                                if (   !(  input_stream.get(char_)  )     )
                                    return false;
                                // if string doesn't match, false 
                                if ( char_ != input_string[LoopNumber-1] )
                                    return false;
                         } }
                        return true;
                    }
                string          EverythingUpTo             ( char end_symbol, istream& input_stream)
                    {
                       char char_;
                       string output;
                       while (input_stream.get(char_))
                            {
                                output = output + char_ ;
                                if (char_ == end_symbol)
                                    return output;
                            }
                        return output;
                    }
                string          EverythingUpTo             ( char end_symbol)
                    {
                       char char_;
                       string output;
                       while (cin.get(char_) )
                            {
                                output = output + char_ ;
                                if (char_ == end_symbol)
                                    return output;
                            }
                        return output;
                    }
        // System           
            void  System      (string input_string)
                {
                    const char* conv_my_str = input_string.c_str();
                    system(conv_my_str);
                }
            void  EndProgram  ()
                    {
                        // save a success log
                        ofstream the_file_stream(".success.log");
                        the_file_stream << "success";
                        the_file_stream.close();
                        // press enter to exit
                        cout << "\npress enter to exit\n";
                        Pause();
                        exit(0);
                    }
            void  Poke        (string id_)
                {
                    cout << "Poked " << id_ << '\n';
                    EndProgram();
                }
        // String Helpers
            string operator*( const string&  base   , const long long&   repetitions  )
                {
                    string result;
                    for (int i = 0; i < repetitions; i++)
                        result += base;
                    return result;
                }
            string operator*(const long long&   repetitions , const string&  base)
                {
                    string result;
                    for (int i = 0; i < repetitions; i++)
                        result += base;
                    return result;
                
                }
            string Substring           ( string base, int start, int finish )
                {
                    if (start < 0)
                        start = base.size() + start;
                    else if (start > base.size())
                        start = base.size();
                    if (finish < 0)
                        finish = base.size() + finish;
                    else if (finish > base.size())
                        finish = base.size();
                    if (start > finish) {
                        int swap = start;
                        start = finish;
                        finish = swap;
                    }
                    return base.substr(start, finish - start);
                }

            string Substring           ( string base, int start )
                {
                    return Substring(base, start, base.length());
                }
            string Join                ( vector<string> base, string delimiter )
                {
                    string result;
                    for (int i = 0; i < base.size() - 1; i++)
                        result += base[i] + delimiter;
                    result += base[base.size() - 1];
                    return result;
                }

            string Join                ( vector<string> base, char delimiter )
                {
                    return Join(base, string(1, delimiter));
                }

            string Replace             ( string base, string oldstring, string newstring )
                {
                    int index = 0;
                    string current;
                    while (index <= base.length() - oldstring.length()) {
                        if (base.substr(index, oldstring.length()) == oldstring) {
                            current += newstring;
                            index += oldstring.length();
                            continue;
                        }
                        current += base[index];
                        index++;
                    }
                    return current;
                }

            string Replace             ( string base, char oldstring, string newstring )
                {
                    return Replace(base, string(1, oldstring), newstring);
                }

            string Replace             ( string base, string oldstring, char newstring )
                {
                    return Replace(base, oldstring, string(1, newstring));
                }

            string Replace             ( string base, char oldstring, char newstring )
                {
                    return Replace(base, string(1, oldstring), string(1, newstring));
                }

            string Replace             ( string base, string oldstring )
                {
                    return Replace(base, oldstring, "");
                }

            string Replace             ( string base, char oldstring )
                {
                    return Replace(base, string(1, oldstring), "");
                }
            string Strip               ( string input, char junk=' ' )
                {
                    if (input.size() == 0)
                        {
                            return "";
                        }
                    int num_front = -1;
                    while (input.at(++num_front) == junk){}
                    int num_end = input.size();
                    while (input.at(--num_end) == junk){}
                    return input.substr(num_front, 1+num_end - num_front);
                }
            string GetWhileIncluded    ( string input, string included_characters )
                {
                    string output = "";
                    for (auto each : input)
                        {
                            // if its valid 
                            if (Is__CharIn__String(each, included_characters))
                                {
                                    // add it
                                    output.push_back(each);
                                }
                            else
                                {
                                    break;
                                }
                        }
                    return output;
                }
            string RemoveWhileIncluded ( string input, string included_characters )
                {
                    string output = "";
                    int number_of_char_to_ignore = 0;
                    for (auto each : input)
                        {
                            // if its valid 
                            if (Is__CharIn__String(each, included_characters))
                                {
                                    ++number_of_char_to_ignore;
                                }
                            else
                                {
                                    break;
                                }
                        }
                    output = input.substr(number_of_char_to_ignore, output.size()-1);
                    return output;
                }
            vector<string>  Split                      ( string input, char splitter )
                {
                    vector<string> chunks;
                    chunks.push_back("");
                    input = Strip(input, splitter);
                    int char_index = -1;
                    int chunk_index = 0;
                    bool prev_char_was_splitter = false;
                    while (++char_index < input.size())
                        {
                            char current_character = input.at(char_index);
                            if (current_character == splitter)
                                {
                                    if (not prev_char_was_splitter)
                                        {
                                            chunks.push_back("");
                                            ++chunk_index;
                                        }
                                    prev_char_was_splitter = true;
                                    continue;
                                }
                            else
                                {
                                    prev_char_was_splitter = false;
                                    chunks.at(chunk_index).push_back(current_character);
                                }
                        }
                    return chunks;
                }
            template <class ANYTYPE, class ANYTYPE2> int StartIndexOfFirst__In__(ANYTYPE target_anytype, ANYTYPE2 base_anytype)
                {
                    // convert target to string
                    ostringstream stream1;
                    stream1 << target_anytype;
                    string target = stream1.str();
                    // convert base to string
                    ostringstream stream2;
                    stream2 << base_anytype;
                    string base = stream2.str();
                    
                    int index = 0;
                    while (index + target.length() <= base.length()) {
                        if (base.substr(index, target.length()) == target)
                            return index;
                        index++;
                    }
                    return -1;
                }

            template <class ANYTYPE, class ANYTYPE2> int StartIndexOfLast__In__(ANYTYPE target_anytype, ANYTYPE2 base_anytype)
                {
                    // convert target to string
                    ostringstream stream1;
                    stream1 << target_anytype;
                    string target = stream1.str();
                    // convert base to string
                    ostringstream stream2;
                    stream2 << base_anytype;
                    string base = stream2.str();
                    int index = base.length() - target.length();
                    while (index) {
                        if (base.substr(index, target.length()) == target)
                            return index;
                        index--;
                    }
                    return -1;
                }

            template <class ANYTYPE> vector<int> Indices(string base, ANYTYPE target_anytype)
                {
                    // convert target to string
                    ostringstream stream1;
                    stream1 << target_anytype;
                    string target = stream1.str();
                    
                    vector<int> indices;
                    int index = 0;
                    while (index + target.length() <= base.length()) {
                        if (base.substr(index, target.length()) == target)
                            indices.push_back(index);
                        index++;
                    }
                    return indices;
                }
            template <class ANYTYPE> bool        Includes(string base, ANYTYPE target_anytype)
                {
                    // convert target to string
                    ostringstream stream1;
                    stream1 << target_anytype;
                    string target = stream1.str();
                    
                    return (StartIndexOfFirst__In__(target, base) > -1);
                }

            template <class ANYTYPE> bool        Startswith(string base, ANYTYPE target_anytype)
                {
                    // convert target to string
                    ostringstream stream1;
                    stream1 << target_anytype;
                    string target = stream1.str();
                    
                    if (base.length() >= target.length())
                        return (base.substr(0, target.length()) == target);
                    return false;
                }

            template <class ANYTYPE> bool        Endswith(string base, ANYTYPE target_anytype)
                {
                    // convert target to string
                    ostringstream stream1;
                    stream1 << target_anytype;
                    string target = stream1.str();
                    
                    if (base.length() >= target.length())
                        return (base.substr(base.length() - target.length()) == target);
                    return false;
                }
            template <class ANYTYPE> string        the__thDigitOf__           (int position        , ANYTYPE input_)
                {
                    string input_as_string = to_string(input_);
                    return input_[ input_.size() - position  ];
                }
            bool            IsALegitFileName           ( string attempt_filename )
                    {
                        // letters, numbers, and dashes (must have at least one of any of those)
                        // allows a period only for file extentions
                        regex is_not_obnoxious = regex("[A-Za-z_0-9\\-]+(\\.[A-Za-z]+|)");
                        return regex_match(attempt_filename, is_not_obnoxious);
                    }
            string          Literal                    ( string input )
                {
                    char each_char;
                    stringstream char_stream;
                    char_stream << input;
                    string output;
                    int space_counter = 0;
                    int newline_counter = 0;
                    while (char_stream.get(each_char))
                        {
                            // spaces 
                            if (each_char == ' ')
                                { 
                                    space_counter++;
                                    if (char_stream.peek() != ' ')
                                        {
                                            output += "\\"+to_string(space_counter)+"SPACES";
                                            space_counter = 0;
                                        }
                                }
                            // newlines
                            else if (each_char == '\n')
                                {
                                    newline_counter++;
                                    if (char_stream.peek() != '\n')
                                        {
                                            output += "\\"+to_string(newline_counter)+"n\n"; 
                                            newline_counter = 0;
                                        }
                                }
                            // everything else 
                            else if (each_char == '\\')
                                output += "\\\\";
                            else if (each_char == '\t')
                                output += "\\t";
                            else if (each_char == '\0')
                                output += "\\0";
                            else if (each_char == '\r')
                                output += "\\r";
                            else if (each_char == '\v')
                                output += "\\v";
                            else if (each_char == '\b')
                                output += "\\b";
                            else 
                                output += each_char;
                        }
                    return output;
                }
            string          Literal                    ( char   input )
                {
                    stringstream output;
                    output << input;
                    string output_str = output.str();
                    return Literal(output_str);
                }
            bool            IsAllUpperCase             ( string input )
                {
                    { int Max_Value =  input .size()     ; for (int LoopNumber=1; LoopNumber <= Max_Value ; LoopNumber++) { int EachChar = LoopNumber - 1; 
                        if ( not isupper( input[EachChar] ) )
                            return false;
                        else 
                            return true;
                    } }
                }
            bool            IsAllUpperCase             ( char   input )
                {
                    return IsAllUpperCase(AsString(input));
                }
            bool            Is__CharIn__String         ( char   test_val , string input_string ) 
                { 
                    for (auto each : input_string)
                        {
                            if (each == test_val)
                                {
                                    return true;
                                }
                        }
                    return false;
                } 
            vector<string>  ExtractArguments           ( string& content, string end_characters, string ignore_characters=" \t", string encapsulate_characters="\"\'", vector<pair<char,string>> encapsulating_pairs={make_pair('(',")")})
                {
                    vector<string> arguments;
                    int index = 0;
                    vector<string> char_context_stack = {""};
                    string previous_char_as_string = "";
                    for (auto each : content)
                        {
                            index++;
                            string context = *(char_context_stack.end()-1);
                            // no context
                            if (context == "")
                                {
                                    // if ending character then we're done
                                    if (Is__CharIn__String(each, end_characters))
                                        {
                                            // dont count the final character
                                            index--;
                                            break;
                                        }
                                    // if ignore_characters, go to next character
                                    else if (Is__CharIn__String(each, ignore_characters))
                                        {
                                            // this is like continue, but needs to set a loop variable
                                            goto SKIP_CHAR;
                                        }
                                    // if valid/normal
                                    else
                                        {
                                            // 
                                            // add argument if needed
                                            // 
                                            // special case if its the first argument
                                            bool is_first_arg = (previous_char_as_string == "");
                                            // transition to new argument
                                            bool is_new_arg = not is_first_arg and Is__CharIn__String(*(previous_char_as_string.end()-1), ignore_characters);
                                            if (is_first_arg or is_new_arg)
                                                {
                                                    arguments.push_back("");
                                                }
                                            // 
                                            // add the character to the argument
                                            // 
                                            (*(arguments.end()-1)).push_back(each);
                                            // 
                                            // check for new contexts
                                            // 
                                            // basic encapsulator
                                            if (Is__CharIn__String(each, encapsulate_characters))
                                                {
                                                    char_context_stack.push_back(AsString(each));
                                                }
                                            // paired encapsulators
                                            else
                                                {
                                                    for (auto each_pair : encapsulating_pairs)
                                                        {
                                                            // if it matches the first char in a pair
                                                            if (Is__CharIn__String(each, AsString(each_pair.first)))
                                                                {
                                                                    // add the other half as the context
                                                                    char_context_stack.push_back(each_pair.second);
                                                                }
                                                        }
                                                }
                                        }
                                }
                            // if there is context
                            else
                                {
                                    // add the character 
                                    (*(arguments.end()-1)).push_back(each);
                                    // check if that was the end
                                    if (Is__CharIn__String(each, context))
                                        {
                                            // remove the context
                                            char_context_stack.pop_back();
                                        }
                                }
                            SKIP_CHAR:
                            previous_char_as_string = AsString(each);
                        }
                    // remove the parsed part
                    content = content.substr(index, content.size()-1);
                    return arguments;
                }
        // Number helpers
            template <class ANYTYPE>
            string ToBinary(ANYTYPE input)
                {
                    // depends on #include <bitset>
                    return bitset<8>(input).to_string();
                }
            int BinaryToInt(string input)
                {
                    // depends on #include <bitset>
                    return bitset<8>(input).to_ulong();
                }
            int Round ( double input_number ) { return input_number + 0.5; } 
            int Round ( float  input_number ) { return input_number + 0.5; } 
        // range
            vector<int> Range(int lower, int increment, int upper)
                {
                    vector<int> result;
                    if (increment > 0)
                        {
                            for (int i = lower; i < upper; i += increment)
                                {
                                    result.push_back(i);
                                }
                        }
                    else
                        {
                            for (int i = lower; i > upper; i += increment)
                                {
                                    result.push_back(i);
                                }
                        }
                    return result;
                }
            vector<int> Range(int lower, int upper)
                {
                    return Range(lower, 1, upper);
                }
            vector<int> Range(int upper)
                {
                    return Range(0, 1, upper);
                }
        // IO basic types 
            // CopyPaste Class IO
                //ostream& output (ostream& out, const classname& input_)
                //    {
                //        // name of class 
                //        out << "classname" << '\n';
                //        
                //                stringstream data_members;
                //                
                //        // for each datamember
                //        output( data_members , input_.datamember()); data_members << '\n';
                //        
                //                // format and return stream
                //                out << Indent( data_members.str() ) << '\n';
                //                return out;
                //    }
                //istream& input  (istream& in_,        classname& input_)
                //    {
                //    
                //        // check name of type 
                //        if ( EverythingUpTo('\n',in_) != "classname\n")
                //            return StreamFailed(in_);
                //        
                //  
                //                // unindent members
                //                string content = Input_Unindent(in_);
                //                // check fail
                //                if (content == "")
                //                    return StreamFailed(in_);
                //                // check end 
                //                if (content[content.size()-1] != '\n')
                //                    return StreamFailed(in_);
                //                // setup vars
                //                char should_always_be_a_newline;
                //                stringstream transfer_method;
                //                // get rid of the class's newline
                //                transfer_method << content.substr(0,content.size()-1);
                //            
                //    
                //        // create empty versions of all data members 
                //        datatype datamember;
                //        input( transfer_method, datamember ); transfer_method.get(should_always_be_a_newline);
                //            
                //  
                //                // if stream fails, then return fail 
                //                if (DidStreamFail(transfer_method))
                //                    return StreamFailed(in_);
                //            
                // 
                // 
                //        // check the data, make sure its valid 
                //        if ( !IsDataValid(datamember)) 
                //            return StreamFailed(in_);
                //
                //        // add the data to the input 
                //        input_.data = datamember
                //    
                //                // if everything worked return the stream! 
                //                return in_;
                //    }  
            // bool IO        
                ostream& output(ostream& out, const bool& input)
                    {
                        // name of class 
                        out << "bool" << '\n';
                        // each data member in_ class
                        if (input)
                            out << Indent("true") << '\n';
                        else 
                            out << Indent("false") << '\n';
                        return out;
                    }
                istream& input (istream& in_,        bool& input)
                        {
                            // check name of type 
                            if ( EverythingUpTo('\n',in_) != "bool\n")
                                return StreamFailed(in_);
                            // unindent everything
                            string content = Input_Unindent(in_);
                            // check fail
                            if (content == "")
                                return StreamFailed(in_);
                            // try to input data
                            if      (content == "true\n")
                                input = true;
                            else if (content == "false\n")
                                input = false;
                            // if not true or false, then fail
                            else 
                                return StreamFailed(in_);
                            // if everything worked return the stream! 
                            return in_;
                        }  
            // char IO        
                ostream& output(ostream& out, const char& input_char)
                    {
                        // name of class 
                        out << "char" << '\n';
                        // each data member in_ class
                        out << Indent(input_char) << '\n';
                        return out;
                    }
                istream& input (istream& in_,        char& input_char)

                        {
                            // reset the char
                            input_char = '\0';

                            // check name of class 
                            if ( EverythingUpTo('\n',in_) != "char\n")
                                return StreamFailed(in_);
                            // unindent everything
                            string char_content = Input_Unindent(in_);
                            // check fail
                            if (char_content == "")
                                return StreamFailed(in_);
                            // try to input data
                            if (char_content.size() == 2)
                                {
                                    if (char_content[1] == '\n')
                                        input_char = char_content[0];
                                    else 
                                        return StreamFailed(in_);
                                }
                            else 
                                return StreamFailed(in_);
                            // if everything worked return the stream! 
                            return in_;
                        }
            // int IO         
                ostream& output(ostream& out, const int& input)
                    {
                        // name of class 
                        out << "integer" << '\n';
                        // each data member in_ class
                        out << Indent(input) << '\n';
                        return out;
                    }
                istream& input (istream& in_,        int& input)
                        {
                            // check name of type 
                            if ( EverythingUpTo('\n',in_) != "integer\n")
                                return StreamFailed(in_);
                            // unindent everything
                            string content = Input_Unindent(in_);
                            // check fail
                            if (content == "")
                                return StreamFailed(in_);
                            // try to input data
                            stringstream content_as_stream;
                            content_as_stream << content;
                            char should_always_be_a_newline;
                            content_as_stream >> input; 
                            content_as_stream.get(should_always_be_a_newline);
                            // if failed somewhere, then return fail
                            if (DidStreamFail(content_as_stream)) 
                                return StreamFailed(in_);
                            // if everything worked return the stream! 
                            return in_;
                        }            
            // double IO      
                ostream& output(ostream& out, const double& input)
                    {
                        // name of class 
                        out << "double" << '\n';
                        // make sure and get all the decimals 
                        stringstream output;
                        output << setprecision(20) << input;
                        // each data member in_ class
                        out << Indent(output.str()) << '\n';
                        return out;
                    }
                istream& input (istream& in_,        double& input)
                        {
                            // check name of type 
                            if ( EverythingUpTo('\n',in_) != "double\n")
                                return StreamFailed(in_);
                            // unindent everything
                            string content = Input_Unindent(in_);
                            // check fail
                            if (content == "")
                                return StreamFailed(in_);
                            // try to input data
                            stringstream content_as_stream;
                            content_as_stream << content;
                            char should_always_be_a_newline;
                            content_as_stream >> input; 
                            content_as_stream.get(should_always_be_a_newline);
                            // if failed somewhere, then return fail
                            if (DidStreamFail(content_as_stream)) 
                                return StreamFailed(in_);
                            // if everything worked return the stream! 
                            return in_;
                        }            
            // long double IO 
                ostream& output(ostream& out, const long double& input)
                    {
                        // name of class 
                        out << "double" << '\n';
                        // make sure and get all the decimals 
                        stringstream output;
                        output << setprecision(20) << input;
                        // each data member in_ class
                        out << Indent(output.str()) << '\n';
                        return out;
                    }
                istream& input (istream& in_,        long double& input)
                        {
                            // check name of type 
                            if ( EverythingUpTo('\n',in_) != "double\n")
                                return StreamFailed(in_);
                            // unindent everything
                            string content = Input_Unindent(in_);
                            // check fail
                            if (content == "")
                                return StreamFailed(in_);
                            // try to input data
                            stringstream content_as_stream;
                            content_as_stream << content;
                            char should_always_be_a_newline;
                            content_as_stream >> input; 
                            content_as_stream.get(should_always_be_a_newline);
                            // if failed somewhere, then return fail
                            if (DidStreamFail(content_as_stream)) 
                                return StreamFailed(in_);
                            // if everything worked return the stream! 
                            return in_;
                        }            
            // string IO      
                ostream& output(ostream& out, const string& input)
                    {
                        // name of class 
                        out << "string" << '\n';
                        // each data member in_ class
                        out << Indent(input) << '\n';
                        return out;
                    }
                istream& input (istream& in_,        string& input)
                        {
                            // check name of class 
                            if ( EverythingUpTo('\n',in_) != "string\n")
                                return StreamFailed(in_);
                            
                            // unindent everything
                            string content = Input_Unindent(in_);
                            // check fail
                            if (content == "")
                                return StreamFailed(in_);
                            // if it doesn't end in_ newline, then fail
                            if (content[content.size()-1] != '\n')
                                return StreamFailed(in_);
                            // try to input data
                            input = content.substr(0,content.size()-1);
                            // if everything worked return the stream! 
                            return in_;
                        }                            
                // c-string IO 
                ostream& output(ostream& out, const char input[])
                    {
                        // name of class 
                        out << "string" << '\n';
                        // each data member in_ class
                        out << Indent(input) << '\n';
                        return out;
                    } 
            // general IO     
                template <class ANYTYPE> ostream& output(ostream& out, const ANYTYPE& input)
                    {
                         // name of class 
                        out << "default IO" << '\n';
                        // each data member in_ class
                        out << Indent(input) << '\n';
                        return out;
                    }
                template <class ANYTYPE> istream& input (istream& in_,        ANYTYPE& input)
                        {
                            // check name of type 
                            if ( EverythingUpTo('\n',in_) != "default IO\n")
                                return StreamFailed(in_);
                            // unindent everything
                            string content = Input_Unindent(in_);
                            // check fail
                            if (content == "")
                                return StreamFailed(in_);
                            // check end 
                            if (content[content.size()-1] != '\n')
                                return StreamFailed(in_);
                            // store data
                            stringstream transfer_method;
                            transfer_method << content.substr(0,content.size()-1);
                            transfer_method >> input;
                            // if stream fails, then return fail 
                            if (DidStreamFail(transfer_method))
                                return StreamFailed(in_);
                            // if everything worked return the stream! 
                            return in_;
                        }              
            // Conversion     
                template <class ANYTYPE> string AsString(const ANYTYPE& input)
                    {
                        stringstream data_stream;
                        output(data_stream, input);
                        // get rid of the name 
                        EverythingUpTo('\n', data_stream);
                        // get the content
                        string content = Input_Unindent(data_stream);
                        // remove the closing newline
                        content = content.substr(0,content.size()-1);
                        return content;
                    }
                template <class ANYTYPE> string TypeAsString(const ANYTYPE& input)
                    {
                        stringstream data_stream;
                        output(data_stream, input);
                        // get the name of the datatype
                        string name = EverythingUpTo('\n', data_stream);
                        // remove the closing newline
                        name = name.substr(0,name.size()-1);
                        return name;
                    }
        // VisualFormat basic types
            // general VisualFormat
                template<class ANYTYPE> // for most things just output via their << operator
                string VisualFormat(ANYTYPE input)
                {
                    stringstream out;
                    out << input;
                    return out.str();
                }
            // bool   
                string VisualFormat (bool   input)
                    {
                        string output;
                        if (input == true)
                            output = "true";
                        else
                            output = "false";
                        return output;
                    }
            // char   
                string VisualFormat (char   input)
                    {
                        return Literal(input);
                    }
            // int    
                string VisualFormat (int    input)
                    {
                        return to_string(input);
                    }
            // double 
                string VisualFormat (double input)
                    {
                        return to_string(input);
                    }
            // string 
                string VisualFormat (string input)
                    {
                        return input;
                    }
            // Special Visual Formats 
                string          VisualFormatDollars        (double input)
                    {
                        stringstream output;
                        output << fixed << setprecision(2);
                        output << '$';
                        output << input;
                        return output.str();
                    }
        // Show
            #define ThreadSafeCout(ARGS) {stringstream output; output << ARGS; cout << output.str(); };
            template<class ANYTYPE> string Show(ANYTYPE input)
                {
                    cout << VisualFormat(input);
                    return VisualFormat(input);
                }
        // Ask() basic types 
            string          Ask                        (string question_        )
                {
                    cout <<  question_ ; 
                    string Answer = "";
                    Getline(cin, Answer);
                    return Answer; 
                } 
            int             AskForAnInt                (string question_        )
                {
                    // this will match:
                    // *spaces(or nothing)*   *a negative symbol(or nothing)*   *9 digits or less*    *spaces(or nothing)*
                    regex  is_it_an_int("( *(-|)\\d{1,9} *)"); 
                    string answer_ = "";
                    
                    // loop until an integer is given
                    while (true){
                        answer_ = Ask(question_);
                        // check if the input is actually an integer
                        if ( regex_match(answer_, is_it_an_int) )
                            return stoi(answer_);
                        cout <<  "Sorry, but the input needs to be a (9 digits or less) positive integer\nplease try again"  << '\n';
                        }
                }
            double          AskForANumber              (string question_        )
                {
                    // this will match:
                    // *spaces(or nothing)*   *a negative symbol(or nothing)*   *9 digits or less*    *spaces(or nothing)*
                    regex  is_it_a_number("( *(-|)(\\d{0,12}\\.\\d{1,12}|\\d{1,18}) *)"); 
                    string answer_ = "";
                    
                    // loop until an integer is given
                    while (true){
                        answer_ = Ask(question_);
                        // check if the input is actually an integer
                        if ( regex_match(answer_, is_it_a_number) )
                            return stod(answer_);
                        cout <<  "Sorry, but the input needs to a number (12 digits or less)\nplease try again"  << '\n';
                        }
                }
            int             AskForAnIntFrom__To__      (string question_ , int smallest, int largest)
                    {
                        int integer_             = AskForAnInt( question_ );
                        string internal_question = "Sorry, please just enter a number from " + to_string(smallest) + " to " + to_string(largest) + " \n";
                        // keep asking the internal question until a valid number is given
                        while (true){  
                            if ( (integer_ >= smallest) && (integer_ <= largest) ) {
                                break; 
                            }  
                            integer_ = AskForAnInt( internal_question );
                            }
                        return integer_;
                    }
            double          AskForADoubleFrom__To__    (string question_ , double smallest, double largest)
                    {
                        double number_             = AskForANumber( question_ );
                        string internal_question = "Sorry, please enter a number from " + to_string(smallest) + " to " + to_string(largest) + " \n";
                        // keep asking the internal question until a valid number is given
                        while (true){  
                            if ( (number_ >= smallest) && (number_ <= largest) ) {
                                break; 
                            }  
                            number_ = AskForANumber( internal_question );
                            }
                        return number_;
                    }
            bool            AskYesOrNo                 (string question_) 
                    {
                        while (true){
                            // FIXME use regex here instead
                            string answer_ = Ask(question_);
                            if (          ( answer_ == "yes" || answer_ == "Yes" || answer_ == "y" || answer_ == "Y" ) ) {
                                return true;
                            } else if ( ( answer_ == "no"  || answer_ == "No"  || answer_ == "n" || answer_ == "N" ) ) {
                                return false;
                            }  
                            cout <<  "Sorry I don't understand your input :/"      << '\n'; 
                            cout <<  "Use 'yes' and 'no' and try avoiding spaces"  << '\n';
                            }
                    }
            string          AskForAFileName            (string question_)
                    {
                        while (true){
                                string file_name = Ask( question_ );
                                if ( IsALegitFileName(file_name) ) {
                                    return file_name; 
                                } 
                                // else 
                                cout <<  "Sorry, please only use letter, numbers, and underscores in_ the name\n";
                            }
                    }
            fstream         AskUserForExistingFile     (string question_)
                    {
                        while (true){
                                string name_ = AskForAFileName( question_ );
                                fstream the_file(name_);
                                if ( static_cast<bool>(the_file) ) {
                                    return the_file;
                                } 
                                cout <<  "Sorry I dont see that file, please enter another file name\n";
                            } 
                    }
        // File IO  
            template <class ANYTYPE> void    Save__In__     (ANYTYPE  data_to_save, string file_location)
                    {
                        ofstream the_file_stream(file_location);
                        output(the_file_stream, data_to_save);
                        the_file_stream.close();
                    }
            template <class ANYTYPE> void    Load__From__   (ANYTYPE& data_to_load, string file_location)
                    {
                        ifstream the_file_stream(file_location);
                        input(the_file_stream, data_to_load);
                        the_file_stream.close();
                    }
                    
            void SaveFile(string file_location, string content)
                {
                    ofstream the_file_stream(file_location);
                    the_file_stream << content;
                    the_file_stream.close();
                }
            string ReadFile(string file_location)
                {
                    ifstream the_file(file_location);
                    string content( (istreambuf_iterator<char>(the_file) ), istreambuf_iterator<char>());
                    the_file.close();
                    return content;
                }
            string  OpenFileAsString           (string file_location)
                {
                    fstream the_file(file_location);
                    if ( static_cast<bool>(the_file) ) {
                        return ReadFile(file_location);
                    } 
                    Error( "Sorry I dont see that file, please enter another file name\n");
                }
        // Threads
            // 
            // This is a function that is given to 
            // 
            void* thread_stub(void* context)
                {
                    // context is static_cast<void*>(&f) below. We reverse the cast to
                    // void* and call the function object.
                    function<void*()>& func = *static_cast<function<void*()>*>(context);
                    return func();
                }
            template <class ANY_OUTPUT_TYPE, class ANY_INPUT_TYPE>
            class TaskClass 
                {
                // summary/explaination
                    // What is this used for?
                        // if you want to run a function on a thread, and you don't want any segfaults
                        // this class makes input/output for threaded functions easy
                        // this class makes sure the arguments exist for the whole time that the thread exists (very importatnt)
                        // this class works with lambdas as well as normal functions
                    // How do I use it?
                        // auto immaFunction = function<int(string)>([&](string input_string)
                        //     {
                        //          cout << "I received this as an argument " << input_string << "\n"; 
                        //          return 69;
                        //     }
                        // string the_input = "Hello World";
                        // auto a_task = Task(immaFunction, the_input);
                        // int output_of_task = a_task.WaitForCompletion();
                    // Caveats
                        // The argument must have a copy constructor and a default (empty) constructor
                        // If the class you're using doesn't have those, then pass a pointer, or create a wrapper class that does have those
                    // How does it work?
                        // this class essentially contains 
                            // 1. a function 
                            // 2. a copy of the arguments for that function 
                            // 3. the output of the function
                            // 4. a thread id for the thread the function is being run on
                        // it wraps the functions it's given and then passes the wrapper function to the thread
                public:
                    // Data
                        pthread_t thread;
                        ANY_OUTPUT_TYPE (*thread_function)(ANY_INPUT_TYPE argument);
                        function<ANY_OUTPUT_TYPE(ANY_INPUT_TYPE argument)> lambda_thread_function;
                        function<void*()> functional_wrapper;
                        ANY_OUTPUT_TYPE output;
                        ANY_INPUT_TYPE arguments;
                        bool use_lambda = false;
                        bool has_been_waited_on = true; // by deafult the task is ready to start
                    // Constructors
                        TaskClass(const TaskClass &obj)
                            {
                                Error("Something somewhere is trying to copy a TaskClass() object. Sadly copying a TaskClass is not yet possible.\nThis is likely happening when trying to add a task to a vector or some similar operation.\nThis can often be fixed by using a TaskClass pointer instead");
                            }
                        TaskClass(function<ANY_OUTPUT_TYPE(ANY_INPUT_TYPE argument)> input_function, ANY_INPUT_TYPE input_arguments)
                            {
                                use_lambda = true;
                                lambda_thread_function = input_function;
                                arguments = input_arguments;
                            }
                        TaskClass(ANY_OUTPUT_TYPE (*input_function)(ANY_INPUT_TYPE argument))
                            {
                                thread_function = input_function;
                            }
                        TaskClass(ANY_OUTPUT_TYPE (*input_function)(ANY_INPUT_TYPE argument), ANY_INPUT_TYPE input_arguments)
                            {
                                thread_function = input_function;
                                arguments = ANY_INPUT_TYPE(input_arguments);
                            }
                    // Methods
                        void Start(const pthread_attr_t* attributes=NULL)
                            {
                                // if its possible the task is still running
                                if (has_been_waited_on == false) 
                                    {
                                        cout << "for task with address = " << this << "\n";
                                        cout << "I think you're trying to start this task but it hasn't been waited on yet.\n";
                                        cout << "either do the_task.WaitForCompletion() before trying to restart this task, or create a seperate task object\n";
                                        return;
                                    }
                                // if the task wasnt running before, it is now
                                has_been_waited_on = false;
                                functional_wrapper = function<void*()>([&]() mutable -> void* {
                                        // give the input arguments (stored on the the task object) to the function
                                        // and save the output to the task object
                                        if (use_lambda)
                                            {
                                                output = lambda_thread_function(arguments);
                                            }
                                        else
                                            {
                                                output = thread_function(arguments);
                                            }
                                        has_been_waited_on = true;
                                        pthread_exit(NULL);
                                        return NULL;
                                    });
                                pthread_create(&thread, attributes, thread_stub, &functional_wrapper);
                            }
                        ANY_OUTPUT_TYPE WaitForCompletion()
                            {
                                // wait for the thread to finish
                                pthread_join(thread, NULL);
                                // this task is no longer running
                                has_been_waited_on = true;
                                // return the output
                                return output;
                            }
                };
            pthread_t __dummy_thread;
            template <class ANY_OUTPUT_TYPE, class ANY_INPUT_TYPE>
            class Task
                {
                // summary/explaination:
                    // This is just a wrapper for a TaskClass pointer
                    // it is created so that copies (shallow copies) can be made without breaking everything and causing a segfault
                    // it keeps track of how many shallow copies there are for a proticular task and once the last shallow copy is destroyed it deletes the original TaskClass obj/pointer to prevent memoryleaks
                public:
                    // data
                        static map<TaskClass<ANY_OUTPUT_TYPE, ANY_INPUT_TYPE>*, int> links_to;
                        TaskClass<ANY_OUTPUT_TYPE, ANY_INPUT_TYPE>* ptr_to_original = nullptr;
                        pthread_t& thread;
                    // constructors
                        Task() : thread(__dummy_thread)
                            {
                            }
                        Task(TaskClass<ANY_OUTPUT_TYPE, ANY_INPUT_TYPE>* a_task_ptr) : thread(__dummy_thread)
                            {
                                ptr_to_original = a_task_ptr;
                                // if no links
                                if (links_to.find(ptr_to_original) == links_to.end())
                                    {
                                        // then set the initial number of links to 0
                                        links_to[ptr_to_original] = 0;
                                    }
                                // add one link
                                ++links_to[ptr_to_original];
                                thread = a_task_ptr->thread;
                            }
                        Task(const Task &obj) : thread(__dummy_thread)
                            {
                                ptr_to_original = obj.ptr_to_original;
                                thread = obj.ptr_to_original->thread;
                                // if no links
                                if (links_to.find(ptr_to_original) == links_to.end())
                                    {
                                        // then set the initial number of links to 0
                                        links_to[ptr_to_original] = 0;
                                    }
                                // add one link
                                ++links_to[ptr_to_original];
                            }
                        ~Task()
                            {
                                // decrement one link
                                --links_to[ptr_to_original];
                                // if no links, then delete
                                if (links_to[ptr_to_original] == 0)
                                    {
                                        delete ptr_to_original;
                                    }
                            }
                    // methods
                        void SetOriginal(TaskClass<ANY_OUTPUT_TYPE, ANY_INPUT_TYPE>* a_pointer)
                            {
                                ptr_to_original = a_pointer;
                                ++links_to[ptr_to_original];
                                thread = &(a_pointer->thread);
                            }
                        void Start(const pthread_attr_t* attributes=NULL)
                            {
                                if (ptr_to_original == nullptr)
                                    {
                                        ThreadSafeCout("You're tring to start a Task object, but its pointer points to nullptr\nThe address of the object is: " << this << "\n");
                                    }
                                else
                                    {
                                        ptr_to_original->Start();
                                    }
                            }
                        ANY_OUTPUT_TYPE WaitForCompletion()
                            {
                                return ptr_to_original->WaitForCompletion();
                            }
                        bool StillRunning()
                            {
                                return not ptr_to_original->has_been_waited_on;
                            }
                    // operators
                        Task& operator=( const Task& obj )
                            {
                                ptr_to_original = obj.ptr_to_original;
                                thread = obj.ptr_to_original->thread;
                                // if no links
                                if (links_to.find(ptr_to_original) == links_to.end())
                                    {
                                        // then set the initial number of links to 0
                                        links_to[ptr_to_original] = 0;
                                    }
                                // add one link
                                ++links_to[ptr_to_original];
                                return this;
                            }
                };
            template <class ANY_OUTPUT_TYPE, class ANY_INPUT_TYPE> map<TaskClass<ANY_OUTPUT_TYPE, ANY_INPUT_TYPE>*, int> Task<ANY_OUTPUT_TYPE, ANY_INPUT_TYPE>::links_to;
            // have the TaskClass automatically detect the argument and return type
            #define Task(FUNC, ARG) Task<decltype(FUNC(decltype(ARG){})), decltype(ARG)>(new TaskClass<decltype(FUNC(decltype(ARG){})), decltype(ARG)>(FUNC, ARG));
                // Helpers
                void* WaitFor(pthread_t thread)
                    {
                        void * _Nullable * _Nullable output = NULL;
                        pthread_join(thread, output);
                        return (void*)output;
                    }
            class LockManagerClass
                {
                public:
                    // data
                        map<void*, pthread_mutex_t> map_of_locks;
                    // methods
                        void Lock(void* varaible_address)
                            {
                                // if there isn't a mutex for the address, then make one
                                if (map_of_locks.find(varaible_address) == map_of_locks.end())
                                    {
                                        // make a mutex
                                        map_of_locks[varaible_address] = PTHREAD_MUTEX_INITIALIZER;
                                    }
                                // lock the mutex
                                pthread_mutex_lock(&(map_of_locks[varaible_address]));
                            }
                        void Unlock(void* varaible_address)
                            {
                                // If there isn't a mutex for the var, then do nothing
                                if (map_of_locks.find(varaible_address) == map_of_locks.end())
                                    {
                                        return;
                                    }
                                // unlock the mutex 
                                else
                                    {
                                        pthread_mutex_unlock(&(map_of_locks[varaible_address]));
                                    }
                            }
                } LockManager;
                #define Lock(ARGS) LockManager.Lock((void*)(&ARGS))
                #define Unlock(ARGS) LockManager.Unlock((void*)(&ARGS))
//////////////////////
//
// Secondary helper functions
//
//////////////////////
    // Vector functions 
        // IO           
            template <class    ANYTYPE> ostream&   output   (ostream& out, const vector<ANYTYPE>& input_vector)
                {
                    bool local_debug = false;
                    // name of class 
                    out << "vector" << '\n';
                    // each data member in_ class
                    stringstream all_members;
                    for ( ANYTYPE each : input_vector ) 
                        { 
                            output(all_members, each);
                            all_members << '\n';
                        }
                    // if no data members
                    if (input_vector.size() == 0)
                        all_members << "\n";
                    
                    // Indent the whole thing
                    if (local_debug) cout << "all_members is " << Literal(all_members.str()) << "\n";
                    string all_members_str = all_members.str();
                    out << Indent(all_members_str) << '\n';
                    return out;
                }
            template <class    ANYTYPE> istream&   input    (istream& in_, vector<ANYTYPE>& input_vector)
                {
                    bool local_debug = true;
                    // reset the input vector
                    input_vector = {};
                    
                    // check name of class 
                    if ( EverythingUpTo('\n',in_) != "vector\n")
                        return StreamFailed(in_);
                    // unindent everything
                    string vector_content = Input_Unindent(in_);
                    if (local_debug) cout << "vector content:\n";
                    if (local_debug) cout << Literal(vector_content) << '\n';
                    // check fail
                    if (vector_content == "")
                        return StreamFailed(in_);
                    // check no members
                    if ( vector_content == "\n" )
                        return in_;
                    // try to input data
                    ANYTYPE data_member;
                    stringstream vector_content_as_stream;
                    vector_content_as_stream << vector_content;
                    char should_always_be_a_newline;
                    // try inputting data members till EOF 
                    do 
                        {
                            input(vector_content_as_stream, data_member);
                            vector_content_as_stream.get(should_always_be_a_newline);
                            if ( DidStreamFail(vector_content_as_stream) )
                                {
                                    return StreamFailed(in_);
                                }
                            input_vector.push_back(data_member);
                        } while(not EndOfStream(vector_content_as_stream) );
                    // if no data members were added, report an error
                    if (input_vector.size() == 0)
                        return StreamFailed(in_);
                    // if everything worked return the stream! 
                    return in_;
                }
        // VisualFormat 
            template <class    ANYTYPE> string          VisualFormat                  (vector<ANYTYPE> input)
                {
                    stringstream output;
                    for ( ANYTYPE each : input ) 
                        {
                            output << VisualFormat(each) << '\n';
                        }
                    return Indent(output.str());
                }
        // helpers      
            template <class    ANYTYPE> void            Remove__ThElementFrom__Vector (int element_number  , vector<ANYTYPE>& input_vector ) 
                { 
                    input_vector.erase(input_vector.begin() + element_number);
                } 
            template <class    ANYTYPE> bool            Is__In__Vector                (ANYTYPE test_val    , vector<ANYTYPE>& input_vector ) 
                { 
                    for (auto each : input_vector)
                        {
                            if (each == test_val)
                                {
                                    return true;
                                }
                        }
                } 
            template <class    ANYTYPE> bool            Is__In__                      (ANYTYPE test_val    , vector<ANYTYPE>& input_vector ) 
                { 
                    { int Max_Value =  input_vector .size()     ; for (int LoopNumber=1; LoopNumber <= Max_Value ; LoopNumber++) { int EachItem = LoopNumber - 1; 
                        if ( input_vector.at( EachItem ) == test_val ) { 
                            return true ;
                        } 
                    } } 
                    return false ; 
                } 
            template <class    ANYTYPE> int             IndexOf__In__Vector           (ANYTYPE test_val    , vector<ANYTYPE>& input_vector ) 
                { 
                    { int Max_Value =  input_vector .size()     ; for (int LoopNumber=1; LoopNumber <= Max_Value ; LoopNumber++) { int EachItem = LoopNumber - 1; 
                        if ( (input_vector.at( EachItem ) == test_val) ) { 
                            return EachItem;
                        } 
                    } } 
                    return -1; 
                } 
            template <class    ANYTYPE> void            RemoveFirst__From__Vector     (ANYTYPE element_    , vector<ANYTYPE>& input_vector ) 
                { 
                    int element_number = IndexOf__In__Vector(element_ , input_vector);
                    input_vector.erase(input_vector.begin() + element_number);
                } 
            template <class    ANYTYPE> int             NumberOf__In__Vector          (ANYTYPE test_val    , vector<ANYTYPE>& input_vector ) 
                { 
                    int number_of_matches;
                    { int Max_Value =  input_vector .size()     ; for (int LoopNumber=1; LoopNumber <= Max_Value ; LoopNumber++) { int EachItem = LoopNumber - 1; 
                        if ( input_vector.at( EachItem ) == test_val ) { 
                            number_of_matches++;
                        } 
                    } } 
                    return number_of_matches; 
                } 
            template <class    ANYTYPE> vector<ANYTYPE> RemoveDuplicates              (                      vector<ANYTYPE>& input_vector ) 
                { 
                    vector<ANYTYPE> search_vector; 
                    { int Max_Value =  input_vector .size()     ; for (int LoopNumber=1; LoopNumber <= Max_Value ; LoopNumber++) { int EachItem = LoopNumber - 1; 
                            if ( Is__In__Vector( input_vector.at(EachItem) , search_vector ) ) {
                                Remove__ThElementFrom__Vector(EachItem, input_vector);
                            } else {
                                search_vector.push_back( input_vector.at(EachItem) );
                            }  
                    } } 
                }
            char**                                      VectorStringToCStringArray    (vector<string>& input)
                {
                    // NOTE if you dont delete the output manually, there will be a memory leak
                    // find largest string
                    int largest_string = 0;
                    for (auto each : input)
                        {
                            largest_string = each.size() > largest_string ? each.size() : largest_string;
                        }
                    // create a vector of c-strings
                    vector<char*> vector_of_c_strings;
                    for (auto each : input)
                        {
                            char* new_string = new char[each.size()];
                            strcpy(new_string, each.c_str());
                            vector_of_c_strings.push_back(new_string);
                        }
                    // terminate it with a null pointer
                    vector_of_c_strings.push_back(NULL);
                    
                    // create the array
                    char** output = new char*[vector_of_c_strings.size()];
                    copy(vector_of_c_strings.begin(), vector_of_c_strings.end(), output);
                    return output;
                }

            template <typename T> vector<T>   Slice     (vector<T> base, int start, int finish)
                {
                    vector<T> result;
                    if (start < 0)
                        start = base.size() + start;
                    else if (start > base.size())
                        start = base.size();
                    if (finish < 0)
                        finish = base.size() + finish;
                    else if (finish > base.size())
                        finish = base.size();
                    if (start > finish) {
                        int swap = start;
                        start = finish;
                        finish = swap;
                    }
                    for (int i = start; i < finish; i++)
                        result.push_back(base[i]);
                    return result;
                }

            template <typename T> vector<T>   Slice     (vector<T> base, int start)
                {
                    return Slice(start, base.size());
                }

            template <typename T> vector<T>   Splice    (vector<T> base, int start, int count, vector<T> additions)
                {
                    vector<T> result;
                    if (start < 0)
                        start = base.size() + start;
                    else if (start > base.size())
                        start = base.size();
                    if (count > base.size() - start)
                        count = base.size() - start;
                    for (int i = 0; i < start; i++)
                        result.push_back(base[i]);
                    for (int i = 0; i < additions.size(); i++)
                        result.push_back(additions[i]);
                    for (int i = start + count; i < base.size(); i++)
                        result.push_back(base[i]);
                    return result;
                }

            template <typename T> vector<T>   Splice    (vector<T> base, int start, int count)
                {
                    vector<T> empty;
                    return Splice(base, start, count, empty);
                }

            template <typename T> vector<T>   Splice    (vector<T> base, int start, vector<T> additions)
                {
                    return Splice(base, start, 0, additions);
                }

            template <typename T> int         Index     (vector<T> base, T target)
                {
                    int index = 0;
                    while (index < base.size()) {
                        if (base[index] == target)
                            return index;
                        index++;
                    }
                    return -1;
                }

            template <typename T> int         LastIndex (vector<T> base, T target)
                {
                    int index = base.size();
                    while (index) {
                        if (base[index] == target)
                            return index;
                        index--;
                    }
                    return -1;
                }

            template <typename T> vector<int> Indices   (vector<T> base, T target)
                {
                    vector<int> indices;
                    int index = 0;
                    while (index < base.size()) {
                        if (base[index] == target)
                            indices.push_back(index);
                        index++;
                    }
                    return indices;
                }

            template <typename T> bool        Includes  (vector<T> base, T target)
                {
                    return (Index(base, target) > -1);
                }
    // Map functions
        // IO           
            // Pairs 
                template <class ANYTYPE, class ANYSECONDTYPE> ostream& output (ostream& out, const pair<ANYTYPE,ANYSECONDTYPE>& input_)
                    {
                        bool local_debug = false;
                        // name of class 
                        out << "pair" << '\n';
                        stringstream all_members;
                        // each data member in_ class
                        output(all_members, input_.first ); all_members << '\n';
                        output(all_members, input_.second); all_members << '\n';
                        // Indent the whole thing
                        if (local_debug) cout << "all_members is " << Literal(all_members.str()) << "\n";
                        
                        string all_members_str = all_members.str();
                        out << Indent(all_members_str) << '\n';
                        return out;
                    }
                template <class ANYTYPE, class ANYSECONDTYPE> istream& input  (istream& in_,        pair<ANYTYPE,ANYSECONDTYPE>& input_)
                    {
                    
                        // check name of type 
                        if ( EverythingUpTo('\n',in_) != "pair\n")
                            return StreamFailed(in_);
                        
                  
                                // unindent members
                                string content = Input_Unindent(in_);
                                // check fail
                                if (content == "")
                                    return StreamFailed(in_);
                                // check end 
                                if (content[content.size()-1] != '\n')
                                    return StreamFailed(in_);
                                // setup vars
                                char should_always_be_a_newline;
                                stringstream transfer_method;
                                // get rid of the class's newline
                                transfer_method << content.substr(0,content.size()-1);
                            
                    
                        // create empty versions of all data members 
                        ANYTYPE  datamember1;
                        ANYSECONDTYPE datamember2;
                        input( transfer_method, datamember1 ); transfer_method.get(should_always_be_a_newline);
                        input( transfer_method, datamember2 ); transfer_method.get(should_always_be_a_newline);
                            
                  
                                // if stream fails, then return fail 
                                if (DidStreamFail(transfer_method))
                                    return StreamFailed(in_);
                            
                 
                
                        // add the data to the input 
                        input_.first  = datamember1;
                        input_.second = datamember2;
                    
                                // if everything worked return the stream! 
                                return in_;
                    }
            // Maps  
                template <class ANYTYPE, class ANYSECONDTYPE> ostream& output (ostream& out, const map<ANYTYPE,ANYSECONDTYPE>& input_)
                    {
                        // name of class 
                        out << "map" << '\n';
                        
                                stringstream data_members;
                                
                        // for each datamember
                        for ( pair<ANYTYPE,ANYSECONDTYPE> each : input_ ) 
                            { 
                                output(data_members, each); data_members << '\n';
                            }
                    
                                // format and return stream
                                out << Indent( data_members.str() ) << '\n';
                                return out;
                    }
                template <class ANYTYPE, class ANYSECONDTYPE> istream& input  (istream& in_,        map<ANYTYPE,ANYSECONDTYPE>& input_)
                    {
                    
                        // check name of type 
                        if ( EverythingUpTo('\n',in_) != "map\n")
                            return StreamFailed(in_);
                        
                  
                                // unindent members
                                string content = Input_Unindent(in_);
                                // check fail
                                if (content == "")
                                    return StreamFailed(in_);
                                // check end 
                                if (content[content.size()-1] != '\n')
                                    return StreamFailed(in_);
                                // setup vars
                                char should_always_be_a_newline;
                                stringstream transfer_method;
                                // get rid of the class's newline
                                transfer_method << content.substr(0,content.size()-1);
                            
                    
                    
                        // check for no members
                        if ( content == "\n" )
                            return in_;
                        
                        // try to input data
                        pair<ANYTYPE,ANYSECONDTYPE> data_member;
                        map<ANYTYPE,ANYSECONDTYPE>  data_member_holder;
                        // try inputting data members till EOF 
                        do 
                            {
                                input(transfer_method, data_member);
                                transfer_method.get(should_always_be_a_newline);
                                if ( DidStreamFail(transfer_method) )
                                    {
                                        return StreamFailed(in_);
                                    }
                                data_member_holder[data_member.first] = data_member.second;
                            } while(not EndOfStream(transfer_method) );        
                                
                
                        // add the data to the input 
                        input_ = data_member_holder;
                    
                                // if everything worked return the stream! 
                                return in_;
                    }  
        // VisualFormat 

        // helpers      
            template <class ANYTYPE, class ANYSECONDTYPE> bool   Is__KeyIn__Map   (ANYTYPE key,   map<ANYTYPE,       ANYSECONDTYPE> input_map)
                {
                    // maps      http://www.cprogramming.com/tutorial/stl/stlmap.html
                    if(input_map.find(key) == input_map.end())
                        return false;
                    return true;
                }
            template <class ANYTYPE, class ANYSECONDTYPE> bool   Is__ValueIn__Map (ANYTYPE value, map<ANYSECONDTYPE, ANYTYPE      > input_map)
                {
                    // maps     http://stackoverflow.com/questions/26281979/c-loop-through-map
                    for( auto const& each : input_map )
                        {
                            if (each.second == value)
                                {
                                    return true;
                                }
                        }
                    return false;
                }
            template <class ANYTYPE, class ANYSECONDTYPE> ANYSECONDTYPE KeyOfFirst__ValueIn__Map (ANYTYPE value, map<ANYSECONDTYPE, ANYTYPE      > input_map)
                {
                    // maps     http://stackoverflow.com/questions/26281979/c-loop-through-map
                    for( auto const& each : input_map )
                        {
                            if (each.second == value)
                                {
                                    return each.first;
                                }
                        }
                    ANYSECONDTYPE null_;
                    return null_;
                }
            template <class ANYTYPE                     > bool   Is__In__         (ANYTYPE value,   map<ANYTYPE, ANYTYPE> input_map)
                    {
                        if (Is__KeyIn__Map(value, input_map))
                            return true;
                        if (Is__ValueIn__Map(value, input_map))
                            return true;
                        return false;
                    }
            template <class ANYTYPE, class ANYSECONDTYPE> bool   Is__In__         (ANYTYPE value,   map<ANYTYPE, ANYSECONDTYPE> input_map)
                    {
                        if (Is__KeyIn__Map(value, input_map))
                            return true;
                    }
            template <class ANYTYPE, class ANYSECONDTYPE> bool   Is__In__         (ANYTYPE value,   map<ANYSECONDTYPE, ANYTYPE> input_map)
                    {
                        if (Is__ValueIn__Map(value, input_map))
                            return true;
                    }

    // Misc 
        // how to test if a class has a member function 
            // SFINAE test
            // from http://stackoverflow.com/questions/257288/is-it-possible-to-write-a-template-to-check-for-a-functions-existence
            //            template <typename ANYTYPE>
            //            class has_nameoffunction
            //                {
            //                    typedef char one;
            //                    typedef long two;
            //
            //                    template <typename TEST_CLASS> static one test( decltype(&TEST_CLASS::nameoffunction) ) ;
            //                    template <typename TEST_CLASS> static two test(...);    
            //
            //                public:
            //                    enum { value = sizeof(test<ANYTYPE>(0)) == sizeof(char) };
            //                };
            //            has_nameoffunction<class_that_you_want_to_test>::value // will return true if the class has the member function
        // how to get class names 
            // derived this from 
            // http://stackoverflow.com/questions/3649278/how-can-i-get-the-class-name-from-a-c-object
            // FIXME, I think this can be replaced with typeid() from #include <typeinfo> https://stackoverflow.com/questions/11310898/how-do-i-get-the-type-of-a-variable#11310937
            #include <cxxabi.h>
            template <class ANYTYPE>
            string Type(ANYTYPE input)
                {
                    stringstream output;
                    int status;
                    char * demangled = abi::__cxa_demangle(typeid(input).name(),0,0,&status);
                    output << demangled ;
                    free(demangled);
                    return output.str();
                }




////////////////////////
//
//  Custom Types
//
////////////////////////


    // pre-declare Item
    class Item;     
    // List
    template <typename ITEM> class List
        {
            // data
                vector<ITEM>    vector_ ;
                vector<ITEM>    values  ;
                vector<string>  names   ; 


        public:
            // member functions 
                // NumberOfItems    
                    int NumberOfItems() const 
                        { 
                            return vector_.size()+names.size(); 
                        }
                // AddToBottom      
                    template <class ANYTYPE> void AddToBottom(const ANYTYPE& input )
                        {
                            vector_ .push_back( ITEM(input) );
                        }
                // *AddToTop        
                        // needs to change the index of everything in_ map
                        // needs to 
                // *ExtractTopItem
                // *ExtractBottomItem
                // Remove__ThItem   
                    void Remove__ThItem  (const long int& item_position  )
                        {
                            if ( item_position > vector_.Size() or item_position < 1 ) { 
                                Error( "Somewhere there's a command trying to use Remove__ThItem() with an out-of-bounds value\n" );
                            }  
                            Remove__ThElementFrom__Vector((item_position -1), vector_);
                        } 
                // Remove__         
                    void Remove__  (const string& name  )
                        {
                            { int Max_Value =  names .size()     ; for (int LoopNumber=1; LoopNumber <= Max_Value ; LoopNumber++) { int EachItem = LoopNumber - 1;
                                if ( name == names.at(EachItem) )
                                    {
                                        Remove__ThElementFrom__Vector(EachItem, names );
                                        Remove__ThElementFrom__Vector(EachItem, values);
                                        // should be able to end because there should be no duplicate name entrys 
                                        return;
                                    }
                            } }

                        } 
                // From__To__       
                    List<ITEM>     From__To__      (const int& starting_spot, const int& ending_spot ) 
                        {
                            List<ITEM> output_list; 
                            { int Max_Value =   (ending_spot - starting_spot ) + 1     ; for (int LoopNumber=1; LoopNumber <= Max_Value ; LoopNumber++) { 
                                    output_list.AddToBottom(vector_.at(LoopNumber-1));
                             } }
                            return output_list; 
                        }
                // *RemoveFrom__To__
                // Data             
                    vector<ITEM> Data () const 
                        { 
                            return vector_ + values;   
                        }
                // Vector           
                    vector<ITEM> Vector () const 
                        { 
                            return vector_;   
                        }
                // Names            
                    vector<string> Names() const
                        {
                                return names;
                        }
                // NamedValues      
                    vector<ITEM> NamedValues () const 
                        { 
                            return values;   
                        }
                // Is__AName        
                        template<class ANYTYPE> bool Is__AName(ANYTYPE input_)
                            {
                                // if its not a string then it can't be a name 
                                ITEM input_as_item = ITEM(input_);
                                if ( input_as_item.Type() != "string" ) { 
                                    return false;
                                }  
                                return Is__In__Vector(input_as_item.Data(), names);
                            }
                // Is__ANamedValue  
                            template <class ANYTYPE> bool Is__ANamedValue(ANYTYPE input)
                                {
                                    return Is__In__Vector(ITEM(input),values);
                                }
                // Is__AVectorValue 
                            template <class ANYTYPE> bool Is__AVectorValue(ANYTYPE input)
                                {
                                    return Is__In__Vector(ITEM(input),vector_);
                                }
                // Is__AValue       
                            template <class ANYTYPE> bool Is__AValue(ANYTYPE input)
                                {
                                    if ( Is__In__Vector(ITEM(input),values) )
                                        return true;
                                    if ( Is__In__Vector(ITEM(input),vector_) )
                                        return true;
                                    return false;
                                }
                // Has              
                        template <class ANYTYPE> bool Has(ANYTYPE input)
                                {
                                    return Is__AName(ITEM(input)) || Is__ANamedValue(ITEM(input)) || Is__AValue(ITEM(input));
                                }
                // SizeOfLargestName
                    int SizeOfLargestName() const
                        {
                            int largest_size =0;
                            for( auto const& each : names )
                                {
                                    if (each.size() > largest_size)
                                        {
                                            largest_size = each.size();
                                        }
                                }  
                            return largest_size;
                        }
                // Sample           
                    string  Sample() const
                        { 
                            // if theres nothing in_ the list, return nothing 
                            if (vector_.size() == 0)
                                return "*NOTHING*";
                            short int first_few = (vector_.size() > 3) ? 3 : vector_.size();
                            string output_string = "";
                            { int Max_Value =  first_few     ; for (int LoopNumber=1; LoopNumber <= Max_Value ; LoopNumber++) {
                                output_string = output_string + vector_.at(LoopNumber-1).Data() + '\n' ;
                             } }
                            return output_string;
                            
                        }
                // At               
                    ITEM& At (int position )
                        {
                            bool is_in_bounds = abs(position) <= vector_.size() && position != 0;
                            bool is_negative  = position      < 0;
                            if ( is_in_bounds ) 
                                { 
                                    if ( is_negative ) 
                                        { 
                                            // if -1 then return the last element 
                                            // if -2 then return 2nd-to-last element 
                                            // etc 
                                            return vector_.at(vector_.size() + position);
                                        } 
                                    else 
                                        { 
                                            return vector_.at(position-1);
                                        }  
                                } 
                            else 
                                { 
                                    if ( is_negative ) 
                                        { 
                                            Error(  "Somewhere the code is asking for item "+to_string(position)+" in_ a list\b"
                                                +"But that item doesn't exist :/\n" 
                                                +"Here is a sample of the list:\n"
                                                +this->Sample() );
                                            // if the position doesnt exist, then create it (and all of the inbetween values)
                                        } 
                                    else 
                                        {
                                            int missing_items = position - vector_.size();
                                            { int Max_Value =  missing_items     ; for (int LoopNumber=1; LoopNumber <= Max_Value ; LoopNumber++) { 
                                                vector_.push_back(ITEM());
                                             } }
                                            return vector_.at(position-1);
                                        } 
                                }  // end if is_in_bounds
                        } // end at
                // Input            
                    istream& Input  (istream& in_)
                        {
                        
                            // check name of type 
                            if ( EverythingUpTo('\n',in_) != "List\n")
                                return StreamFailed(in_);
                            
                      
                                    // unindent members
                                    string content = Input_Unindent(in_);
                                    // check fail
                                    if (content == "")
                                        return StreamFailed(in_);
                                    // check end 
                                    if (content[content.size()-1] != '\n')
                                        return StreamFailed(in_);
                                    // setup vars
                                    char should_always_be_a_newline;
                                    stringstream transfer_method;
                                    // get rid of the class's newline
                                    transfer_method << content.substr(0,content.size()-1);
                                
                            
                            // create empty versions of all data members 
                            input( transfer_method , vector_ ); transfer_method.get(should_always_be_a_newline);
                            input( transfer_method , values  ); transfer_method.get(should_always_be_a_newline);
                            input( transfer_method , names   ); transfer_method.get(should_always_be_a_newline);
                      
                                    // if stream fails, then return fail 
                                    if (DidStreamFail(transfer_method))
                                        return StreamFailed(in_);
                    
                        
                        
                                    // if everything worked return the stream! 
                                    return in_;
                        }  
            // internal overloads
                Item& operator[] (long int position) 
                    {
                        return this->At(position);
                    }
                Item& operator[] (string   name) 
                    {
                        // if name is in_ names, return the value
                        long int index_ = IndexOf__In__Vector(name, names);
                        if ( index_ != -1 )
                            {
                                return values.at(index_);
                            }
                        else 
                            {
                                // add the name 
                                names .push_back(  name  );
                                values.push_back( ITEM() );
                                // return the Item 
                                return values.at(values.size()-1);
                            }
                    }
                template <class ANYTYPE> List<ITEM>& operator=  (vector<ANYTYPE> const &assignment_data) 
                    { 
                        vector_ = {};
                        { int Max_Value =  assignment_data .size()     ; for (int LoopNumber=1; LoopNumber <= Max_Value ; LoopNumber++) { int EachItem = LoopNumber - 1; 
                            vector_.push_back(     Item(  assignment_data.at(EachItem)  )     );
                        } } 
                        return *this;
                    }
                List<ITEM>& operator=  (vector<Item> const &assignment_data) 
                    { 
                        vector_ = assignment_data; 
                        return *this;
                    }
        };
            // external overloads 
                // IO          
                    template <class ITEM> ostream& output (ostream& out, const List<ITEM>& input_)
                        {
                            // name of class 
                            out << "List" << '\n';
                            
                                    stringstream data_members;
                                    
                            // for each datamember
                            output( data_members , input_.Vector     ()); data_members << '\n';
                            output( data_members , input_.Names      ()); data_members << '\n';
                            output( data_members , input_.NamedValues()); data_members << '\n';
                            
                                    // format and return stream
                                    out << Indent( data_members.str() ) << '\n';
                                    return out;
                        }
                    template <class ITEM> istream& input  (istream& in_,        List<ITEM>& input_)
                        {
                            return input_.Input(in_);
                        }  
                // VisualFormat
                        template <typename ITEM> string VisualFormat( const List<ITEM>& input_)
                            {
        
                                // output both
                                if ( input_.NamedValues().size() >= 1 and input_.Vector().size() >= 1 ) 
                                    {
                                        stringstream named_values_stream;
                                        
                                        { int Max_Value =  input_.Names() .size()     ; for (int LoopNumber=1; LoopNumber <= Max_Value ; LoopNumber++) { int EachItem = LoopNumber - 1; 
                                            named_values_stream << setw(15) << input_.Names().at(EachItem) << " : " << input_.NamedValues().at(EachItem) << '\n';
                                        } } 
                                        
                                        return 
                                            "Vector\n" + 
                                                VisualFormat(input_.Vector())+ 
                                            "Named Values\n"+ 
                                                Indent(named_values_stream.str());
                                    }
                                // just output vector 
                                else if ( input_.Vector().size() >= 1 ) 
                                    {
                                        return "List\n" + VisualFormat(input_.Vector());
                                    }
                                // just output named values 
                                else if ( input_.Names().size() >= 1 )
                                    {
                                        stringstream output_stream;
                                        { int Max_Value =  input_.Names() .size()     ; for (int LoopNumber=1; LoopNumber <= Max_Value ; LoopNumber++) { int EachItem = LoopNumber - 1; 
                                            output_stream << setw(15) << input_.Names().at(EachItem) << " : " << input_.Vector().at(EachItem) << '\n';
                                        } } 
                                        return "List\n" + Indent(output_stream.str());
                                    }
                                else 
                                    // output *NOTHING*  
                                    return "*NOTHING*\n";
                            }     
                // << >>       
                    template <typename ITEM> ostream& operator<<(ostream& out, const List<ITEM>& input_)
                        {
                            return out << VisualFormat(input_);
                        } 
                    template <typename ITEM> istream& operator>>(istream& in_,        List<ITEM>& input_)
                        {
                            return input(in_, input_);
                        }





    // make it so that List is List<Item>
    #define List List<Item>
    // name some other names for items 
    #define var Item






    // 
    //  Item
    // 

    class  Item 
        {
            // data
                string data; // later turn both of these into some kind of binary
                string type; 

        public:

            // constructors   
                    explicit Item (                       ) { data =  "Nothing"      ; type = "Nothing";}
                    explicit Item ( char   input_string[] ) { data =  input_string   ; type = "string" ;}
                    explicit Item ( string input_string   ) { data =  input_string   ; type = "string" ;}
                    explicit Item ( double input_         ) 
                        { 
                            stringstream input_method;
                            // precision should max out before 20
                            input_method << setprecision(20) << input_ ;
                            data = input_method.str(); 
                            type = "number" ;
                        }
                    template<class ANYTYPE> explicit Item ( ANYTYPE input )
                            { 
                                stringstream data_stream;
                                output(data_stream, input);
                                // get the name
                                type = EverythingUpTo('\n', data_stream);
                                type = type.substr(0,type.size()-1);
                                // get the content
                                string content = Input_Unindent(data_stream);
                                // remove the closing newline
                                content = content.substr(0,content.size()-1);
                                data = content;
                                if (type == "double" || type == "integer")
                                    type = "number"; 
                            }
            // methods        
                    string Type()        const { return type ; }
                    string Data()        const { return data ; }
                    string Remove0s   () const      
                        {
                            if ( stoi(data) == stold(data) ) {
                                return to_string(stoi(data));
                            } else {
                                //FIXME, change this to remove trailing 0's 
                                return data;
                            }  
                        } 
                    istream& Input  (istream& in_)
                        {
                            // check name of type 
                            if ( EverythingUpTo('\n',in_) != "Item\n")
                                return StreamFailed(in_);
                            
                      
                                    // unindent members
                                    string content = Input_Unindent(in_);
                                    // check fail
                                    if (content == "")
                                        return StreamFailed(in_);
                                    // check end 
                                    if (content[content.size()-1] != '\n')
                                        return StreamFailed(in_);
                                    // setup vars
                                    char should_always_be_a_newline;
                                    stringstream transfer_method;
                                    // get rid of the class's newline
                                    transfer_method << content.substr(0,content.size()-1);
                                
                        
                            // create empty versions of all data members 
                            input( transfer_method, data ); transfer_method.get(should_always_be_a_newline);
                            input( transfer_method, type ); transfer_method.get(should_always_be_a_newline);
                            
                      
                                    // if stream fails, then return fail 
                                    if (DidStreamFail(transfer_method))
                                        return StreamFailed(in_);
                                
                     
                            
                            // check the data, make sure its valid 
                            // FIXME, do this later
                            //if ( !IsDataValid(datamember)) 
                            //    return StreamFailed(in_);
                      
                        
                        
                                    // if everything worked return the stream! 
                                    return in_;
                        }  
            // operators      
                // =      
                    Item& operator=( const Item&  input_item    ) { data = input_item.Data()         ; type = input_item.Type(); return *this; }
                    Item& operator=( const char   input_string[]) { data = input_string              ; type = "string"         ; return *this; }
                    Item& operator=( const string input_string  ) { data = input_string              ; type = "string"         ; return *this; }
                    Item& operator=( const int    the_inputeger ) { data = to_string(the_inputeger)  ; type = "number"         ; return *this; }
                    Item& operator=( const float  input_        ) 
                        { 
                            stringstream input_method;
                            // precision should max out before 20
                            input_method << setprecision(20) << input_ ;
                            data = input_method.str(); 
                            type = "number"; 
                            return *this; 
                        }
                    Item& operator=( const double input_        ) 
                        { 
                            stringstream input_method;
                            // precision should max out before 20
                            input_method << setprecision(20) << input_ ;
                            data = input_method.str();
                            type = "number"; 
                            return *this; 
                        }
                    template<class ANYTYPE> Item& operator=( ANYTYPE input_ ) 
                        { 
                            stringstream data_stream;
                            data_stream << input_;
                            data = data_stream.str();
                            type = "Unknown";
                            return *this; 
                        }
                // implicit conversion 
                    operator string() const 
                        {
                                return data;
                        }
                    operator double() const 
                        {
                            if ( type == "number" ) {
                                return stold(data);
                            } else {
                                Error("Somewhere there is an item thats not a number,\nand something is trying to make it a double\nthe item is "+data);
                            }  
                        } 
                        
        };
        // IO
            ostream& output (ostream& out, const Item& input_)
                {
                    // name of class 
                    out << "Item" << '\n';
                    
                            stringstream data_members;
                            
                    // for each datamember
                    output( data_members , input_.Data()); data_members << '\n';
                    output( data_members , input_.Type()); data_members << '\n';

                            // format and return stream
                            out << Indent( data_members.str() );
                            return out;
                }
            istream& input  (istream& in_,        Item& input_)
                {
                    return input_.Input(in_);
                }  
            string   AsData (const Item& input_)
                {
                    stringstream out;
                    // name of class 
                    out << input_.Type() << '\n';
                    
                    stringstream data_members;
                            
                    // for each datamember
                    data_members << input_.Data() << '\n';

                    // format and return stream
                    out << Indent( data_members.str() );
                    return out.str();
                }
        // overloads
                // >>   
                    ostream& operator<<(ostream& out, const Item& input_)
                        {
                            // number
                            if (input_.Type() == "number")
                                return out << stold(input_.Data());
                            // list 
                            if (input_.Type() == "List")
                                {
                                    // create a blank list 
                                    List blank_list;
                                    // put the data into a stream
                                    stringstream data_stream;
                                    data_stream << AsData(input_);
                                    char should_always_be_a_newline;
                                    // populate the list 
                                    input(data_stream, blank_list);
                                    // output list using it's own stream operator
                                    return out << blank_list;
                                }
                            return out << input_.Data();
                        }
                    istream& operator>>(istream& in_,        Item& input_)
                        {
                            return input(in_,input_);
                        }
                    // what to do about lists, bool's, Grids
                // +
                    Item  operator+( const string&  base   , const int&   repetitions  )
                        {
                            string result;
                            for (int i = 0; i < repetitions; i++)
                                result += base;
                            return Item(result);
                        }
                    Item  operator+( const char     the_input[] , const Item&   input_item  )
                        {
                            if ( input_item.Type() == "string" ) { 
                                return Item(input_item.Data() + the_input);
                            } else { 
                                Error("Trying to add a non-string Item: "+input_item.Data()+" to a string: " + the_input);
                            } 
                        }                 
                    Item  operator+( const int&     the_input   , const Item&   input_item  )
                        { 
                            if (input_item.Type() == "number")
                                return  Item(Item(stod(input_item.Data()) + the_input));
                            else
                                Error("Trying to add an int: "+to_string(input_item)+ " to non-number Item "+ input_item.Data());
                        }
                    Item  operator+( const double&  the_input   , const Item&   input_item  )
                        { 
                            if (input_item.Type() == "number")
                                return  Item(Item(stod(input_item.Data()) + the_input));
                            else
                                Error("Trying to add a double: "+to_string(input_item)+ " to non-number Item "+ input_item.Data());
                        }
                    Item  operator+( const string&  the_input   , const Item&   input_item  )
                        { 
                                if ( input_item.Type() == "number" ) {
                                    return  Item(the_input + input_item.Remove0s());
                                } else { 
                                    return Item(the_input + input_item.Data());
                                }  
                        } 
                    Item  operator+( const Item&    input_item  , const char    the_input[] )
                        {
                            if ( input_item.Type() == "string" ) { 
                                return Item(input_item.Data() + the_input);
                            } else { 
                                Error("Trying to add a non-string Item: "+input_item.Data()+" to a string: " + the_input);
                            } 
                        }
                    Item  operator+( const Item&    input_item  , const int&    the_input   )
                        { 
                            if (input_item.Type() == "number")
                                return Item(stod(input_item.Data()) + the_input);
                            else
                                Error("Trying to add an int: "+to_string(input_item)+ " to a non-number Item "+ input_item.Data());
                        }
                    Item  operator+( const Item&    input_item  , const double& the_input   )
                        { 
                            if (input_item.Type() == "number")
                                return Item(stod(input_item.Data()) + the_input);
                            else
                                Error("Trying to add a double: "+to_string(input_item)+ " to a non-number Item "+ input_item.Data());
                        }
                    Item  operator+( const Item&    input_item  , const string& the_input   )
                        { 
                                if ( input_item.Type() == "number" ) {
                                    return Item(input_item.Remove0s() + the_input);
                                } else { 
                                    return Item(input_item.Data() + the_input);
                                }  
                        } 
                    Item  operator+( const Item&    input_item1 , const Item&   input_item2 )
                        {
                            if ( input_item1.Type() == "number" && input_item2.Type() == "number" ) {
                                return Item(stold(input_item1.Data()) + stold(input_item2.Data()));
                            } else {
                                return Item(input_item1.Data() + input_item2.Data());
                            }  
                        }
                // -    
                    Item  operator-( const int&     the_input   , const Item&   input_item  )
                        { 
                            if (input_item.Type() == "number")
                                return  Item( the_input - stod(input_item.Data()));
                            else
                                Error("Trying to subtract an int: "+to_string(input_item)+ " from a non-number Item "+ input_item.Data());
                        }
                    Item  operator-( const double&  the_input   , const Item&   input_item  )
                        { 
                            if (input_item.Type() == "number")
                                return  Item(the_input - stod(input_item.Data()));
                            else
                                Error("Trying to subtract a double: "+to_string(input_item)+ " from a non-number Item "+ input_item.Data());
                        }
                    Item  operator-( const Item&    input_item  , const int&    the_input   )
                        { 
                            if (input_item.Type() == "number")
                                return  Item(stod(input_item.Data()) - the_input);
                            else
                                Error("Trying to subtract a non-number Item: "+input_item.Data()+ " from an int: "+to_string(input_item));
                        }
                    Item  operator-( const Item&    input_item  , const double& the_input   )
                        { 
                            if (input_item.Type() == "number")
                                return  Item(the_input - stod(input_item.Data()));
                            else
                                Error("Trying to subtract a non-number Item: "+input_item.Data()+ " from a double "+to_string(input_item));
                        }
                    Item  operator-( const Item&    input_item1 , const Item&   input_item2 )
                        {
                            if ( input_item1.Type() == "number" && input_item2.Type() == "number" ) {
                                return  Item( Item(stold(input_item1.Data()) - stold(input_item2.Data())));
                            } else {
                                Error(string("I think somewhere in_ the code there is one item subtracting another")
                                    +"\nbut they are not both numbers"
                                    +"\nthe items are "
                                    +input_item1.Data()
                                    +" and "
                                    +input_item2.Data()
                                    +"\n");
                            }  
                        }
                // *
                    Item  operator*( const string&  the_input   , const Item&   input_item  )
                        { 
                            if ( input_item.Type() == "string"  ) { 
                                Error("Somewhere there is a string Item: "+input_item.Data()+" being multipled by a string");
                            } else if (  input_item.Type() == "number"  ) { 
                                int number_ = stoi(input_item.Data());
                                if ( number_ == 0 ) { 
                                    return  Item(string(""));
                                } else if ( number_ > 0 ) { 
                                    string output_string; 
                                    { int Max_Value =  number_     ; for (int LoopNumber=1; LoopNumber <= Max_Value ; LoopNumber++) { 
                                        output_string = output_string + the_input;
                                     } } 
                                    return Item(output_string);
                                } else { 
                                    Error("Somewhere there is a string be multipled by a negative Item");
                                }  
                            } 
                        }  
                    Item  operator*( const int&     the_input   , const Item&   input_item  )
                        { 
                            if ( input_item.Type() == "string"  ) { 
                                int number_ = static_cast<int>(  the_input  );
                                if ( number_ == 0 ) { 
                                    return  Item(string(""));
                                } else if ( number_ > 0 ) { 
                                    string output_string; 
                                    { int Max_Value =  number_     ; for (int LoopNumber=1; LoopNumber <= Max_Value ; LoopNumber++) { 
                                        output_string = output_string + input_item.Data();
                                     } } 
                                    return Item(output_string);
                                } else { 
                                    Error("Somewhere there is a string be multipled by a negative Item");
                                }  
                            } else if (  input_item.Type() == "number"  ) { 
                                return Item(the_input + stold(input_item.Data()));
                            } 
                        }  
                    Item  operator*( const double&  the_input   , const Item&   input_item  )
                        { 
                            if ( input_item.Type() == "string"  ) { 
                                int number_ = static_cast<int>(  the_input  );
                                if ( number_ == 0 ) { 
                                    return  Item(string(""));
                                } else if ( number_ > 0 ) { 
                                    string output_string; 
                                    { int Max_Value =  number_     ; for (int LoopNumber=1; LoopNumber <= Max_Value ; LoopNumber++) { 
                                        output_string = output_string + input_item.Data();
                                     } } 
                                    return Item(output_string);
                                } else { 
                                    Error("Somewhere there is a string be multipled by a negative Item");
                                }  
                            } else if (  input_item.Type() == "number"  ) { 
                                return Item(the_input + stold(input_item.Data()));
                            } 
                        }  
                    Item  operator*( const char&    the_input   , const Item&   input_item  )
                        {
                            return  Item(AsString(the_input) * input_item);
                        }
                    Item  operator*( const Item&    input_item  , const double& the_input   )
                        { 
                            if ( input_item.Type() == "string"  ) { 
                                int number_ = static_cast<int>(  the_input  );
                                if ( number_ == 0 ) { 
                                    return  Item(string(""));
                                } else if ( number_ > 0 ) { 
                                    string output_string; 
                                    { int Max_Value =  number_     ; for (int LoopNumber=1; LoopNumber <= Max_Value ; LoopNumber++) { 
                                        output_string = output_string + input_item.Data();
                                     } } 
                                    return Item(output_string);
                                } else { 
                                    Error("Somewhere there is a string be multipled by a negative Item");
                                }  
                            } else if (  input_item.Type() == "number"  ) { 
                                return Item(the_input + stold(input_item.Data()));
                            } 
                        }                  
                    Item  operator*( const Item&    input_item  , const int&    the_input   )
                        { 
                            if ( input_item.Type() == "string"  ) { 
                                int number_ = static_cast<int>(  the_input  );
                                if ( number_ == 0 ) { 
                                    return  Item(string(""));
                                } else if ( number_ > 0 ) { 
                                    string output_string; 
                                    { int Max_Value =  number_     ; for (int LoopNumber=1; LoopNumber <= Max_Value ; LoopNumber++) { 
                                        output_string = output_string + input_item.Data();
                                     } } 
                                    return Item(output_string);
                                } else { 
                                    Error("Somewhere there is a string be multipled by a negative Item");
                                }  
                            } else if (  input_item.Type() == "number"  ) { 
                                return Item(the_input + stold(input_item.Data()));
                            } 
                        }  
                    Item  operator*( const Item&    input_item  , const string& the_input   )
                        { 
                            if ( input_item.Type() == "string"  ) { 
                                Error("Somewhere there is a string Item being multipled by a string");
                            } else if (  input_item.Type() == "number"  ) { 
                                int number_ = stoi(input_item.Data());
                                if ( number_ == 0 ) { 
                                    return  Item(string(""));
                                } else if ( number_ > 0 ) { 
                                    string output_string; 
                                    { int Max_Value =  number_     ; for (int LoopNumber=1; LoopNumber <= Max_Value ; LoopNumber++) { 
                                        output_string = output_string + the_input;
                                     } } 
                                    return Item(output_string);
                                } else { 
                                    Error("Somewhere there is a string be multipled by a negative Item");
                                }  
                            } 
                        }  
                    Item  operator*( const Item&    input_item  , const char&   the_input   )
                        {
                            return  Item(input_item * AsString(the_input) );
                        }
                    Item  operator*( const Item&    input_item1 , const Item&   input_item2 )
                        {
                            if ( ( input_item1.Type() == "string" && input_item2.Type() == "number" ) ) { 
                                return  Item(input_item1 * stod(input_item2.Data()));

                            } else if (( input_item1.Type() == "number" && input_item2.Type() == "string" )
                                ) {
                                    return Item(stod(input_item1.Data()) * input_item2);
                            } else if (( input_item1.Type() == "number" && input_item2.Type() == "number" )
                                ) {
                                    return Item(stod(input_item1.Data()) * stod(input_item2.Data()));
                            } else {
                                Error(string("I think somewhere in_ the code there is one item multipling another")
                                    +"\nbut neither of them are numbers"
                                    +"\nthe items are "
                                    +input_item1.Data() + " type: " + input_item1.Type()
                                    +" and "
                                    +input_item2.Data() + " type: " + input_item2.Type()
                                    +"\n");
                            }  
                        }
                // /    
                    Item  operator/( const Item&    input_item  , const int&    the_input   )
                        { 
                            if ( input_item.Type() == "number"  ) { 
                                if ( the_input ==0 ) { 
                                    Error("Division by 0 somewhere");
                                } 
                                return  Item((long double)(stold( input_item.Data() ) / the_input));
                            } else { 
                                Error("Trying to divide something from an item thats not a number");
                            } 
                        }
                    Item  operator/( const Item&    input_item  , const float&  the_input   )
                        { 
                            if ( input_item.Type() == "number"  ) { 
                                return  Item(stold( input_item.Data() ) / the_input);
                            } else { 
                                Error("Trying to divide something from an item thats not a number");
                            } 
                        }
                    Item  operator/( const Item&    input_item  , const double& the_input   )
                        { 
                            if ( input_item.Type() == "number"  ) { 
                                return  Item(stold( input_item.Data() ) / the_input);
                            } else { 
                                Error("Trying to divide something from an item thats not a number");
                            } 
                        }
                    Item  operator/( const int&     the_input   , const Item&   input_item  )
                        { 
                            if ( input_item.Type() == "int" ) { 
                                if ( stoi( input_item.Data() ) == 0 ) { 
                                    Error("Division by 0 somewhere");
                                } else {
                                    return  Item( the_input / stold( input_item.Data() ));
                                }  
                            
                            } else if ( input_item.Type() == "double" ) {
                                if (     stod( input_item.Data() ) <  0.00000000001 
                                    && stod( input_item.Data() ) > -0.00000000001 
                                ) { 
                                    Error("Division by 0 somewhere");
                                } else {
                                    return Item(the_input / stold( input_item.Data() ));
                                }  

                            } else if ( input_item.Type() == "float"  ) { 
                                if (     stof( input_item.Data() ) <  0.00001 
                                    && stof( input_item.Data() ) > -0.00001 
                                ) { 
                                    Error("Division by 0 somewhere");
                                } else {
                                    return Item(the_input / stold( input_item.Data() ));
                                }  
                            } else { 
                                Error("Trying to divide something from an item thats not a number");
                            } 
                        }
                    Item  operator/( const float&   the_input   , const Item&   input_item  )
                        { 
                            if ( input_item.Type() == "int" ) { 
                                if ( stoi( input_item.Data() ) == 0 ) { 
                                    Error("Division by 0 somewhere");
                                } else {
                                    return  Item( the_input / stold( input_item.Data() ));
                                }  
                            
                            } else if ( input_item.Type() == "double" ) {
                                if (     stod( input_item.Data() ) <  0.00000000001 
                                    && stod( input_item.Data() ) > -0.00000000001 
                                ) { 
                                    Error("Division by 0 somewhere");
                                } else {
                                    return Item(the_input / stold( input_item.Data() ));
                                }  

                            } else if ( input_item.Type() == "float"  ) { 
                                if (     stof( input_item.Data() ) <  0.00001 
                                    && stof( input_item.Data() ) > -0.00001 
                                ) { 
                                    Error("Division by 0 somewhere");
                                } else {
                                    return Item(the_input / stold( input_item.Data() ));
                                }  
                            } else { 
                                Error("Trying to divide something from an item thats not a number");
                            } 
                        }
                    Item  operator/( const double&  the_input   , const Item&   input_item  )
                        { 
                            if ( input_item.Type() == "int" ) { 
                                if ( stoi( input_item.Data() ) == 0 ) { 
                                    Error("Division by 0 somewhere");
                                } else {
                                    return  Item( the_input / stold( input_item.Data() ));
                                }  
                            
                            } else if ( input_item.Type() == "double" ) {
                                if (     stod( input_item.Data() ) <  0.00000000001 
                                    && stod( input_item.Data() ) > -0.00000000001 
                                ) { 
                                    Error("Division by 0 somewhere");
                                } else {
                                    return Item(the_input / stold( input_item.Data() ));
                                }  

                            } else if ( input_item.Type() == "float"  ) { 
                                if (     stof( input_item.Data() ) <  0.00001 
                                    && stof( input_item.Data() ) > -0.00001 
                                ) { 
                                    Error("Division by 0 somewhere");
                                } else {
                                    return Item(the_input / stold( input_item.Data() ));
                                }  
                            } else { 
                                Error("Trying to divide something from an item thats not a number");
                            } 
                        }
                    Item  operator/( const Item&    input_item1 , const Item&   input_item2 )
                        {
                            if ( input_item1.Type() == "number" && input_item2.Type() == "number" ) {
                                return  Item(stold(input_item1.Data()) / stold(input_item2.Data()));
                            } else {
                                Error(string("I think somewhere in_ the code there is one item dividing another")
                                    +"\nbut they are not both numbers"
                                    +"\nthe items are "
                                    +input_item1.Data()
                                    +" and "
                                    +input_item2.Data()
                                    +"\n");
                            }  
                        }
                // ^    
                    Item  operator^( const Item&    input_item  , const int&    the_input   )
                        { 
                            if ( input_item.Type() == "number"  ) { 
                                return  Item(pow(  stold( input_item.Data() ) , the_input));
                            } else { 
                                Error("Trying to use an exponent with something from an item thats not a number");
                            } 
                        }
                    Item  operator^( const Item&    input_item  , const float&  the_input   )
                        { 
                            if ( input_item.Type() == "number"  ) { 
                                return  Item(pow(  stold( input_item.Data() ) , the_input));
                            } else { 
                                Error("Trying to use an exponent with something from an item thats not a number");
                            } 
                        }
                    Item  operator^( const Item&    input_item  , const double& the_input   )
                        { 
                            if ( input_item.Type() == "number"  ) { 
                                return  Item(pow(  stold( input_item.Data() ) , the_input));
                            } else { 
                                Error("Trying to use an exponent with something from an item thats not a number");
                            } 
                        }
                    Item  operator^( const int&     the_input   , const Item&   input_item  )
                        { 
                            if ( input_item.Type() == "number"  ) { 
                                return  Item(pow( the_input, stold( input_item.Data() )));
                            } else { 
                                Error("Trying to use an exponent with something from an item thats not a number");
                            } 
                        }
                    Item  operator^( const float&   the_input   , const Item&   input_item  )
                        { 
                            if ( input_item.Type() == "number"  ) { 
                                return  Item(pow( the_input, stold( input_item.Data() )));
                            } else { 
                                Error("Trying to use an exponent with something from an item thats not a number");
                            } 
                        }
                    Item  operator^( const double&  the_input   , const Item&   input_item  )
                        { 
                            if ( input_item.Type() == "number"  ) { 
                                return  Item(pow( the_input, stold( input_item.Data() )));
                            } else { 
                                Error("Trying to use an exponent with something from an item thats not a number");
                            } 
                        }
                    Item  operator^( const Item&    input_item1 , const Item&   input_item2 )
                        {
                            if ( input_item1.Type() == "number" && input_item2.Type() == "number" ) {
                                return  Item(stod(input_item1.Data()) ^ input_item2);
                            } else {
                                Error(string("I think somewhere in_ the code there is one item to the power of another")
                                    +"\nbut they are not both numbers"
                                    +"\nthe items are "
                                    +input_item1.Data()
                                    +" and "
                                    +input_item2.Data()
                                    +"\n");
                            }  
                        }
                //  Function overloads
                    string to_string(const Item& input_item)
                        { 
                            return input_item.Data();
                        } 
                    




    // List
            // helpers 
                template <class ANYTYPE> bool   Is__In__ (ANYTYPE value,   List input_)
                        {
                            Item holder = value;
                            return input_.Has(holder);
                        }



    /**/

    
    

//
// puts, print, and log 
//

    // I made this code based on code from the site below
    // I've had it for a long time and you can find it on my github
    // I like to think I made it more useful, but all originalality 
    // goes to the original author
    // http://wiki.c2.com/?OverloadingCommaOperator

    // puts is the standard way to output things
    #define puts        __PutsOutputFixerStream,
    #define put_lines   __PutLinesOutputFixerStream.reset();__PutLinesOutputFixerStream,
    // and print is puts without a newline
    #define Print       cout,

    // log is an incredibly useful Debugging tool
    string __OUTPUT_INDENT = "";
    bool __INCREASE_INDENT = false;
    #define log                                                                                                                        __LogOutputFixerStream.reset();__LogOutputFixerStream,
    #define log_start          __INCREASE_INDENT = true;                                                                                   __LogOutputFixerStream.reset();__LogOutputFixerStream,
    #define log_end        if (__OUTPUT_INDENT.size() >= 4) { __OUTPUT_INDENT = __OUTPUT_INDENT.substr(0,__OUTPUT_INDENT.size()-4); } ;__LogOutputFixerStream.reset();__LogOutputFixerStream,

    class __PutLinesOutputFixerStreamClass : public stringstream
        {
            protected:
                // data 
                    int length_of_last_line = 0;
                    bool dont_go_up_a_line = true;
                    string what_was_just_output = "";
                    string content = "";
                // class helper functions
                    void go_up_a_line()
                        {
                            cout << "\033[1A";
                        }
                    void go_to_the_right(int number_of_spaces)
                        {
                            cout << "\033["+to_string(number_of_spaces)+"C";
                        }
                    void save_cursor_position()
                        {
                            cout << "\033[s";
                        }
                    void restore_cursor_position()
                        {
                            cout << "\033[u";
                        }
                    int length_of_previous_line()
                        {
                            int charaters_till_newline = 0;
                            { int Max_Value =  what_was_just_output.size() ; for (int LoopNumber=1; LoopNumber <= Max_Value ; LoopNumber++) {
                                if (what_was_just_output[what_was_just_output.size() - LoopNumber] != '\n')
                                    {
                                        charaters_till_newline++;
                                    }
                                else 
                                    {
                                        break;
                                    }
                            } }
                            return charaters_till_newline;
                        }
            public:
                void reset()
                    {
                        length_of_last_line = 0;
                        dont_go_up_a_line = true;
                        what_was_just_output = "";
                    }
                void output_line()
                    {
                        if (dont_go_up_a_line)
                            {
                                save_cursor_position();
                                for (auto each : content)
                                    {
                                        if (each == '\n')
                                            {
                                                cout << __OUTPUT_INDENT;
                                            }
                                        cout << each;
                                    }
                                cout << "\n";
                                __INCREASE_INDENT = false;
                                dont_go_up_a_line = false;
                            }
                        else
                            {
                                go_up_a_line();
                                length_of_last_line += length_of_previous_line();
                                go_to_the_right(length_of_last_line);
                                for (auto each : content)
                                    {
                                        if (each == '\n')
                                            {
                                                cout << __OUTPUT_INDENT;
                                            }
                                        cout << each;
                                    }
                                // FIXME, if the terminal width is really small 
                                // and the string is really long, this might mess things up 
                            }
                        restore_cursor_position();
                    }
                void add_content(string input_)
                    {
                        what_was_just_output = content;
                        content = input_;
                    }
        };
    stringstream __PutsOutputFixerStream;
    __PutLinesOutputFixerStreamClass __PutLinesOutputFixerStream;
    __PutLinesOutputFixerStreamClass __LogOutputFixerStream;
    // for normal input (classes)
    template<class ANYTYPE>
    inline ostream& operator,(ostream& o, const ANYTYPE& value) 
        {
            // if its the puts stream then output each thing with a newline after it
            if (&o == &__PutsOutputFixerStream)
                {
                    // make this threadsafe by only allowing one printout at a time
                    pthread_mutex_lock(&mutex_for_output);
                    // put the value into the string stream 
                    stringstream converter_to_string;
                    converter_to_string << value;
                    // get the output as a string
                    string content_being_output = converter_to_string.str();
                    // insert the indent at the begining
                    cout << __OUTPUT_INDENT;
                    // insert the indent after every newline in the content
                    for (auto each_char : content_being_output)
                        {
                            if (each_char == '\n')
                                {
                                    cout << __OUTPUT_INDENT;
                                }
                            cout << each_char;
                        }
                    // send a newline at the end
                    cout << "\n";
                    // unlock the mutex to allow other threads to print things out;
                    pthread_mutex_unlock(&mutex_for_output);
                }
            // if its the __PutLinesOutputFixerStream, then use __PutLinesOutputFixerStream to output
            else if (&o == &__PutLinesOutputFixerStream)
                {
                    // erase the string-stream part of __PutLinesOutputFixerStream
                    __PutLinesOutputFixerStream.str("");
                    // add the line to __PutLinesOutputFixerStream
                    stringstream out_stream;
                    out_stream << value;
                    __PutLinesOutputFixerStream.add_content(__OUTPUT_INDENT + out_stream.str());
                    // output the line 
                    __PutLinesOutputFixerStream.output_line();
                }
            // if its the Debugging_stream
            else if (&o == &__LogOutputFixerStream)
                {
                    // erase the string-stream part of __PutLinesOutputFixerStream
                    __LogOutputFixerStream.str("");

                    // check if Debugging is on 
                    if (Debugging == true)
                        {
                            // add the line to __LogOutputFixerStream
                            stringstream out_stream;
                            out_stream << value;
                            if (__INCREASE_INDENT == true)
                                {
                                    __LogOutputFixerStream.add_content(__OUTPUT_INDENT + out_stream.str());
                                    __OUTPUT_INDENT += "    ";
                                }
                            else 
                                {
                                    __LogOutputFixerStream.add_content(__OUTPUT_INDENT + out_stream.str());
                                }
                            // output the line 
                            __LogOutputFixerStream.output_line();
                        }
                    else 
                        {
                            // dont output anything 
                            o << "";
                        }
                } // end if debugging
            // if it's some other stream
            else
                {
                    // then just keep going like normal
                    stringstream out_stream;
                    out_stream << value;
                    o << out_stream.str();
                }
            return o;
        }
    // for stream operators (fixed, setprecision(), etc)
    inline ostream& operator,(ostream& o, ostream& (*manip_fun)(ostream&)) 
        {
            // if its from print, then use then send it to cout directly 
            if (&o == &__PutLinesOutputFixerStream)
                {
                    cout << manip_fun;
                }
            else if (&o == &__LogOutputFixerStream)
                {
                    if (Debugging == true)
                        {
                            cout << manip_fun;
                        }
                }
            // if it's some other stream
            else
                {
                    // then just keep going like normal
                    o << manip_fun;
                }
            return o;
        }



#endif 