# Step by step to build nvdla(small configuration) in AWS F1:  
1.  Setup environment variables: 
    > export CL_DIR=<your dir>/vp/fpga/aws-fpga/cl_nvdla
    > export NV_HW_ROOT=<your_nvdla_hw_dir>
2.  Git clone aws-fpga from github:
    > git clone https://github.com/aws/aws-fpga.git 
3.  Souce aws-fpga hdk environment:
    > source aws-fpga/hdk_setup.sh
4.  generate nvdla file list:
    > ./filelist.sh
4.  Command line to build nvdla in aws fpga: 
    > $HDK_DIR/common/shell_stable/build/scripts/aws_build_dcp_from_cl.sh -foreground -clock_recipe_a A2

