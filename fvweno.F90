program main
#include <petsc/finclude/petsc.h>
#include <petsc/finclude/petscdm.h>
#include <petsc/finclude/petscdmda.h>
#include <petsc/finclude/petscts.h>
#include <petsc/finclude/petscsys.h>
#include <petsc/finclude/petscvec.h>
#include <petsc/finclude/petscdm.h>
#include <petsc/finclude/petscdmda.h>

    use petsc
    use petscsys

    use constants
    use param
    use EulerEqns
    use output


    implicit none


    PetscInt       :: nx = 40, ny = 40, sw=3 ! use -da_grid_x, -da_grid_y to override these
    PetscErrorCode :: ierr
    TS             :: ts
    DM             :: da
    Vec            :: ug
    PetscInt       :: i, j, ibeg, jbeg, nlocx, nlocy, c
    PetscMPIInt    :: myRank, mySize
    PetscReal      :: dtglobal, dtlocal = 1.0e20, x, y, t
    character(len=80) :: outputString
    PetscScalar, pointer :: u(:,:,:)
    real (KIND=RP),dimension(0:nvar-1) :: prim

    call PetscInitialize(PETSC_NULL_CHARACTER,ierr)
    if (ierr .ne. 0) then
        print*,'Unable to initialize PETSc'
        stop
    endif

    call MPI_Comm_size(PETSC_COMM_WORLD,mySize,ierr)
    call MPI_Comm_rank(PETSC_COMM_WORLD,myRank,ierr)

    call DMDACreate2d(PETSC_COMM_WORLD,                                    &
        &     DM_BOUNDARY_NONE,DM_BOUNDARY_NONE,                           &
        &     DMDA_STENCIL_STAR,nx,ny,PETSC_DECIDE,PETSC_DECIDE,nvar,sw,   &
        &                PETSC_NULL_INTEGER,PETSC_NULL_INTEGER,da,ierr)
    call DMSetFromOptions(da,ierr)
    call DMSetUp(da,ierr)
    call DMGetGlobalVector(da,ug,ierr)
    call DMDAGetCorners(da,ibeg,jbeg,PETSC_NULL_INTEGER,                   &
        &                  nlocx,nlocy,PETSC_NULL_INTEGER,ierr)
    dx = (xmax - xmin) /(nx);
    dy = (ymax - ymin) /(ny);
    call DMDAVecGetArrayF90(da,ug,u,ierr)
    do i=ibeg,ibeg+nlocx-1
        do j=jbeg,jbeg+nlocy-1
            x = xmin + i*dx + 0.5*dx
            y = ymin + j*dy + 0.5*dy
            !write(outputString,*) 'x = ', x, ', y = ',y,'\n'
            !call PetscPrintf(PETSC_COMM_WORLD,outputString,ierr)
            call initcond(x, y, prim)
            u(:,i,j)=prim
            !call prim2con(prim, u(:,i,j))
        enddo
    enddo
    call DMDAVecRestoreArrayF90(da,ug,u,ierr)
    ! call VecView(ug,PETSC_VIEWER_STDOUT_WORLD,ierr)
    t=0.0
    c=0
    call savesol_2D(ug,da,t,c,ierr)
    call DMRestoreGlobalVector(da,ug,ierr)
    call DMDestroy(da,ierr)

    call PetscFinalize(ierr)
    stop
end program main
