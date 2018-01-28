program main
    use error_codes
    use messages

    implicit none

    integer, parameter :: sp = selected_real_kind(6, 37)
    integer, parameter :: dp = selected_real_kind(15, 307)
    integer, parameter :: max_len = 512
    integer, parameter :: in_x=600, in_y=640, in_z=21
    character(len=max_len), parameter :: thickness_file = "../../data/grids/thicknesses_2km_600x640.txt"

    character(len=max_len) in_path, in_f1, out_f1, bin_iomsg, f_name

    integer status, bin_iostat
    integer ii, jj
    real(kind = sp), dimension(in_z) :: thickness_array
    real(kind = dp), dimension(in_x, in_y, in_z) :: in_variable
    real(kind = dp), dimension(in_x, in_y) :: out_variable

    call read_input_parameters(in_path, in_f1, out_f1, status)
    if(status .eq. -1) call handle_error(input_params_err_msg, err_missing_program_input)

    open(unit=101, file=thickness_file, status='old', action='read')
    read(101,*) thickness_array
    close(101)
    f_name = trim(in_path)//trim(in_f1)
    write(*,*) trim(f_name)
    open(102, file = f_name, access = 'direct', status = 'old', &
        iostat = bin_iostat, iomsg = bin_iomsg, form = 'unformatted', &
        convert = 'big_endian', recl = in_x*in_y*in_z*8)
    if(bin_iostat .ne. 0) call handle_error(bin_iomsg, err_writing_bin)
    read(102, rec=1, iostat = bin_iostat, iomsg = bin_iomsg) in_variable
    if(bin_iostat .ne. 0) call handle_error(bin_iomsg, err_writing_bin)
    close(102, iostat = bin_iostat, iomsg = bin_iomsg)
    if(bin_iostat .ne. 0) call handle_error(bin_iomsg, err_writing_bin)
    write(*,*) minval(in_variable), maxval(in_variable)
    ! do ii = 1, in_z
    !     write(*,*) ii
    ! enddo
end program

subroutine read_input_parameters(in_path, in_f1, out_f1, status)
    implicit none
    character(len=512), intent(out) :: in_path, in_f1, out_f1
    integer, intent(out) :: status
    status = 0
    call getarg(1, in_path)
    call getarg(2, in_f1)
    call getarg(3, out_f1)
    if(in_path == '' .or. in_f1 == '' .or. out_f1 == '') status = -1
end subroutine

subroutine handle_error(message, status)
    implicit none
    character(len=*), intent(in) :: message
    integer, intent(in) :: status
    write(*,*) trim(message)
    call exit(status)
end subroutine
