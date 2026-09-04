CLASS lhc_buffer DEFINITION.

  PUBLIC SECTION.

    CLASS-DATA mt_buffer TYPE STANDARD TABLE OF zfi_mrn_grn.

    CLASS-DATA mt_delete TYPE STANDARD TABLE OF zfi_mrn_grn.

ENDCLASS.


CLASS lhc_ZFI_MRN_GRN_FINAL DEFINITION
  INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_instance_authorizations
      FOR INSTANCE AUTHORIZATION
      keys REQUEST requested_authorizations
      FOR zfi_mrn_grn_final RESULT result.

    METHODS get_global_authorizations
      FOR GLOBAL AUTHORIZATION
      REQUEST requested_authorizations
      FOR zfi_mrn_grn_final RESULT result.

    METHODS create
      FOR MODIFY
      entities FOR CREATE zfi_mrn_grn_final.

    METHODS update
      FOR MODIFY
      entities FOR UPDATE zfi_mrn_grn_final.

    METHODS delete
      FOR MODIFY
      keys FOR DELETE zfi_mrn_grn_final.

    METHODS read
      FOR READ
      keys FOR READ zfi_mrn_grn_final RESULT result.

    METHODS lock
      FOR LOCK
      keys FOR LOCK zfi_mrn_grn_final.

ENDCLASS.


CLASS lhc_ZFI_MRN_GRN_FINAL IMPLEMENTATION.

  METHOD get_instance_authorizations.

  ENDMETHOD.


  METHOD get_global_authorizations.

  ENDMETHOD.


  METHOD create.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<entity>).

      APPEND VALUE zfi_mrn_grn(

        po_number       = <entity>-PONumber
        company_code    = <entity>-CompanyCode

        document_number = <entity>-DocumentNumber
        voucher_no      = <entity>-VoucherNo
        voucher_date    = <entity>-VoucherDate

        vendor          = <entity>-Vendor
        supplier_name   = <entity>-SupplierName

        job_id          = <entity>-JobID

        currency        = <entity>-Currency

        basic_amount    = <entity>-BasicAmount
        igst            = <entity>-IGST
        cgst            = <entity>-CGST
        sgst            = <entity>-SGST
        tds             = <entity>-TDS
        total_amount    = <entity>-TotalAmount

        lc_reference    = <entity>-LCReference
        boe_reference   = <entity>-BOEReference

      ) TO lhc_buffer=>mt_buffer.

    ENDLOOP.

  ENDMETHOD.


  METHOD update.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<entity>).

      DATA(ls_data) = VALUE zfi_mrn_grn(
        po_number    = <entity>-PONumber
        company_code = <entity>-CompanyCode
      ).

      SELECT SINGLE *
        FROM zfi_mrn_grn
        WHERE po_number    = @<entity>-PONumber
          AND company_code = @<entity>-CompanyCode
        INTO @ls_data.

      IF sy-subrc <> 0.

        APPEND VALUE #(
          %tky = <entity>-%tky
        ) TO failed-zfi_mrn_grn_final.

        CONTINUE.

      ENDIF.


      "------------------------------------------
      " Update only changed fields
      "------------------------------------------

      IF <entity>-%control-DocumentNumber = if_abap_behv=>mk-on.
        ls_data-document_number = <entity>-DocumentNumber.
      ENDIF.

      IF <entity>-%control-VoucherNo = if_abap_behv=>mk-on.
        ls_data-voucher_no = <entity>-VoucherNo.
      ENDIF.

      IF <entity>-%control-VoucherDate = if_abap_behv=>mk-on.
        ls_data-voucher_date = <entity>-VoucherDate.
      ENDIF.

      IF <entity>-%control-Vendor = if_abap_behv=>mk-on.
        ls_data-vendor = <entity>-Vendor.
      ENDIF.

      IF <entity>-%control-SupplierName = if_abap_behv=>mk-on.
        ls_data-supplier_name = <entity>-SupplierName.
      ENDIF.

      IF <entity>-%control-JobID = if_abap_behv=>mk-on.
        ls_data-job_id = <entity>-JobID.
      ENDIF.

      IF <entity>-%control-Currency = if_abap_behv=>mk-on.
        ls_data-currency = <entity>-Currency.
      ENDIF.

      IF <entity>-%control-BasicAmount = if_abap_behv=>mk-on.
        ls_data-basic_amount = <entity>-BasicAmount.
      ENDIF.

      IF <entity>-%control-IGST = if_abap_behv=>mk-on.
        ls_data-igst = <entity>-IGST.
      ENDIF.

      IF <entity>-%control-CGST = if_abap_behv=>mk-on.
        ls_data-cgst = <entity>-CGST.
      ENDIF.

      IF <entity>-%control-SGST = if_abap_behv=>mk-on.
        ls_data-sgst = <entity>-SGST.
      ENDIF.

      IF <entity>-%control-TDS = if_abap_behv=>mk-on.
        ls_data-tds = <entity>-TDS.
      ENDIF.

      IF <entity>-%control-TotalAmount = if_abap_behv=>mk-on.
        ls_data-total_amount = <entity>-TotalAmount.
      ENDIF.

      IF <entity>-%control-LCReference = if_abap_behv=>mk-on.
        ls_data-lc_reference = <entity>-LCReference.
      ENDIF.

      IF <entity>-%control-BOEReference = if_abap_behv=>mk-on.
        ls_data-boe_reference = <entity>-BOEReference.
      ENDIF.


      APPEND ls_data TO lhc_buffer=>mt_buffer.

    ENDLOOP.

  ENDMETHOD.


  METHOD delete.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<key>).

      SELECT SINGLE *
        FROM zfi_mrn_grn
        WHERE po_number    = @<key>-PONumber
          AND company_code = @<key>-CompanyCode
        INTO @DATA(ls_delete).

      IF sy-subrc = 0.

        APPEND ls_delete TO lhc_buffer=>mt_delete.

      ELSE.

        APPEND VALUE #(
          %tky = <key>-%tky
        ) TO failed-zfi_mrn_grn_final.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD read.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<key>).

      SELECT SINGLE *
        FROM zfi_mrn_grn
        WHERE po_number    = @<key>-PONumber
          AND company_code = @<key>-CompanyCode
        INTO @DATA(ls_data).

      IF sy-subrc = 0.

        APPEND VALUE #(

          %tky = <key>-%tky

          PONumber       = ls_data-po_number
          CompanyCode    = ls_data-company_code

          DocumentNumber = ls_data-document_number
          VoucherNo      = ls_data-voucher_no
          VoucherDate    = ls_data-voucher_date

          Vendor         = ls_data-vendor
          SupplierName   = ls_data-supplier_name

          JobID          = ls_data-job_id

          Currency       = ls_data-currency

          BasicAmount    = ls_data-basic_amount
          IGST           = ls_data-igst
          CGST           = ls_data-cgst
          SGST           = ls_data-sgst
          TDS            = ls_data-tds
          TotalAmount    = ls_data-total_amount

          LCReference    = ls_data-lc_reference
          BOEReference   = ls_data-boe_reference

        ) TO result.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD lock.

  ENDMETHOD.

