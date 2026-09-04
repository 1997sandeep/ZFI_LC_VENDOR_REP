@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'MRN / GRN Final Details'
@Metadata.ignorePropagatedAnnotations: true

define root view entity ZFI_MRN_GRN_FINAL
as select from zfi_inward_lc as ilc
left outer join ZFI_MRN_ACC_DOC( P_Language: $session.system_language ) as acc
on  acc.PurchaseOrder = ilc.purchase_order
and acc.CompanyCode   = ilc.company_code
                   
left outer join ZFI_MRN_PROJECT as job
on job.PurchaseOrder = ilc.purchase_order
              
left outer join ZFI_MRN_TAX_AGG as tax
on tax.PurchaseOrder = ilc.purchase_order
             
left outer join ZFI_MRN_TDS as tds
on  tds.AccountingDocument = acc.AccountingDocument
and tds.CompanyCode        = acc.CompanyCode

left outer join zfi_mrn_grn as mrn
on  mrn.po_number    = ilc.purchase_order
and mrn.company_code = ilc.company_code

left outer join I_Supplier as sup
      on  (
             ilc.vendor_code = sup.Supplier
           )
       or (
             ilc.vendor_code = ''
         and acc.Supplier    = sup.Supplier
          )
        
left outer join ZFI_MRN_WRX_AMOUNT ( P_Language: $session.system_language ) as wrx
  on wrx.PurchaseOrder = ilc.purchase_order          
         
{             
  key ilc.purchase_order            as PONumber,
  key ilc.company_code              as CompanyCode,

      acc.AccountingDocument        as DocumentNumber,
      acc.ReferenceDocument         as VoucherNo,
      acc.PostingDate               as VoucherDate,

      job.JobID                     as JobID,
      
      case
        when ilc.vendor_code = ''
          then acc.Supplier
        else ilc.vendor_code
      end                       as Vendor,
      
      sup.SupplierName as SupplierName,
      
      ilc.lc_currency as Currency,
      @Semantics.amount.currencyCode : 'Currency'
case
  when wrx.CreditAmount is not null
    then
      cast( wrx.CreditAmount as abap.decfloat34 )
      -
      cast( wrx.DebitAmount as abap.decfloat34 )
  else
      cast( 0 as abap.decfloat34 )
end as BasicAmount,

      tax.IGST                      as IGST,
      tax.CGST                      as CGST,
      tax.SGST                      as SGST,
      
      @Semantics.amount.currencyCode : 'Currency'
      tds.TDS                       as TDS,

      @Semantics.amount.currencyCode : 'Currency'
(
    cast( wrx.CreditAmount as abap.decfloat34 )
  - cast( wrx.DebitAmount  as abap.decfloat34 )
  + cast( tax.CGST         as abap.decfloat34 )
  + cast( tax.SGST         as abap.decfloat34 )
  + cast( tax.IGST         as abap.decfloat34 )
  - cast( tds.TDS          as abap.decfloat34 )
) as TotalAmount,

      ilc.lc_number                 as LCReference,

      mrn.boe_reference             as BOEReference

}
