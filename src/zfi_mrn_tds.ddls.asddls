@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'MRN TDS Details'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZFI_MRN_TDS 
 as select from I_Withholdingtaxitem
{
  key AccountingDocument,
  key CompanyCode,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum(
        cast(
          WhldgTaxBaseAmtInCoCodeCrcy
          as abap.dec(15,2)
        )
      ) as TDS,

      CompanyCodeCurrency
}
group by
  AccountingDocument,
  CompanyCode,
  CompanyCodeCurrency
