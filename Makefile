all: main.x

main.x: cuknn.cu
	nvcc -std=c++11 -lineinfo -Xcompiler -fopenmp $^ -o $@ 

clean:
	rm *.x
