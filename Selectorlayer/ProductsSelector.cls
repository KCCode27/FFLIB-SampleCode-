public class ProductsSelector extends    fflib_SObjectSelector
	                          implements IProductsSelector
{
	public static IProductsSelector newInstance()
	{
		return (IProductsSelector) Application.Selector.newInstance(Product2.SObjectType);
	}
	
	public ProductsSelector()
	{
		super(false);
	}
	
	public ProductsSelector(Boolean includeFieldSetFields)
	{
		super(includeFieldSetFields);
	}
	
	public List<Schema.SObjectField> getSObjectFieldList()
	{
		return new List<Schema.SObjectField> {
			Product2.Description,
			Product2.Id,
			Product2.IsActive,
			Product2.Name,
			Product2.ProductCode,
			Product2.DiscountingApproved__c
		};
	}

	public Schema.SObjectType getSObjectType()
	{
		return Product2.SObjectType;
	}

	public List<Product2> selectById(Set<Id> idSet)
	{
		return (List<Product2>) selectSObjectsById(idSet);
	}
	
	public override List<Schema.FieldSet> getSObjectFieldSetList()
	{
		return new List<Schema.FieldSet> { SObjectType.Product2.FieldSets.OpportunityDiscount };
	}
}
