@RestResource(UrlMapping='/opportunities/*/applydiscount')

global with sharing class OpportunitiesResource 

{

	@HttpPost
	
	// e.g. https://ue2.salesforce.com/services/apexrest/opportunities/006b0000003u4Ln/applydiscount?discount=10
	
	global static void applyDiscount()
	
	{
    	// Take apart the URI to discover the Opportunity Id
        RestRequest req = RestContext.request;
		
		String[] uriParts = req.requestURI.split('/');
		
		// Determine service parameter values from REST context
		Id opportunityId = uriParts[2]; // get from URL path
		
		String discountParam = req.params.get('discount');
		
		Decimal discountPercent = discountParam!=null ? Decimal.valueOf(discountParam) : 0;
		
		// Call Service Method
		
		OpportunitiesService.applyDiscounts(new Set<Id> { opportunityId }, discountPercent );
	}
}
