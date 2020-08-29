module output
#include <petsc/finclude/petsc.h>
#include <petsc/finclude/petscdm.h>
#include <petsc/finclude/petscdmda.h>
#include <petsc/finclude/petscsys.h>
    use petsc
    use param
    implicit none
contains
    SUBROUTINE savesol_2D(ug,da,t,c,ierr)
        PetscErrorCode, intent(inout) :: ierr
        DM            , intent(in)    :: da
        Vec           , intent(in)    :: ug
        PetscReal     , intent(in)    :: t
        PetscInt      , intent(inout) :: c

        PetscMPIInt    :: myRank
        PetscInt       :: i, j, nx, ny, ibeg, jbeg, nlocx, nlocy
        Vec            :: ul
        PetscScalar, pointer :: u(:,:,:)
        PetscReal :: x, y
        character(len=160) :: filename='sol'
        CHARACTER(LEN=30)  :: format
        !
        call DMGetLocalVector(da, ul, ierr)
        call DMGlobalToLocalBegin(da, ug, INSERT_VALUES, ul,ierr)
        call DMGlobalToLocalEnd(da, ug, INSERT_VALUES, ul,ierr)
        call DMDAVecGetArrayF90(da, ul, u, ierr);
        call DMDAGetInfo(da,PETSC_NULL_INTEGER,nx,ny,PETSC_NULL_INTEGER,PETSC_NULL_INTEGER,PETSC_NULL_INTEGER,  &
            & PETSC_NULL_INTEGER, PETSC_NULL_INTEGER,PETSC_NULL_INTEGER,PETSC_NULL_INTEGER,                     &
            & PETSC_NULL_INTEGER,PETSC_NULL_INTEGER,PETSC_NULL_INTEGER,ierr)
        call DMDAGetCorners(da,ibeg,jbeg,PETSC_NULL_INTEGER,                   &
            &                  nlocx,nlocy,PETSC_NULL_INTEGER,ierr)
        !
        call MPI_Comm_rank(PETSC_COMM_WORLD,myRank,ierr)
        Format = "(A,I3.3,A,I3.3,A)"
        WRITE(filename,format) 'sol-', c,'-', myRank,'.plt'
        open(myRank, file = filename, status = 'replace')
        write(myRank,'(A)') 'TITLE = "u_t + u_x + u_y = 0"'
        write(myRank,'(A)') 'VARIABLES = x, y, rho, u, v, p'
        write(myRank,'(A,ES14.7,A,I4,A,I4,A)') 'ZONE STRANDID=1, SOLUTIONTIME=',t,', I=',nlocx,', J=',nlocy,', DATAPACKING=POINT'
        do i=ibeg,ibeg+nlocx-1
            do j=jbeg,jbeg+nlocy-1
                x = xmin + i*dx + 0.5*dx;
                y = ymin + j*dy + 0.5*dy;
                !            prim=u(:,i,j)
                write(myRank,*) x, y, u(0,i,j),u(1,i,j),u(2,i,j),u(3,i,j)
            enddo
        enddo
        close(myRank)
        call DMDAVecRestoreArrayF90(da, ul, u, ierr)
        call DMRestoreLocalVector(da, ul, ierr)
        ierr=0
    !    ++c ! need to use pointer?
    END SUBROUTINE savesol_2D
end module output

