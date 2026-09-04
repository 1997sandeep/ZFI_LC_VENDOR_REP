@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BOE Paid Reference'
@Metadata.ignorePropagatedAnnotations: true

define view entity ZFI_BOE_PAID_REF

  as select distinct from I_AccountingDocumentJournal(
                           P_Language: $session.system_language
                         ) as acc1

{
  key acc1.AccountingDocument       as AccountingDocument,
  key acc1.CompanyCode             as CompanyCode,
  key acc1.FiscalYear              as FiscalYear,

      acc1.ClearingAccountingDocument as ClearingAccountingDocument,
      acc1.ClearingDocFiscalYear      as ClearingDocFiscalYear

}
where acc1.ClearingAccountingDocument is not null
