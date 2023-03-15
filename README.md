# cppembedbinary
C++ code to demonstrate how binary data can be embedded into a C++ executable or library.

## Building

Clone the repo:
```bash
git clone https://github.com/mattkjames7/cppembedbinary.git
cd cppembedbinary
```

Running this code requires the `g++` and `make` commands. Under Windows and Linux the `ld` command is used for converting the binary into object code, in MacOS the `xxd` command is used instead. 

Build the code (this will also run some code)
```bash
make

#OR if using mingw
mingw32-make
```

In Windows `g++` may be provided by either [TDM-GCC](https://jmeubank.github.io/tdm-gcc/) or [Mingw-w64](https://www.mingw-w64.org/) and `make` can be provided by either [GNU Win 32](https://gnuwin32.sourceforge.net/packages/make.htm) or as `mingw32-make` by Mingw-w64. You will need to add the paths to the binaries provided by these packages to the `%PATH%` environment variable.

## How it should work

Firstly, the code in `readbin.cc` will write to a simple binary file called `data.bin`. The first four bytes of this file will contain a 32-bit integer denoting the length of an array stored immediately after, in this case it will be 6 (elements). The array stored directly afterwards is a 6 element array of 32-bit integers:
```cpp
int data[] = {1, 4, 9, 16, 25, 36};
```
which brings the total length of the file to 28 bytes.

Next, `data.bin` is converted to object code in one of two ways:
- Method 1 uses `ld` in Linux or Windows to convert it to object code `data.o`:
    ```bash
    ld -r -b binary data.bin -o data.o
    ```
    which contains the following symbols:
    ```bash
    nm -l data.o
    000000000000001c D _binary_data_bin_end
    000000000000001c A _binary_data_bin_size
    0000000000000000 D _binary_data_bin_start
    ```
- Method 2 uses `xxd` in MacOS (this will also work in Linux and may be possible in Windows too) to create data.o
    Firstly it is converted to c code
    ```bash
    xxd -i data.bin > data.cc
    ```
    which contains the following code
    ```cpp
    unsigned char data_bin[] = {
    0x06, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00,
    0x09, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0x19, 0x00, 0x00, 0x00,
    0x24, 0x00, 0x00, 0x00
    };
    unsigned int data_bin_len = 28;
    ```

    `data.cc` is then compiled to create `data.o` with similar looking symbols to Method 1:
    ```bash
    g++ -c data.cc -o data.o
    nm -l data.o
    0000000000000000 D data_bin
    000000000000001c D data_bin_len
    ```

Finally, the resulting binary blob (`data.o`) can be compiled into code which will try to read it:
```bash
g++ readbin.cc data.o -o readbin
```
This code requires the definition of the start of the data array within the code
```cpp
\* for method 1 *\
extern unsigned char *_binary_data_bin_start;

\* or method 2 *\
extern unsigned char *data_bin;
```
In the example code provided, I have assigned the pointer `unsigned char data_start` to point at whichever of the above two symbols are created during compilation, so if we used method 1 (`ld`) then `data_start = _binary_data_bin_start` or method 2 (`xxd`) then `data_start = data_bin`.

Extracting the data is done by casting value which the pointer addresses to whatever data type is required (`int` in this case), assigns it to a stack variable then moves the pointer along in memory by the size of that data type. 

Extracting the first integer (length of the array):
```cpp
/* point to the memory address of the start of the data */
unsigned char *p = data_start;

/* there is probably a more elegant way of doing this bit
 * but is casts pointer p as an integer pointer, then assigns
 * the value from that address to an integer variable*/
int n = ((int*) p)[0];

/* now move the pointer along by 4 bytes (for a 32-bit integer) */
p += sizeof(int);
```

Once the example code has found the length of the array, the array itself can be read in to another variable:
```cpp
/* allocate data array */
dat = new int[n];

/* loop to read the elements of data in */
int i;
for (i=0;i<n;i++) {
    dat[i] = ((int*) p)[0];
    p += sizeof(int);
}

```
The above example reads one element at a time, then moves the pointer along each iteration. An alternative would be to treat the pointer as an array, then move the pointer along after the loop, e.g.:
```cpp
/* loop to read the elements of data in */
int i;
for (i=0;i<n;i++) {
    dat[i] = ((int*) p)[i];
}
p += sizeof(int)*n;

```
## References

For the `ld` method of embedding the binary data, this site was particularly helpful: [http://gareus.org/wiki/embedding_resources_in_executables](http://gareus.org/wiki/embedding_resources_in_executables)

Annoyingly `ld` in MacOS doesn't allow that, so I found the `xxd` method from here: [https://stackoverflow.com/a/21605198](https://stackoverflow.com/a/21605198)


