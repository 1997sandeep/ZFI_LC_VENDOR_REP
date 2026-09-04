@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'LC Summary Report'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZFI_LC_SUMMARY_FINAL 
  as select from zfi_inward_lc as ilc

  left outer join ZFI_MRN_GRN_FINAL as mrn
    on  mrn.PONumber    = ilc.purchase_order
    and mrn.CompanyCode = ilc.company_code
    
  left outer join zfi_ilc_boe as boe
      on boe.lc_number = ilc.lc_number  
      
  left outer join ZFI_BOE_PAID_AMOUNT as paidamt
  on  paidamt.AccountingDocument = mrn.DocumentNumber
  and paidamt.CompanyCode        = mrn.CompanyCode  
  
  left outer join ZFI_BOE_ACCEPTANCE as accept
  on  accept.AccountingDocument = mrn.DocumentNumber
  and accept.CompanyCode        = mrn.CompanyCode

{
    key ilc.company_code       as CompanyCode,
    key ilc.lc_number          as LcNumber,

    ilc.lc_currency            as LcCurrency,
    ilc.vendor_code            as Vendor,

    @Semantics.amount.currencyCode : 'LcCurrency'
    ilc.lc_amount              as LcAmount,

    ilc.amount_version         as AmountVersion,
    ilc.tolerance_percent      as TolerancePercent,

    @Semantics.amount.currencyCode : 'LcCurrency'
    ilc.tolerance_amount       as ToleranceAmount,

    @Semantics.amount.currencyCode : 'LcCurrency'
    ilc.total_lc_amount        as TotalLcAmount,

    ilc.lc_date                as LcDate,
    ilc.last_shipment_date     as LastShipmentDate,
    ilc.lsd_version            as LsdVersion,
    ilc.expiry_date            as ExpiryDate,
    ilc.ed_version             as EdVersion,

    ilc.purchase_order         as PurchaseOrder,
    ilc.po_date                as PoDate,
    ilc.execution_status       as ExecutionStatus,

    @Semantics.amount.currencyCode : 'LcCurrency'
    ilc.basic_po_amount        as BasicPoAmount,

    @Semantics.amount.currencyCode : 'LcCurrency'
    ilc.gst_amount             as GstAmount,

    @Semantics.amount.currencyCode : 'LcCurrency'
    ilc.total_po_amount        as TotalPoAmount,

    @Semantics.amount.currencyCode : 'LcCurrency'
    ilc.tds_amount             as TdsAmount,

    @Semantics.amount.currencyCode : 'LcCurrency'
    ilc.short_closed_amount    as ShortClosedAmount,

    ilc.issuance_status        as IssuanceStatus,
    ilc.descrepancies          as Descrepancies,

    @Semantics.amount.currencyCode : 'LcCurrency'
    cast(
      ilc.total_po_amount - ilc.tds_amount
      as abap.dec(15,2)
    ) as TDSNetAmount,

    @Semantics.amount.currencyCode : 'LcCurrency'
    sum(
        cast(
            mrn.TotalAmount
            as abap.dec(15,2)
        )
    ) as BillAmount,
    
    boe.boe_amount as BOEAmount,
    
    @Semantics.amount.currencyCode : 'LcCurrency'
    cast(
    mrn.TotalAmount as abap.dec(15,2)
    )
    -
    cast(
    boe.boe_amount as abap.dec(15,2)
    ) as BillOutstanding,
    
    paidamt.NetAmount   as BoePaid,
    
    @Semantics.amount.currencyCode : 'LcCurrency'
(
  cast(
    coalesce(
      accept.NetAmount,
      cast( 0 as abap.decfloat34 )
    )
    as abap.decfloat34
  )
  -
  cast(
    coalesce(
      paidamt.NetAmount,
      cast( 0 as abap.decfloat34 )
    )
    as abap.decfloat34
  )
) as BOEAcceptedbutnotPaid,

@Semantics.amount.currencyCode : 'LcCurrency'
(
  cast(
    case
      when boe.boe_amount = ''
        then '0'
      else boe.boe_amount
    end
    as abap.decfloat34
  )
  -
  cast(
    coalesce(
      paidamt.NetAmount,
      cast( 0 as abap.decfloat34 )
    )
    as abap.decfloat34
  )
) as BOEOutstanding,

@Semantics.amount.currencyCode : 'LcCurrency'
(
  cast(
    ilc.lc_amount
    as abap.decfloat34
  )
  -
  sum(
    cast(
      case
        when boe.boe_amount = ''
          then '0'
        else boe.boe_amount
      end
      as abap.decfloat34
    )
  )
) as LCOutstanding,

@Semantics.amount.currencyCode : 'LcCurrency'
(
  cast(
    ilc.total_lc_amount
    as abap.decfloat34
  )
  -
  sum(
    cast(
      coalesce(
        accept.NetAmount,
        cast( 0 as abap.decfloat34 )
      )
      as abap.decfloat34
    )
  )
) as LCLimitOutstanding

}
group by
    ilc.company_code,
    ilc.lc_number,
    ilc.lc_currency,
    ilc.vendor_code,
    ilc.lc_amount,
    ilc.amount_version,
    ilc.tolerance_percent,
    ilc.tolerance_amount,
    ilc.total_lc_amount,
    ilc.lc_date,
    ilc.last_shipment_date,
    ilc.lsd_version,
    ilc.expiry_date,
    ilc.ed_version,
    ilc.purchase_order,
    ilc.po_date,
    ilc.execution_status,
    ilc.basic_po_amount,
    ilc.gst_amount,
    ilc.total_po_amount,
    ilc.tds_amount,
    ilc.short_closed_amount,
    ilc.issuance_status,
    ilc.descrepancies,
    mrn.TotalAmount,
    boe.boe_amount,
    paidamt.NetAmount,
    accept.NetAmount
