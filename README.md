# ABAP Jobber
A simple ABAP class wrapper for JOB_OPEN / SUBMIT VIA JOB / JOB_CLOSE sequence for execute a report in background.

## Quick Start
```abap
* First, create an instance passing a name for the job
DATA(jobber) = NEW ztbox_cl_jobber( 'MY_JOB' ).

* Then call method start_job passing report name to be executed in background.
jobber->start_job( 'ZABAP_REPORT' ).
```

Use `set_selections( )` to set report parameters before calling START_JOB

```abap
jobber->set_selections( VALUE #(
  ( selname = 'P_VBELN'
    kind    = 'P'
    low     = '123' ) ) ).
```

## Installation
Install this project using [abapGit](https://abapgit.org/) ![abapGit](https://docs.abapgit.org/img/favicon.png)
