public with sharing class DeveloperWorkItems extends AbstractChargeable
	
{
	public static IDeveloperWorkItems newInstance(List<DeveloperWorkItem__c> recordList)
	{
		return (IDeveloperWorkItems) Application.Domain.newInstance(recordList);
	}

	public static IDeveloperWorkItems newInstance(Set<Id> recordIdSet)
	{
		return (IDeveloperWorkItems) Application.Domain.newInstance(recordIdSet);
	}
	
	public DeveloperWorkItems(List<DeveloperWorkItem__c> workItems)
	{
		super(workItems);
	}
	
	public override Schema.SObjectField getCostOfHoursWorkedField()
	{
		// Field base class will populate once it has calculated the cost
		return DeveloperWorkItem__c.DeveloperCost__c;
	}
	 
	public override List<Integer> calculateHoursWorked()
	{
		// Calculate the hours worked for each record
		List<Integer> hoursWorked = new List<Integer>(); 
		for(DeveloperWorkItem__c workItem : (List<DeveloperWorkItem__c>) this.records)
		{
			// This calculation is intentionally simplistic for illustration purposes
			hoursWorked.add((Integer)  
				(workItem.CodingHours__c + 
				 workItem.CodeReviewingHours__c + 
				 workItem.TechnicalDesignHours__c));
		}
		return hoursWorked;
	}	
	
	public class Constructor implements fflib_SObjectDomain.IConstructable
	{
		public fflib_SObjectDomain construct(List<SObject> sObjectList)
		{
			return new DeveloperWorkItems(sObjectList);
		}
	}	
}
