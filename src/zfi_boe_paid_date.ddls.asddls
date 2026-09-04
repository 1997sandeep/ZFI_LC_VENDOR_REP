@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BOE Paid Date'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZFI_BOE_PAID_DATE
  as select from ZFI_BOE_PAID_REF as ref
    left outer join I_AccountingDocumentJournal(
                      P_Language: $session.system_language
                    ) as acc2

      on  acc2.AccountingDocument = ref.ClearingAccountingDocument
      and acc2.CompanyCode        = ref.CompanyCode
      and acc2.FiscalYear         = ref.ClearingDocFiscalYear
      and acc2.PostingKey         = '39'
      and acc2.SpecialGLCode      = 'W'

    left outer join I_AccountingDocumentJournal(
                      P_Language: $session.system_language
                    ) as acc3

      on  acc3.AccountingDocument = acc2.ClearingAccountingDocument
      and acc3.CompanyCode        = acc2.CompanyCode
      and acc3.FiscalYear         = acc2.ClearingDocFiscalYear

{
  key ref.AccountingDocument as AccountingDocument,
  key ref.CompanyCode       as CompanyCode,
  key ref.FiscalYear        as FiscalYear,

      max( acc3.PostingDate ) as PaidDate
}

group by
  ref.AccountingDocument,
  ref.CompanyCode,
  ref.FiscalYear
