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
    use initialcond

    implicit none


    PetscInt       :: nx = 50, ny = 50, dof=4, sw=3 ! use -da_grid_x, -da_grid_y to override these
    PetscErrorCode :: ierr
    TS             :: ts
    DM             :: da
    Vec            :: ug
    PetscInt       :: i, j, ibeg, jbeg, nlocx, nlocy
    PetscMPIInt    :: myRank, mySize
    PetscReal      :: dtglobal, dtlocal = 1.0e20, dx, dy, x, y
    character(len=80) :: outputString

    PetscScalar, pointer :: u(:,:,:)

    call PetscInitialize(PETSC_NULL_CHARACTER,ierr)
    if (ierr .ne. 0) then
        print*,'Unable to initialize PETSc'
        stop
    endif

    call MPI_Comm_size(PETSC_COMM_WORLD,mySize,ierr)
    CHKERRA(ierr)
        call MPI_Comm_rank(PETSC_COMM_WORLD,myRank,ierr)
        CHKERRA(ierr)

            write(outputString,*) 'No of Processors = ', mySize, ', rank = ',myRank,'\n'
            call PetscPrintf(PETSC_COMM_WORLD,outputString,ierr)



            call DMDACreate2d(PETSC_COMM_WORLD,                                    &
                &     DM_BOUNDARY_NONE,DM_BOUNDARY_NONE,                           &
                &     DMDA_STENCIL_STAR,nx,ny,PETSC_DECIDE,PETSC_DECIDE,dof,sw,    &
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
                    !call initcond(x, y, prim)
                    !call prim2con(prim, u(:,i,j))
                enddo
            enddo
            call DMDAVecRestoreArrayF90(da,ug,u,ierr)
            ! call VecView(ug,PETSC_VIEWER_STDOUT_WORLD,ierr)
            call DMRestoreGlobalVector(da,ug,ierr)
            call DMDestroy(da,ierr)

            call PetscFinalize(ierr)
            stop
        end program main