ENDCLASS.



CLASS lsc_ZFI_MRN_GRN_FINAL DEFINITION
  INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.


CLASS lsc_ZFI_MRN_GRN_FINAL IMPLEMENTATION.

  METHOD finalize.

  ENDMETHOD.


  METHOD check_before_save.

    "------------------------------------------
    " BOE Reference mandatory validation
    "------------------------------------------

    LOOP AT lhc_buffer=>mt_buffer
      ASSIGNING FIELD-SYMBOL(<data>).

      IF <data>-boe_reference IS INITIAL.

        "Validation can be added here if required

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD save.

    "------------------------------------------
    " DELETE
    "------------------------------------------

    LOOP AT lhc_buffer=>mt_delete
      ASSIGNING FIELD-SYMBOL(<delete>).

      DELETE FROM zfi_mrn_grn
        WHERE po_number    = @<delete>-po_number
          AND company_code = @<delete>-company_code.

    ENDLOOP.


    "------------------------------------------
    " INSERT / UPDATE
    "------------------------------------------

    LOOP AT lhc_buffer=>mt_buffer
      ASSIGNING FIELD-SYMBOL(<data>).

      UPDATE zfi_mrn_grn

        SET document_number = @<data>-document_number,

            voucher_no      = @<data>-voucher_no,

            voucher_date    = @<data>-voucher_date,

            vendor          = @<data>-vendor,

            supplier_name   = @<data>-supplier_name,

            job_id          = @<data>-job_id,

            currency        = @<data>-currency,

            basic_amount    = @<data>-basic_amount,

            igst            = @<data>-igst,

            cgst            = @<data>-cgst,

            sgst            = @<data>-sgst,

            tds             = @<data>-tds,

            total_amount    = @<data>-total_amount,

            lc_reference    = @<data>-lc_reference,

            boe_reference   = @<data>-boe_reference

        WHERE po_number    = @<data>-po_number

          AND company_code = @<data>-company_code.


      IF sy-subrc <> 0.

        INSERT zfi_mrn_grn FROM @<data>.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD cleanup.

    CLEAR lhc_buffer=>mt_buffer.

    CLEAR lhc_buffer=>mt_delete.

  ENDMETHOD.


  METHOD cleanup_finalize.

    CLEAR lhc_buffer=>mt_buffer.

    CLEAR lhc_buffer=>mt_delete.

  ENDMETHOD.

ENDCLASS.
