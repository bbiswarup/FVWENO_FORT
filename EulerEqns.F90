module EulerEqns
    use constants
    implicit none

    INTEGER, PARAMETER       :: nvar=4
    REAL(KIND=RP), PARAMETER :: gas_gamma=1.4_RP
contains
    subroutine initcond(x, y, prim)
        REAL(KIND=RP),INTENT(IN) :: x,y
        REAL(KIND=RP),DIMENSION(0:nvar-1),INTENT(OUT)  :: prim
        REAL(KIND=RP) :: M = 0.5_RP
        REAL(KIND=RP) :: alpha = 0.0_RP
        REAL(KIND=RP) :: beta = 5.0_RP
        REAL(KIND=RP) :: r2
        r2 = x*x + y*y
        prim(0) =  (1.0_RP - (gas_gamma-1.0_RP)*(beta*beta)/(8.0_RP*gas_gamma*pi*pi)*exp(1.0_RP-r2))** (1.0_RP/(gas_gamma-1.0_RP));
        prim(1) =  M*cos(alpha*pi/180.0_RP) - beta/(2.0_RP*pi)*y*exp(0.5_RP*(1.0_RP-r2));
        prim(2) =  M*sin(alpha*pi/180.0_RP) + beta/(2.0_RP*pi)*x*exp(0.5_RP*(1.0_RP-r2));
        prim(3) =  prim(0)** gas_gamma;
    end subroutine initcond
end module EulerEqns
