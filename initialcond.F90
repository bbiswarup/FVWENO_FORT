module initialcond
    use constants

	! real(KIND=RP), parameter, dimension(0:2) :: ark = (/ 0.0_RP, 3.0_RP/4.0_RP, 1.0_RP/3.0_RP /)
    real(KIND=RP), parameter :: xmin=-5.0_RP,xmax=5.0_RP
    real(KIND=RP), parameter :: ymin=-5.0_RP,ymax=5.0_RP
    real(KIND=RP), parameter :: gas_gamma=1.4_RP
    real(KIND=RP), parameter :: tfinal=0.4_RP
    real(KIND=RP), parameter :: cfl=0.1_RP
    character(*),  parameter :: BC='Neumann'

    real(KIND=RP), parameter ::rhoNE=0.5_RP,uxNE= 0.5_RP,uyNE=-0.5_RP,pNE=5.0_RP
    real(KIND=RP), parameter ::rhoNW=1.0_RP,uxNW= 0.5_RP,uyNW= 0.5_RP,pNW=5.0_RP
    real(KIND=RP), parameter ::rhoSW=3.0_RP,uxSW=-0.5_RP,uySW= 0.5_RP,pSW=5.0_RP
    real(KIND=RP), parameter ::rhoSE=1.5_RP,uxSE=-0.5_RP,uySE=-0.5_RP,pSE=5.0_RP

end module initialcond

