public with sharing class AccountsServiceImpl implements IAccountsService
{
	/**
	 * Update last Opportunity activity on the related Accounts
	 *
	 * @param accountIds The account Ids of the records to update
	 */
	public void updateOpportunityActivity(Set<Id> accountIds)
	{
		fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();

		IAccounts accounts = (IAccounts) Application.Domain.newInstance( accountIds );

		accounts.updateOpportunityActivity();

		uow.registerDirty(accounts.getRecords());
		uow.commitWork();
	}
}
