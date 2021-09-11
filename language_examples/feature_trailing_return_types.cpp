#include <vector>
#include <iostream>
#include <math.h>
#include <map>



// 
// helpers
// 
using namespace std;
#define Loop_           { int Start_Value = 1; int End_Value = 
#define LoopFrom_       { int Start_Value = 
#define _To_            ; int End_Value = 
#define _Times          ; for (int LoopNumber = Start_Value; LoopNumber <= End_Value ; LoopNumber++) {
#define Loop            { while (true){
#define EndLoop         }}
#define Pair(a,b) std::pair<decltype(a), decltype(b)>(a,b)
bool EndOfStream( istream& input_stream ) {
    if (input_stream.eof())
        return true;
    return false;
}


// 
// actual code
// 
#define MAX_N_SIZE 1000

short n;
// a cache of outputs (dynamic programming)
float cache[MAX_N_SIZE][MAX_N_SIZE] = {0};

double U(int r, int s) {
    double itemIndex = r;
    double itemRelativeRank = s;
    double totalNumberOfItems = n;
    
    double nextItemIndex = itemIndex + 1;
    double numberOfRemainingItems = totalNumberOfItems - itemIndex;
    double probabilityOfBeingBetterThanCurrentItem = (itemRelativeRank / nextItemIndex);
    double numberOfSeenItemsThatAreBetterThanCurrentItem = itemRelativeRank - 0;
    
    double expectedAverageRank = numberOfRemainingItems * probabilityOfBeingBetterThanCurrentItem + numberOfSeenItemsThatAreBetterThanCurrentItem;
    // edge case of starting item
    if (expectedAverageRank == 0 ) {
        expectedAverageRank = 1;
    }
    double expectedValue = (totalNumberOfItems + 1) - expectedAverageRank;
    
    return expectedValue;
}

double V(int r, int s) {
    // definitions
    double itemIndex = r;
    double itemRelativeRank = s;
    double totalNumberOfItems = n;
    double nextItemIndex = itemIndex + 1;
    double output = 0, estimatedValueOfAccepting = 0, estimatedValueOfRejecting = 0, sum = 0;
    
    
    // out of bounds = no reward
    if (itemIndex > totalNumberOfItems) {
        output = 0;
        goto output;
    }
    // if the value was cached
    if (cache[r][s] != 0) {
        // return the cached solution
        return cache[r][s];
    }
    
    estimatedValueOfAccepting = U(r, s);
    // last item 
    if (itemIndex == totalNumberOfItems) {
        // must pick the last item
        output = estimatedValueOfAccepting;
        goto output;
    }
    
    // if there is a choice (if there are more items)
    sum = 0;
    LoopFrom_ 1 _To_ nextItemIndex _Times
        sum += V(nextItemIndex, LoopNumber);
    EndLoop
    estimatedValueOfRejecting = sum/nextItemIndex;
    // return whichever is bigger
    output = (estimatedValueOfRejecting > estimatedValueOfAccepting) ? estimatedValueOfRejecting : estimatedValueOfAccepting;
    
    
    output:
    // cache the solution
    cache[r][s] = output;
    return output; 
}


auto main(int argc, char *argv[]) -> int {
    while (not cin.eof()) {
        // reset the cache
        LoopFrom_ 1 _To_ MAX_N_SIZE _Times
            short row = LoopNumber-1;
            LoopFrom_ 1 _To_ MAX_N_SIZE _Times
                short cell = LoopNumber-1;
                cache[row][cell] = 0;
            EndLoop
        EndLoop
        cin >> n;
        cout << V(1,1) << "\n";
    }
}