#include <stdio.h>
#include "npy.hpp"

using namespace std;

//Print matrix A(nr_rows_A, nr_cols_A) storage in column-major format
void print_matrix(const float *A, int nr_rows_A, int nr_cols_A) {
  for(int i = 0; i < nr_rows_A; ++i){
    for(int j = 0; j < nr_cols_A; ++j){
      cout << A[j * nr_rows_A + i] << " ";
    }
    cout << endl;
  }
  cout << endl;
}

__global__ void compute_distance_matrix(vector<vector<double>> & reference_points, vector<vector<double>> & query_points) {

}

void cuda_knn_search(vector<vector<double>> & reference_points, vector<vector<double>> & query_points) {
  
}

vector<vector<double>> read_points(const string filename) {

  bool fortran_order = false;
  vector<unsigned long> shape;
  vector<double> data_buffer;
  vector<vector<double>> data;
  shape.clear();
  data_buffer.clear();

  cout << "Reading point data from " << filename << endl;
  npy::LoadArrayFromNumpy(filename, shape, fortran_order, data_buffer);
  if (shape.size() != 2) {
    throw runtime_error("Dimension mismatch. Expected two-dimensional array.");
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

  return data;
}

int main(int argc, char **argv) {

  // parse input file name and read the input file
  if (argc < 3) {
      cout << "Expected two arguments, one for the reference point data and one for the query points." << endl;
      return -1;
  }

  // do the reading
  vector<vector<double>> reference_points = read_points(argv[1]);
  vector<vector<double>> query_points = read_points(argv[2]);

  // prepare datatypes for matrix multiplication
  int rowsR = reference_points.size();
  int colsQ = query_points.size();
  int dims = reference_points[0].size();

  float *h_R = (float *)malloc(rowsR * dims * sizeof(float));
  float *h_Q = (float *)malloc(dims * colsQ * sizeof(float));
  float *h_D = (float *)malloc(rowsR * colsQ * sizeof(float));

  // allocate the arrays on the GPU
  float *d_R, *d_Q, *d_D;
  cudaMalloc(&d_R, rowsR * dims * sizeof(float));
  cudaMalloc(&d_Q, dims * colsQ * sizeof(float));
  cudaMalloc(&d_D, rowsR * colsQ * sizeof(float));

  // free GPU memory
  cudaFree(d_R);
  cudaFree(d_Q);
  cudaFree(d_D);

  // free CPU memory
  free(h_R);
  free(h_Q);
  free(h_D);
  
  return 0;
}