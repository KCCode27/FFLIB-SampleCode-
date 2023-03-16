public class InvoicingServiceImpl implements IInvoicingService 
{
	/**
	 * Generate invoices for the given source records (so long as their domain classes implement ISupportInvoicing)
	 **/
	 
	public List<Id> generate(List<Id> sourceRecordIds)
	{
		// Create unit of work to capture work and commit it under one transaction
		
		fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();
		
		// Invoicing Factory helps domain classes produce invoices
		
		InvoicingService.InvoiceFactory invoiceFactory = new InvoicingService.InvoiceFactory(uow);
		
		// Construct domain class capabile of performing invoicing
		fflib_IDomain domain =
			Application.Domain.newInstance(
				Application.Selector.selectById(new Set<Id>(sourceRecordIds)));
		if (domain instanceof InvoicingService.ISupportInvoicing)
		{ 
			// Ask the domain object to generate its invoices
			InvoicingService.ISupportInvoicing invoicing = (InvoicingService.ISupportInvoicing) domain;
			invoicing.generate(invoiceFactory);	
			// Commit generated invoices to the database		
			uow.commitWork();
			// List of Invoices generated
			List<Id> invoiceIds = new List<Id>();
			for (Invoice__c invoice : invoiceFactory.Invoices)
			{
				invoiceIds.add(invoice.Id);
			}
			return invoiceIds;
		}
		
		// Related Domain object does not support the ability to generate invoices
		throw new fflib_Application.ApplicationException('Invalid source object for generating invoices.');		
	}
}
