public interface IOpportunitiesService 
{
	void applyDiscounts(Set<Id> opportunityIds, Decimal discountPercentage);
	Set<Id> createInvoices(Set<Id> opportunityIds, Decimal discountPercentage);
	Id submitInvoicingJob();
}
