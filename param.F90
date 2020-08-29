module param
    use constants
    real(KIND=RP) :: dx, dy
	! real(KIND=RP), parameter, dimension(0:2) :: ark = (/ 0.0_RP, 3.0_RP/4.0_RP, 1.0_RP/3.0_RP /)
    real(KIND=RP), parameter :: xmin=-5.0_RP,xmax=5.0_RP
    real(KIND=RP), parameter :: ymin=-5.0_RP,ymax=5.0_RP
    real(KIND=RP), parameter :: tfinal=0.4_RP
    real(KIND=RP), parameter :: cfl=0.1_RP
    character(*),  parameter :: BC='Neumann'

end module param

