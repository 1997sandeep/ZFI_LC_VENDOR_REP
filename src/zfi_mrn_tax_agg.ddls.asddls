@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'MRN Tax Aggregated'

@Metadata.ignorePropagatedAnnotations: true

define view entity ZFI_MRN_TAX_AGG

  as select from I_AccountingDocumentJournal ( P_Language: $session.system_language ) as acc

    left outer join I_OperationalAcctgDocTaxItem as tax
      on  tax.AccountingDocument = acc.AccountingDocument
      and tax.CompanyCode       = acc.CompanyCode
      and tax.FiscalYear        = acc.FiscalYear

{
  key acc.PurchasingDocument as PurchaseOrder,

  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  sum(
    case
      when tax.TransactionTypeDetermination = 'JII'
      then cast(
             tax.TaxAmountInCoCodeCrcy
             as abap.dec(15,2)
           )
      else cast(
             0
             as abap.dec(15,2)
           )
    end
  ) as IGST,

  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  sum(
    case
      when tax.TransactionTypeDetermination = 'JIC'
      then cast(
             tax.TaxAmountInCoCodeCrcy
             as abap.dec(15,2)
           )
      else cast(
             0
             as abap.dec(15,2)
           )
    end
  ) as CGST,

  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  sum(
    case
      when tax.TransactionTypeDetermination = 'JIS'
      then cast(
             tax.TaxAmountInCoCodeCrcy
             as abap.dec(15,2)
           )
      else cast(
             0
             as abap.dec(15,2)
           )
    end
  ) as SGST,

  tax.CompanyCodeCurrency as CompanyCodeCurrency

}

where
      tax.TransactionTypeDetermination = 'JII'
   or tax.TransactionTypeDetermination = 'JIC'
   or tax.TransactionTypeDetermination = 'JIS'

group by
  acc.PurchasingDocument,
  tax.CompanyCodeCurrency
