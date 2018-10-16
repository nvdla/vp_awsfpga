# ================================================================
# NVDLA Open Source Project
# 
# Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
# NVDLA Open Hardware License; Check \"LICENSE\" which comes with 
# this distribution for more information.
# ================================================================

rm -rf ./nvdla_file.tcl
rm -rf ../src_post_encryption
version=$1

SelecSource(){
local_folder=$1
local_file_type=$2

echo processing the folder: $local_folder
file_list=`ls ${NV_HW_ROOT}/${local_folder}/*.${local_file_type}`
#echo ${file_list}
for  file in ${file_list}
do
tmp_file=`basename $file`
echo file copy -force \$NV_HW_ROOT/$local_folder/$tmp_file \$TARGET_DIR  >> ./nvdla_file.tcl
done
}

RemoveFile(){
local_file=$1
echo "remove file $local_file"
sed '/'$local_file'/d' nvdla_file.tcl > nvdla_file.tcl_temp
mv nvdla_file.tcl_temp nvdla_file.tcl
}

ip_path=outdir/$version/spec/manual
file_type=v
SelecSource $ip_path $file_type

ip_path=outdir/$version/vmod/nvdla
file_type=v
folder_list=`ls ${NV_HW_ROOT}/${ip_path}`
echo ${folder_list}
for folder in ${folder_list}
do
SelecSource ${ip_path}/$folder $file_type
done

ip_path=outdir/$version/vmod/include
file_type=vh
SelecSource ${ip_path} $file_type

ip_path=outdir/$version/vmod/vlibs
file_type=v
SelecSource ${ip_path} $file_type

ip_path=outdir/$version/spec/defs
file_type=vh
SelecSource ${ip_path} $file_type

#export PATH=.:$PATH
#echo "dla_ramgen -m nv_ram_rwsp_8x65" >> ${NV_HW_ROOT}/vmod/rams/fpga/run_small_ram
#echo "dla_ramgen -m nv_ram_rws_256x64" >> ${NV_HW_ROOT}/vmod/rams/fpga/run_small_ram
#cur_path=`pwd`
#cd  ${NV_HW_ROOT}/vmod/rams/fpga
#./run_small_ram
#mkdir -p ${NV_HW_ROOT}/outdir/$version/vmod/rams/fpga/small_rams
#mv ${NV_HW_ROOT}/vmod/rams/fpga/*.v ${NV_HW_ROOT}/outdir/$version/vmod/rams/fpga/small_rams
#cd ${cur_path}

ip_path=outdir/$version/vmod/rams/fpga/model
file_type=v
SelecSource ${ip_path} $file_type

ip_path=outdir/$version/vmod/fifos
file_type=v
SelecSource ${ip_path} $file_type

if [ $version == "nv_large" ]
then
file_remove_list="NV_NVDLA_CDP_DP_bufferin_tp1.v NV_NVDLA_CVIF_WRITE_IG_arb.v"
elif [ $version == "nv_medium_1024_full" ]
then
file_remove_list="NV_NVDLA_CDP_DP_bufferin_tp1.v"
elif [ $version == "nv_medium_512" ]
then
file_remove_list="NV_NVDLA_SDP_CORE_Y_lut.v NV_NVDLA_SDP_HLS_Y_cvt_top.v NV_NVDLA_SDP_HLS_Y_idx_top.v NV_NVDLA_SDP_HLS_Y_inp_top.v NV_NVDLA_SDP_HLS_Y_int_core.v"
elif [ $version == "nv_small_256_full" ]
then
#file_remove_list="NV_NVDLA_SDP_CORE_Y_lut.v NV_NVDLA_SDP_HLS_Y_idx_top.v NV_NVDLA_SDP_HLS_Y_inp_top.v"
file_remove_list=""
else 
file_remove_list="NV_NVDLA_SDP_CORE_Y_lut.v NV_NVDLA_SDP_HLS_Y_cvt_top.v NV_NVDLA_SDP_HLS_Y_idx_top.v NV_NVDLA_SDP_HLS_Y_inp_top.v NV_NVDLA_SDP_HLS_Y_int_core.v"
fi 

for each_file in $file_remove_list
do
RemoveFile $each_file 
done
