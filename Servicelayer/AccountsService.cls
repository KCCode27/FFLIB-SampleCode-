public with sharing class AccountsService
{
	public static void updateOpportunityActivity(Set<Id> accountIds)
	{
		service().updateOpportunityActivity(accountIds);
	}

	private static IAccountsService service()
	{
		return (IAccountsService) Application.Service.newInstance(IAccountsService.class);
	}
}
