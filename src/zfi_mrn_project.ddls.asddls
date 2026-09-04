@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'MRN Project'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZFI_MRN_PROJECT 
as select from ZFI_MRN_JOB as job
left outer join I_EnterpriseProject as project
on project.WBSElementInternalID = job.WBSElementInternalID

{
  key job.PurchaseOrder,
  key job.PurchaseOrderItem,

      project.Project as JobID
}
