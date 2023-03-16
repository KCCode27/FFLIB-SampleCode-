/**
 * This is a basic selector for Account for this app, note how it implements selectByOpportunity
 **/
 
 
 
 
public class AccountsSelector extends    fflib_SObjectSelector
	                          implements IAccountsSelector
{
	public static IAccountsSelector newInstance()
	{
		return (IAccountsSelector) Application.Selector.newInstance(Account.SObjectType);
	}
	
	public List<Schema.SObjectField> getSObjectFieldList()
	{
		return new List<Schema.SObjectField> {
			Account.Id,
			Account.Name,
			Account.Description
		};
	}

	public Schema.SObjectType getSObjectType()
	{
		return Account.SObjectType;
	}

	public List<Account> selectById(Set<Id> idSet)
	{
		return (List<Account>) selectSObjectsById(idSet);
	}
		
	public List<Account> selectByOpportunity(List<Opportunity> opportunities)
	{
		// Related Accounts
		Set<Id> accountIds = new Set<Id>();
		for (Opportunity opp : (List<Opportunity>) opportunities)
		{
			if (opp.AccountId != null)
			{
				accountIds.add(opp.AccountId);
			}
		}
		return selectById(accountIds);
	}	
}
