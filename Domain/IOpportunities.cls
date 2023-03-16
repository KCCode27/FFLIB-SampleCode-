public interface IOpportunities extends fflib_ISObjects
{
	void applyDiscount(Decimal discountPercentage, fflib_ISObjectUnitOfWork uow);
	Set<Id> getAccountIds();
}
