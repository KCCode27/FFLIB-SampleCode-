public class OpportunitiesServiceImpl implements IOpportunitiesService
{


	public void applyDiscounts(Set<Id> opportunityIds, Decimal discountPercentage)
	{
		applyDiscounts(
				OpportunitiesSelector.newInstance().selectByIdWithProducts(opportunityIds),
				discountPercentage);
	}
	
	

	public void applyDiscounts(List<Opportunity> opportunitiesWithProducts, Decimal discountPercentage)
	{
		applyDiscounts(
				Opportunities.newInstance(opportunitiesWithProducts),
				discountPercentage
		);
	}
	
	

	private void applyDiscounts(IOpportunities opportunitiesWithProducts, Decimal discountPercentage)
	{
		// Create unit of work to capture work and commit it under one transaction
	    fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();

		// applyDiscounts(uow, opportunitiesWithProducts, discountPercentage);
		opportunitiesWithProducts.applyDiscount(discountPercentage, uow);

		// Commit updates to opportunities
		uow.commitWork();
	}

	public Set<Id> createInvoices(Set<Id> opportunityIds, Decimal discountPercentage)
	{
		// Create unit of work to capture work and commit it under one transaction
	    fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();
	    										
		// Query Opportunities
		IOpportunities opps = 
			Opportunities.newInstance(
				OpportunitiesSelector.newInstance().selectByIdWithProducts(opportunityIds));		
		
		// Optionally apply discounts as part of invoice creation
		if (discountPercentage != null && discountPercentage > 0)
		{
			opps.applyDiscount(discountPercentage, uow);
		}
		
		// Create Invoices from the given opportunities
		List<SObject> invoices = new List<SObject>();
		for (Opportunity opportunityRecord : (List<Opportunity>) opps.getRecords())
		{
			Invoice__c invoice = new Invoice__c();
			invoice.Account__c = opportunityRecord.AccountId;
			invoice.Description__c = opportunityRecord.Description;
			invoice.InvoiceDate__c = opportunityRecord.CloseDate;
			invoice.Opportunity__c = opportunityRecord.Id;
			uow.registerNew(invoice);
			for (OpportunityLineItem lineItem : opportunityRecord.OpportunityLineItems)
			{
				InvoiceLine__c invoiceLineItem = new InvoiceLine__c();
				invoiceLineItem.Description__c = lineItem.Description;
				invoiceLineItem.Product__c = lineItem.PricebookEntry.Product2Id;
				invoiceLineItem.UnitPrice__c = lineItem.UnitPrice;
				invoiceLineItem.Quantity__c = lineItem.Quantity;
				uow.registerNew(invoiceLineItem, InvoiceLine__c.Invoice__c, invoice);
			}
			invoices.add(invoice);
		}
		
		// Commit any Opportunity updates and new invoices
		uow.commitWork();									
		
		// Invoice Ids
		Set<Id> invoiceIds = new Set<Id>();
		for (SObject invoice : invoices)
		{
			invoiceIds.add((Id) invoice.get('Id'));
		}
		return invoiceIds;
	}
	
	public Id submitInvoicingJob()
	{
		// Submit the job via Batch Apex, 
		//   service layer can perform validations and updates such as logging etc on behalf of client
		//   also configure scope size, knowledge of the class to use etc is encapsulated in the service		
		return Database.executeBatch(new CreateInvoicesJob());		
	}
}
