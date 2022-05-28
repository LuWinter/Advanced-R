#include <Rcpp.h>
#include <vector>
#include <string>
using namespace Rcpp;
using namespace std;


// [[Rcpp::export]]
bool rcpp_string_include(CharacterVector v, CharacterVector w) {
    string short_str(v[0]);
    string full_str(w[0]);
    
    int len = short_str.length();
    int i = 0;
    
    while (i < len) {
      // assert ((short_str[i] & 0xF8) <= 0xF0);
      int next = 1;
      if ((short_str[i] & 0x80) == 0x00) {
          // one byte
          next = 1;
      } else if ((short_str[i] & 0xE0) == 0xC0) {
          // two bytes
          next = 2;
      } else if ((short_str[i] & 0xF0) == 0xE0) {
          // three bytes
          next = 3;
      } else if ((short_str[i] & 0xF8) == 0xF0) {
          // four bytes
          next = 4;
      }
      string current(short_str.substr(i, next));
      if (full_str.find(current) == string::npos)
          return false;
      i += next;
    }
    return true;
}



/*** R
rcpp_string_include("apple", "banana")
*/
