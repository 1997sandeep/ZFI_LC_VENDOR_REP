@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'MRN Accounting Document'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZFI_MRN_ACC_DOC 
with parameters
    P_Language : abap.lang
  as select from I_AccountingDocumentJournal(
    P_Language: $parameters.P_Language
  )
{
  key PurchasingDocument as PurchaseOrder,
  key CompanyCode,
      Supplier,
      AccountingDocument,
      ReferenceDocument,
      PostingDate
}
where PurchasingDocument <> ''
