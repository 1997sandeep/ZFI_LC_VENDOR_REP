@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'MRN Job ID'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZFI_MRN_JOB 
as select from I_PurOrdAccountAssignmentAPI01 as aa
{
  key aa.PurchaseOrder     as PurchaseOrder,
  key aa.PurchaseOrderItem as PurchaseOrderItem,

      aa.WBSElementInternalID
}
