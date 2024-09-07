# ConceptOS

Conceptual Custom OS for RPi4
AIM - Learning and building OS from scratch

****************************************************

ConceptOS toolchain requried to build the final kernel8.img
If ConceptOS toolchain doesnot exist, Please build the toolchain using following steps -

1. Goto scripts/ folder
2. Run the following command -

        $ ./buildToolchain.sh <password> <flag>
    
   No flags by default
   * flag = test_tools -> To install Qemu and Putty for testing the build image


Toolchain will be created in project folder at - crossComp/ folder 

****************************************************

Using QEMU for testing build image on VM.

Qemu command to load the kernel image, command to run from OS root directory ->

    $ qemu-system-aarch64 -M raspi4b2g -serial stdio -kernel kernel8.img
