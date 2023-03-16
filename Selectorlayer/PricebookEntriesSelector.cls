public class PricebookEntriesSelector extends    fflib_SObjectSelector
	                                  implements IPricebookEntriesSelector
{
	public static IPricebookEntriesSelector newInstance()
	{
		return (IPricebookEntriesSelector) Application.Selector.newInstance(PricebookEntry.SObjectType);
	}
	
	public List<Schema.SObjectField> getSObjectFieldList()
	{
		return new List<Schema.SObjectField> {
			PricebookEntry.Id,
			PricebookEntry.IsActive,
			PricebookEntry.Name,
			PricebookEntry.Pricebook2Id,
			PricebookEntry.Product2Id,
			PricebookEntry.ProductCode,
			PricebookEntry.UnitPrice,
			PricebookEntry.UseStandardPrice
		};
	}

	public Schema.SObjectType getSObjectType()
	{
		return PricebookEntry.SObjectType;
	}

	public List<PricebookEntry> selectById(Set<Id> idSet)
	{
		return (List<PricebookEntry>) selectSObjectsById(idSet);
	}
}
