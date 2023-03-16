 public class OpportunityLineItemsSelector extends    fflib_SObjectSelector
	                                       implements IOpportunityLineItemsSelector
{
	public static IOpportunityLineItemsSelector newInstance()
	{
		return (IOpportunityLineItemsSelector) Application.Selector.newInstance(OpportunityLineItem.SObjectType);
	}
	
	
	public List<Schema.SObjectField> getSObjectFieldList()
	{
		return new List<Schema.SObjectField> {
			OpportunityLineItem.Description,
			OpportunityLineItem.Id,
			OpportunityLineItem.ListPrice,
			OpportunityLineItem.OpportunityId,
			OpportunityLineItem.PricebookEntryId,
			OpportunityLineItem.Quantity,
			OpportunityLineItem.SortOrder,
			OpportunityLineItem.TotalPrice,
			OpportunityLineItem.UnitPrice
		};
	}

	public Schema.SObjectType getSObjectType()
	{
		return OpportunityLineItem.SObjectType;
	}
	
	
	

	public override String getOrderBy()
	{
		return 'SortOrder,PricebookEntry.Name';
	}

	public List<OpportunityLineItem> selectById(Set<Id> idSet)
	{
		return (List<OpportunityLineItem>) selectSObjectsById(idSet);
	}
	
	

	public List<OpportunityLineItem> selectRecentlyUsed(Set<Id> accountIds, Integer recordLimit)
	{
		assertIsAccessible();
		
		String query = String.format('select {0} from {1} where Opportunity.Account.id in :accountIds order by SystemModstamp DESC LIMIT :recordLimit', 
			new List<String>{ getFieldListString(), getSObjectName() });
			
			
			
		return (List<OpportunityLineItem>) Database.query(query);
	}
}
