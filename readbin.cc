#include <iostream>
#include <fstream>

extern unsigned char _binary_data_bin_start[];
extern unsigned char _binary_data_bin_size;
extern unsigned char _binary_data_bin_end[];

int main() {

    /* create a pointer which we will use to read the data*/
    unsigned char *p;

    /* here we want to create the variables to store the data*/
    int n, *dat;

    /* read in the number of  elements, then advance the pointer*/
    p = _binary_data_bin_start;
    n = ((int*) p)[0];
    p += sizeof(int);

    /* allocate data array */
    dat = new int[n];

    /* loop to read the elements of data in */
    int i;
    for (i=0;i<n;i++) {
        dat[i] = ((int*) p)[0];
        p += sizeof(int);
    }

    /* print the output */
    std::cout << "Printing data stored in memory" << std::endl;
    for (i=0;i<n;i++) {
        std::cout << i << ": " << dat[i] << std::endl;
    }

    delete[] dat;
}

