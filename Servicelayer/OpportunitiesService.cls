
public with sharing class OpportunitiesService 
{		
	public static void applyDiscounts(Set<Id> opportunityIds, Decimal discountPercentage)
	{
		service().applyDiscounts(opportunityIds, discountPercentage);
	}
	
	public static Set<Id> createInvoices(Set<Id> opportunityIds, Decimal discountPercentage)
	{		
		return service().createInvoices(opportunityIds, discountPercentage);
	}
	
	public static Id submitInvoicingJob()
	{
		return service().submitInvoicingJob();
	}	

	private static IOpportunitiesService service()
	{
		return (IOpportunitiesService) Application.Service.newInstance(IOpportunitiesService.class);
	}	
}
