# MIPS32_PipelineCPU
A MIPS32 CPU project with five-stage pipeline.

Update on Jun. 14:

Add **L1-cache** support. View the `with-cache` directory to see the details.

I implemented a L1 instruction cache of block size 4 Byte(1 word) and block number 64; and a L1 data cache of block size 4 Byte(1 word) and block number 64 and write-through, write-allocate policy(though this combination is not so common). The miss cost for both caches are 6 cycles.

Currently the cache version has been simulated under **icarus-verilog**, to run the simulation you can just type in

```bash
iverilog -o test -c compile_list.txt
./test
```

in your terminal and open `test.vcd` using **gtkwave** to see the result.

Note that the `no-cache` version has been simulated under **ModelSim 10.1** and has been tested on **Altera DE1-SOC** FPGA.