// .h file with C++ syntax highlighting
#ifdef USE_IN_HLSL
cbuffer  testCB
#else
struct testCB
#endif   // <= this #endif is highlighted white although its valid
{
  float Brightness;
  // ...
};
// the .h file with this struct definition can be used in HLSL and in C++ code 
// this way