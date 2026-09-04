@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BOE Wise Outstanding Report'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZFI_BOE_OUTSTANDING_FINAL
as select from zfi_ilc_boe as boe
    
left outer join ZFI_MRN_GRN_FINAL as mrn
on  mrn.BOEReference = boe.boe_ref_number

left outer join zfi_inward_lc as ilc
on  ilc.purchase_order = mrn.PONumber
and ilc.company_code   = mrn.CompanyCode

left outer join ZFI_BOE_ACCEPTANCE as accept
  on  accept.AccountingDocument = mrn.DocumentNumber
  and accept.CompanyCode       = mrn.CompanyCode
  
left outer join ZFI_BOE_PAID_STATUS as paid
  on  paid.AccountingDocument = mrn.DocumentNumber
  and paid.CompanyCode        = mrn.CompanyCode  
  
left outer join ZFI_BOE_PAID_AMOUNT as paidamt
  on  paidamt.AccountingDocument = mrn.DocumentNumber
  and paidamt.CompanyCode        = mrn.CompanyCode
  and paidamt.FiscalYear         = accept.FiscalYear  
  
left outer join ZFI_BOE_PAID_DATE as paiddate
  on  paiddate.AccountingDocument = mrn.DocumentNumber
  and paiddate.CompanyCode        = mrn.CompanyCode  
              
{
  key mrn.BOEReference              as ReferenceNumber,
      mrn.CompanyCode               as CompanyCode,
      boe.drawee_name               as DraweeName,
      boe.drawer_name               as DrawerName,
      boe.booking_date              as BookingBOEDate,
      boe.maturity_date             as MaturityDueDate,
      boe.currency                  as Currency,
      mrn.TotalAmount                 as BillAmount,
      mrn.LCReference               as LCReferenceNumber,
      mrn.PONumber                  as OrderNo,

      case
      when accept.AccountingDocument is not null
      then 'Accepted'
      else 'Not Accepted'
      end as AcceptanceStatus,
      
      @Semantics.amount.currencyCode : 'Currency'
      accept.NetAmount       as AcceptedAmount,
      paid.PaidStatus as PaidStatus,
      
      @Semantics.amount.currencyCode : 'Currency'
      paidamt.NetAmount as PaidAmount,
      paiddate.PaidDate as PaymentDate,
      
      @Semantics.amount.currencyCode : 'Currency'
      (
        cast(
          mrn.TotalAmount
          as abap.decfloat34
        )
        -
        cast(
          coalesce(
            paidamt.NetAmount,
            cast(
              0 as abap.decfloat34
            )
          )
          as abap.decfloat34
        )
      ) as Outstanding,
      
      ilc.remarks                  as Remarks

}
