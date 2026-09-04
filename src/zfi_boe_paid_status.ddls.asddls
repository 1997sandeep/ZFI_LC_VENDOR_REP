@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BOE Paid Status'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZFI_BOE_PAID_STATUS 
as select from I_AccountingDocumentJournal(
                  P_Language: $session.system_language
                ) as acc1
    left outer join I_AccountingDocumentJournal(
                  P_Language: $session.system_language
                ) as acc2
      on  acc2.AccountingDocument = acc1.ClearingAccountingDocument
      and acc2.CompanyCode        = acc1.CompanyCode
      and acc2.FiscalYear         = acc1.ClearingDocFiscalYear
      and acc2.PostingKey         = '39'
      and acc2.SpecialGLCode      = 'W'

{
  key acc1.AccountingDocument as AccountingDocument,
  key acc1.CompanyCode       as CompanyCode,
  key acc1.FiscalYear        as FiscalYear,

      case

        when acc1.ClearingAccountingDocument is initial

          then cast(
            'Not Paid'
            as abap.char(20)
          )

        else cast(
            'Paid'
            as abap.char(20)
          )

      end as PaidStatus

}
