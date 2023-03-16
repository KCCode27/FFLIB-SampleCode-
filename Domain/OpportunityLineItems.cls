public with sharing class OpportunityLineItems extends fflib_SObjectDomain
	
{
	public static IOpportunityLineItems newInstance(List<OpportunityLineItem> recordList)
	{
		return (IOpportunityLineItems) Application.Domain.newInstance(recordList);
	}

	public static IOpportunityLineItems newInstance(Set<Id> recordIdSet)
	{
		return (IOpportunityLineItems) Application.Domain.newInstance(recordIdSet);
	}
	
	public OpportunityLineItems(List<OpportunityLineItem> sObjectList)
	{
		super(sObjectList);
	}

	public void applyDiscount(IOpportunities opps, Decimal discountPercentage, fflib_ISObjectUnitOfWork uow)
	{
		// Opportunties by Id
		Map<Id, Opportunity> opportunitiesById = 
			new Map<Id, Opportunity>((List<Opportunity>) opps.getRecords());
		
		// Calculate discount factor
		Decimal factor = Opportunities.calculateDiscountFactor(discountPercentage);
		
		// Adjust UnitPrice of each line according to Discount Type of Opportunity
		for(OpportunityLineItem line : (List<OpportunityLineItem>) this.records)
		{
			// Skip products that have not been approved for discounting
			Opportunity opportunity = opportunitiesById.get(line.OpportunityId);
			if (opportunity.DiscountType__c == 'Approved Products')
			{
				if (line.PricebookEntry.Product2.DiscountingApproved__c == false)
				{
					continue;
				}
			}
					
			// Adjust UnitPrice
			line.UnitPrice = line.UnitPrice * factor;
			
			// Register this record as dirty with the unit of work
			uow.registerDirty(line);
		}
	}
		
	public class Constructor implements fflib_SObjectDomain.IConstructable
	{
		public fflib_SObjectDomain construct(List<SObject> sObjectList)
		{
			return new OpportunityLineItems(sObjectList);
		}
	}
}
