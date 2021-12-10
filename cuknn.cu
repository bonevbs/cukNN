#include <stdio.h>
#include "npy.hpp"

using namespace std;


int main(int argc, char **argv) {

  // parse input file name and read the input file
  if (argc < 2) {
      cout << "Expected a file to read from." << endl;
      return -1;
  }

  string filename = argv[1];
  bool fortran_order = false;

  vector<unsigned long> shape;
  vector<double> data;
  shape.clear();
  data.clear();
  npy::LoadArrayFromNumpy(filename, shape, fortran_order, data);

  return 0;
}
