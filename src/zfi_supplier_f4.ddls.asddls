@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Supplier F4'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZFI_SUPPLIER_F4 
as select from I_Supplier
{
   key Supplier,
   SupplierName    
}
