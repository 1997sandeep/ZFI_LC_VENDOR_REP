@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'MRN GRN Accounting Amoun'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZFI_MRN_WRX_AMOUNT 
with parameters
    P_Language : abap.lang
  as select from I_AccountingDocumentJournal(
    P_Language: $parameters.P_Language
  ) as acc
{
  key acc.PurchasingDocument as PurchaseOrder,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum( acc.CreditAmountInCoCodeCrcy ) as CreditAmount,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum( acc.DebitAmountInCoCodeCrcy )  as DebitAmount,

      acc.CompanyCodeCurrency
}
where acc.TransactionTypeDetermination = 'WRX'
group by
  acc.PurchasingDocument,
  acc.CompanyCodeCurrency
