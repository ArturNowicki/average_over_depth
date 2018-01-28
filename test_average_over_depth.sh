#!/bin/bash
# Created by Artur Nowicki on 26.01.2018.
in_path='../../data/boundary_conditions/tmp_bin_data/'
in_var1='UVEL'
in_var2='VVEL'
out_var1='SU'
out_var2='SV'
in_p_len=${#in_path}
thickness_file='../data_grids/thicknesses_2km_600x640.txt'


echo "Compile program."
gfortran messages.f90 error_codes.f90 average_over_depth.f90 -o average_over_depth
if [[ $? -ne 0 ]]; then
	exit
fi

if [[ $? -ne 0 ]]; then
	exit
fi

for in_f1 in ${in_path}*${in_var1}*; do
	# echo ${in_f1:0:23}
	in_f2=`echo ${in_f1:0:23}*${in_var2}*`
	in_file1=${in_f1:${in_p_len}}
	in_file2=${in_f2:${in_p_len}}
	IFS='_' read -r date_time rest_f_name <<< "$in_file1"
	out_file1=${date_time}'_'${out_var1}${rest_f_name:4}
	out_file2=${date_time}'_'${out_var2}${rest_f_name:4}
	echo "-------------------"
	# echo ${in_path} ${in_file1} ${out_file1}
	./average_over_depth ${in_path} ${in_file1} ${out_file1}
	# ./average_over_depth ${in_path} ${in_file2} ${out_file2}
done