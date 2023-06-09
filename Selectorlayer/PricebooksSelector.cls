public class PricebooksSelector extends    fflib_SObjectSelector
	                            implements IPricebooksSelector
{
	public static IPricebooksSelector newInstance()
	{
		return (IPricebooksSelector) Application.Selector.newInstance(Pricebook2.SObjectType);
	}
	
	public List<Schema.SObjectField> getSObjectFieldList()
	{
		return new List<Schema.SObjectField> {
			Pricebook2.Description,
			Pricebook2.Id,
			Pricebook2.IsActive,
			Pricebook2.IsStandard,
			Pricebook2.Name
		};
	}

	public Schema.SObjectType getSObjectType()
	{
		return Pricebook2.SObjectType;
	}

	public List<Pricebook2> selectById(Set<Id> idSet)
	{
		return (List<Pricebook2>) selectSObjectsById(idSet);
	}	
}
