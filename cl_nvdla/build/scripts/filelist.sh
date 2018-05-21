# ================================================================
# NVDLA Open Source Project
# 
# Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
# NVDLA Open Hardware License; Check \"LICENSE\" which comes with 
# this distribution for more information.
# ================================================================

rm -rf ./nvdla_file.tcl

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

ip_path=outdir/nv_small/spec/manual
file_type=v
SelecSource $ip_path $file_type

ip_path=outdir/nv_small/vmod/nvdla
file_type=v
folder_list=`ls ${NV_HW_ROOT}/${ip_path}`
echo ${folder_list}
for folder in ${folder_list}
do
SelecSource ${ip_path}/$folder $file_type
done

ip_path=outdir/nv_small/vmod/include
file_type=vh
SelecSource ${ip_path} $file_type

ip_path=outdir/nv_small/vmod/vlibs
file_type=v
SelecSource ${ip_path} $file_type

ip_path=outdir/nv_small/spec/defs
file_type=vh
SelecSource ${ip_path} $file_type

ip_path=outdir/nv_small/vmod/rams/fpga/small_rams
file_type=v
SelecSource ${ip_path} $file_type

file_remove_list="NV_NVDLA_SDP_CORE_Y_lut.v NV_NVDLA_SDP_HLS_Y_cvt_top.v NV_NVDLA_SDP_HLS_Y_idx_top.v NV_NVDLA_SDP_HLS_Y_inp_top.v NV_NVDLA_SDP_HLS_Y_int_core.v"
for each_file in $file_remove_list
do
RemoveFile $each_file 
done
