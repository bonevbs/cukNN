#include <stdio.h>
#include "npy.hpp"

using namespace std;

void print_data(vector<vector<double>> & data) {
  for (auto row : data) {
    for (auto pos : row) {
      cout << pos << " ";
    }
    cout << endl;
  }
}

int main(int argc, char **argv) {

  // parse input file name and read the input file
  if (argc < 3) {
      cout << "Expected tw oarguments, one for the point data and one for the labels." << endl;
      return -1;
  }

  // prepare the data buffer
  string filename = argv[1];
  bool fortran_order = false;
  vector<unsigned long> shape;
  vector<double> data_buffer;
  vector<vector<double>> data;
  vector<long int> labels;
  shape.clear();
  data_buffer.clear();

  cout << "Reading point data from " << filename << endl;
  npy::LoadArrayFromNumpy(filename, shape, fortran_order, data_buffer);
  if (shape.size() != 2) {
    cout << "Expected two-dimensional array." << endl;
    return -1;
  }
  cout << "Point data has dimensions: " << shape[0] << ", " << shape[1] << endl;

  // reshape the array anbd copy it to data
  for (size_t i = 0; i < shape[0]; i++) {
    vector<double> point(shape[1]);
    for (size_t j = 0; j < shape[1]; j++) {
      point[j] = data_buffer[i*shape[1] + j];
    }
    data.push_back(point);
  }

  // read the label file
  shape.clear();
  labels.clear();
  data_buffer.clear();

  filename = (string)argv[2];
  cout << "Reading label data from " << filename << endl;
  npy::LoadArrayFromNumpy(filename, shape, fortran_order, labels);
  if (labels.size() != data.size()) {
    cout << "label array length and data array length do not align. Check your data!" << endl;
    return -1;
  }
  cout << "Label data has dimensions: " << shape[0] << endl;

  return 0;
}