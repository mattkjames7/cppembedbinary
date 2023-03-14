#include <iostream>
#include <fstream>

int main() {

    /* write a small array of integers to the file */

    /* create the array */
    int n = 6;
    int data[] = {1, 4, 9, 16, 25, 36};

    /* open the file */
    std::ofstream binfile;
    binfile.open("data.bin",std::ios::out | std::ios::binary);
    if (!binfile.is_open()) {
        std::cout << "Unable to save data.bin" << std::endl;
        return 1;
    }

    /* write to the file */
    binfile.write((char *) &n,sizeof(int));
    binfile.write((char *) data,sizeof(int)*n);

    /* close the file */
    binfile.close();

    std::cout << "Saved data.bin" << std::endl;


}

