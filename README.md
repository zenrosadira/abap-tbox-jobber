# ABAP Jobber
A simple ABAP class wrapper for JOB_OPEN / SUBMIT VIA JOB / JOB_CLOSE sequence for execute a report in background.

## Usage
Create new object of class ZTBOX_CL_JOBBER passing a name for the job, then call method START_JOB passing report name to be executed in background.
```
DATA(jobber) = NEW ztbox_cl_jobber( 'MY_JOB' ).
jobber->start_job( 'ZABAP_REPORT' ).
```

Use SET_SELECTIONS method to set report parameters before calling START_JOB
```
jobber->set_selections( VALUE #(
  ( selname = 'P_VBELN'
    kind    = 'P'
    low     = '123' ) ) ).
```

## Installation
Install this project using [abapGit](https://abapgit.org/) ![abapGit](https://docs.abapgit.org/img/favicon.png)
