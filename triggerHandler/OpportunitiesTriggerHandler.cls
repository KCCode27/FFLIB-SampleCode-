public class OpportunitiesTriggerHandler extends fflib_SObjectDomain
{
	public OpportunitiesTriggerHandler(List<Opportunity> sObjectList)
	{
		// Domain classes are initialised with lists to enforce bulkification throughout
		super(sObjectList);
	}

	public override void onApplyDefaults()
	{
		// Apply defaults to OpportunityTriggerHandler
		for(Opportunity opportunity : (List<Opportunity>) this.records)
		{
			opportunity.DiscountType__c = OpportunitySettings__c.getInstance().DiscountType__c;
		}
	}

	public override void onValidate()
	{
		// Validate OpportunityTriggerHandler
		for(Opportunity opp : (List<Opportunity>) this.records)
		{
			if(opp.Type != null && opp.Type.startsWith('Existing') && opp.AccountId == null)
			{
				opp.AccountId.addError( error('You must provide an Account for OpportunityTriggerHandler for existing Customers.', opp, Opportunity.AccountId) );
			}
		}
	}

	public override void onValidate(Map<Id,SObject> existingRecords)
	{
		// Validate changes to OpportunityTriggerHandler
		for (Opportunity opp : (List<Opportunity>) this.records)
		{
			Opportunity existingOpp = (Opportunity) existingRecords.get(opp.Id);
			if (opp.Type != existingOpp.Type)
			{
				opp.Type.addError( error('You cannot change the Opportunity type once it has been created.', opp, Opportunity.Type) );
			}
		}
	}

	public override void onAfterInsert()
	{
		updateOpportunityActivityOnAccount();
	}

	private void updateOpportunityActivityOnAccount()
	{
		Set<Id> accountIds =
				Opportunities.newInstance(this.records)
						.getAccountIds();

		if (accountIds.isEmpty()) return;

		AccountsService.updateOpportunityActivity(accountIds);
	}

	public class Constructor implements fflib_SObjectDomain.IConstructable
	{
		public fflib_SObjectDomain construct(List<SObject> sObjectList)
		{
			return new OpportunitiesTriggerHandler(sObjectList);
		}
	}
}
