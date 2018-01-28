program main
    use error_codes
    use messages

    implicit none

    integer, parameter :: max_len = 256
    character(len=max_len), parameter :: out_var1 = 'SU', out_var2 = 'SV'
    character(len=max_len) in_path, in_f1, in_f2, out_f1, out_f2

    integer status

    call read_input_parameters(in_path, in_f1, in_f2, out_f1, out_f2, status)
    if(status .eq. -1) call handle_error(input_params_err_msg, err_missing_program_input)

    write(*,*) in_f1
end program

subroutine read_input_parameters(in_path, in_f1, in_f2, out_f1, out_f2, status)
    implicit none
    character(len=256), intent(out) :: in_path, in_f1, in_f2, out_f1, out_f2
    integer, intent(out) :: status
    status = 0
    call getarg(1, in_path)
    call getarg(2, in_f1)
    call getarg(3, in_f2)
    call getarg(3, out_f1)
    call getarg(3, out_f2)
    if(in_path == '' .or. in_f1 == '' .or. in_f2 == '' .or. out_f1 == '' .or. out_f2 == '') status = -1
end subroutine