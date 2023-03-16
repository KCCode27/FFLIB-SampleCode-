public with sharing abstract class AbstractChargeable extends fflib_SObjectDomain
	                                                  
{
	public AbstractChargeable(List<SObject> records)
	{
		super(records);
	}
	
	public abstract Schema.SObjectField getCostOfHoursWorkedField();
	 
	public abstract List<Integer> calculateHoursWorked();
	
	public override void onBeforeInsert()
	{
		updateCostOfHoursWorked();		
	}
	
	public override void onBeforeUpdate(Map<Id,SObject> existingRecords)
	{
		updateCostOfHoursWorked();
	}			
	
	public void updateCostOfHoursWorked()
	{
		List<Integer> hoursWorked = calculateHoursWorked();
		
		Schema.SObjectField costOfHoursWorkedField = getCostOfHoursWorkedField();
		
		Integer hoursWorkedRecordIdx = 0; 
		
		for(SObject record : this.records)
		{
			record.put(costOfHoursWorkedField, hoursWorked[hoursWorkedRecordIdx++] * 100);	
		}
	}
}
