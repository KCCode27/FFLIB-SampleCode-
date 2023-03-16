
public class OpportunitiesSelector extends    fflib_SObjectSelector
	                               implements IOpportunitiesSelector
{
	public static IOpportunitiesSelector newInstance()
	{
		return (IOpportunitiesSelector) Application.Selector.newInstance(Opportunity.SObjectType);
	}
	
	public List<Schema.SObjectField> getSObjectFieldList()
	{
		return new List<Schema.SObjectField> {
			Opportunity.AccountId,
			Opportunity.Amount,
			Opportunity.CloseDate,
			Opportunity.Description,
			Opportunity.ExpectedRevenue,
			Opportunity.Id,
			Opportunity.Name,
			Opportunity.Pricebook2Id,
			Opportunity.Probability,
			Opportunity.StageName,
			Opportunity.Type,
			Opportunity.DiscountType__c
		};
	}
	
	public Schema.SObjectType getSObjectType()
	{
		return Opportunity.SObjectType;
	}

	public List<Opportunity> selectById(Set<Id> idSet)
	{
		return (List<Opportunity>) selectSObjectsById(idSet);
	}
	
	

	public List<Opportunity> selectByIdWithProducts(Set<Id> idSet)
	{
		fflib_QueryFactory opportunitiesQueryFactory = newQueryFactory();

		fflib_QueryFactory lineItemsQueryFactory = 
			new OpportunityLineItemsSelector().
				addQueryFactorySubselect(opportunitiesQueryFactory);
			
		new PricebookEntriesSelector().
			configureQueryFactoryFields(lineItemsQueryFactory, 'PricebookEntry');
			
		new ProductsSelector().
			configureQueryFactoryFields(lineItemsQueryFactory, 'PricebookEntry.Product2');
			
		new PricebooksSelector().
			configureQueryFactoryFields(lineItemsQueryFactory, 'PricebookEntry.Pricebook2');

		return (List<Opportunity>)
   		        Database.query(
			    opportunitiesQueryFactory
				.setCondition('id in :idSet')
				.toSOQL());
	}
	
	
	
	
	public List<OpportunityInfo> selectOpportunityInfo(Set<Id> idSet)
	{
		List<OpportunityInfo> opportunityInfos = new List<OpportunityInfo>();

		for(Opportunity opportunity : Database.query( newQueryFactory(false)
														.selectField(Opportunity.Id)
														.selectField(Opportunity.StageName)
														.selectField(Opportunity.Amount)
														.selectField('Account.Name')
														.selectField('Account.AccountNumber')
														.selectField('Account.Owner.Name')
														.setCondition('id in :idSet')
														.toSOQL() ))
		{
			opportunityInfos.add(new OpportunityInfo(opportunity));
		}
			
		return opportunityInfos;	
	}
	
	public Database.QueryLocator queryLocatorReadyToInvoice()
	{
		return Database.getQueryLocator(
			newQueryFactory().setCondition(Opportunity.InvoicedStatus__c + ' = \'Ready\'').toSOQL());
	}
}
