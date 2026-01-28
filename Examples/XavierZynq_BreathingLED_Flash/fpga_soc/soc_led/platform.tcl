# 
# Usage: To re-create this platform project launch xsct with below options.
# xsct E:\ProgramData\Xilinx\7020_Test\fpga_soc\soc_led\platform.tcl
# 
# OR launch xsct and run below command.
# source E:\ProgramData\Xilinx\7020_Test\fpga_soc\soc_led\platform.tcl
# 
# To create the platform in a different location, modify the -out option of "platform create" command.
# -out option specifies the output directory of the platform project.

platform create -name {soc_led}\
-hw {E:\ProgramData\Xilinx\7020_Test\top.xsa}\
-proc {ps7_cortexa9_0} -os {standalone} -out {E:/ProgramData/Xilinx/7020_Test/fpga_soc}

platform write
platform generate -domains 
platform active {soc_led}
platform generate
