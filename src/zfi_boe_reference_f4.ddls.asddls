@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BOE Reference F4'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZFI_BOE_REFERENCE_F4 
as select from zfi_ilc_boe
{
    key boe_ref_number as BOEReference,
        lc_number      as LCReference
}
