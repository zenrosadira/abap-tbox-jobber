CLASS ztbox_cl_jobber DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_serializable_object .

    TYPES ty_rsparamsl_255_t TYPE TABLE OF rsparamsl_255 WITH DEFAULT KEY.

    METHODS start_job
      IMPORTING
        !i_program TYPE string .
    METHODS set_selections
      IMPORTING
        !it_sel TYPE ty_rsparamsl_255_t .
    METHODS constructor
      IMPORTING
        !i_job_name TYPE btcjob .
    METHODS get_errors
      RETURNING
        VALUE(r_errors) TYPE string_table .
    METHODS open .
    METHODS close .
    METHODS submit
      IMPORTING
        !i_program TYPE sy-repid .
protected section.
PRIVATE SECTION.

  DATA _job_name TYPE btcjob .
  DATA _job_count TYPE btcjobcnt .
  DATA _selections TYPE ty_rsparamsl_255_t  .
  DATA _errors TYPE string_table .

  METHODS _add_error
    IMPORTING
      !i_err TYPE string OPTIONAL .
ENDCLASS.



CLASS ZTBOX_CL_JOBBER IMPLEMENTATION.


  METHOD close.

    TRY.
        CALL FUNCTION 'JOB_CLOSE'
          EXPORTING
            jobcount             = _job_count
            jobname              = _job_name
            strtimmed            = abap_true
          EXCEPTIONS
            ERROR_MESSAGE        = -1
            cant_start_immediate = 1
            invalid_startdate    = 2
            jobname_missing      = 3
            job_close_failed     = 4
            job_nosteps          = 5
            job_notex            = 6
            lock_failed          = 7
            invalid_target       = 8
            OTHERS               = 9.
        IF sy-subrc NE 0.
          _add_error( ).
        ENDIF.

      CATCH cx_root INTO DATA(x_root).
        _add_error( x_root->get_text( ) ).

    ENDTRY.

  ENDMETHOD.


  METHOD CONSTRUCTOR.

    _job_name = i_job_name.

  ENDMETHOD.


  METHOD get_errors.

    r_errors = _errors.

  ENDMETHOD.


  METHOD open.

    TRY.
        CALL FUNCTION 'JOB_OPEN'
          EXPORTING
            jobname          = _job_name
          IMPORTING
            jobcount         = _job_count
          EXCEPTIONS
            error_message    = -1
            cant_create_job  = 1
            invalid_job_data = 2
            jobname_missing  = 3
            OTHERS           = 4.
        IF sy-subrc NE 0.
          _add_error( ).
        ENDIF.

      CATCH cx_root INTO DATA(x_root).
        _add_error( x_root->get_text( ) ).

    ENDTRY.

  ENDMETHOD.


  METHOD SET_SELECTIONS.

    _selections = it_sel.

  ENDMETHOD.


  METHOD START_JOB.

    open( ).

    submit( CONV #( i_program ) ).

    close( ).

  ENDMETHOD.


  METHOD submit.

    TRY.
        IF _selections IS NOT INITIAL.

          SUBMIT (i_program)                             "#EC CI_SUBMIT
            WITH SELECTION-TABLE _selections
            USER sy-uname
            AND RETURN
            VIA JOB _job_name
            NUMBER _job_count.

        ELSE.

          SUBMIT (i_program)                             "#EC CI_SUBMIT
          USER sy-uname
          AND RETURN
          VIA JOB _job_name
          NUMBER _job_count.

        ENDIF.

      CATCH cx_root INTO DATA(x_root).
        _add_error( x_root->get_text( ) ).

    ENDTRY.

  ENDMETHOD.


  METHOD _add_error.

    IF i_err IS SUPPLIED.

      INSERT i_err INTO TABLE _errors.

    ELSE.

      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO DATA(err).
      INSERT err INTO TABLE _errors.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
