# Step by step to build nvdla(small configuration) in AWS F1:  
1.  Setup environment variables: 
    > export CL_DIR=<your dir>/vp/fpga/aws-fpga/cl_nvdla
    > export NV_HW_ROOT=<your_nvdla_hw_dir>
2.  Git clone aws-fpga from github:
    > git clone https://github.com/aws/aws-fpga.git 
3.  Souce aws-fpga hdk environment:
    > source aws-fpga/hdk_setup.sh
4.  Generate nvdla file list:
    > ./filelist.sh [nv_large | nv_medium_1024_full | nv_medium_512 | nv_small_256_full | nv_small_256 | nv_small]
5.  Change the verilog define in file synth_cl_nvdla.tcl for different configure 
    > -verilog_define NV_LARGE | NV_MEDIUM_1024_FULL | NV_MEDIUM_512 |  NV_SMALL_256_FULL |  NV_SMALL_256 |  NV_SMALL
6.  Command line to build nvdla in aws fpga: 
    > $HDK_DIR/common/shell_stable/build/scripts/aws_build_dcp_from_cl.sh -foreground -clock_recipe_a A2

