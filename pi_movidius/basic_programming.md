# Basic Programming on NCS



The following is the example that can

- list the names for all devices plugged into the system
- assign the device what you are desired to use
- try to open and close the deivce



## C++



* c++ file (named `hello_ncs.cpp`)

```c++
#include <stdio.h>
#include <stdlib.h>

// the library to use NCS
#include <mvnc.h>

// somewhat arbitrary buffer size for the device name
#define NAME_SIZE 100

int main(int argc, char** argv)
{
    mvncStatus retCode;
    void *deviceHandle;
    char devName[NAME_SIZE];
    
    // get the device name of the first device which is plugged into the systems
    retCode = mvncGetDeviceName(0, devName, NAME_SIZE);
    if (retCode != MVNC_OK)
    {   // failed to get device name, maybe none plugged in.
        printf("Error - No NCS devices found.\n");
        printf("    mvncStatus value: %d\n", retCode);
        exit(-1);
    }

    // Try to open the NCS device via the device name
    retCode = mvncOpenDevice(devName, &deviceHandle);
    if (retCode != MVNC_OK)
    {   // failed to open the device.  
        printf("Error - Could not open NCS device.\n");
        printf("    mvncStatus value: %d\n", retCode);
        exit(-1);
    }

    // deviceHandle is ready to use now.  
    // Pass it to other NC API calls as needed and close it when finished.
    printf("Hello NCS! Device opened normally.\n");

    retCode = mvncCloseDevice(deviceHandle);
    deviceHandle = NULL;
    if (retCode != MVNC_OK)
    {
        printf("Error - Could not close NCS device.\n");
        printf("    mvncStatus value: %d\n", retCode);
        exit(-1);
    }

    printf("Goodbye NCS!  Device Closed normally.\n");
    printf("NCS device working.\n");
}
```



* compiler, linker, and executing

```shell
g++ cpp/hello_ncs.cpp -o cpp/hello_ncs_cpp -l mvnc
cpp/hello_ncs_cpp
```



## Python3



* python script (named `hello_ncs.py`)

```python
#!/usr/bin/python3

import mvnc.mvncapi as fx

# main entry point for the program
if __name__=="__main__":

    # set the logging level for the NC API
    fx.SetGlobalOption(fx.GlobalOption.LOG_LEVEL, 0)

    # get a list of names for all the devices plugged into the system
    ncs_names = fx.EnumerateDevices()
    if (len(ncs_names) < 1):
        print("Error - no NCS devices detected, verify an NCS device is connected.")
        quit()

    # get the first NCS device by its name.
    # For this program we will always open the first NCS device.
    # You can also use index to call different ncs devices
    dev = fx.Device(ncs_names[0])

    # try to open the device.
    # this will throw an exception if someone else has it open already
    try:
        dev.OpenDevice()
    except:
        print("Error - Could not open NCS device.")
        quit()

    # here is the section that you can add your own scripts running on the NCS
    print("Hello NCS! Device opened normally.")

    try:
        dev.CloseDevice()
    except:
        print("Error - could not close NCS device.")
        quit()

    print("Goodbye NCS! Device closed normally.")
    print("NCS device working.")
```



* the shell to run the script

```shell
python3 hello_ncs.py
```

