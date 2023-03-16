public class UsersSelector extends    fflib_SObjectSelector
	                       implements IUsersSelector
{
	public static IUsersSelector newInstance()
	{
		return (IUsersSelector) Application.Selector.newInstance(User.SObjectType);
	}
		
	public List<Schema.SObjectField> getSObjectFieldList()
	{
		// Current app requirements driven solely by getUsersEmail at this stage
		return new List<Schema.SObjectField> { User.Email };
	}

	public Schema.SObjectType getSObjectType()
	{
		return User.SObjectType;
	}
	
	/**
	 * Queries given user records and maps the user Ids to assigned email addresses
	 **/		
	public Map<Id, String> getUsersEmail(Set<Id> userIds)
	{
		List<User> users = selectSObjectsById(userIds);
		
		Map<Id, String> emailsById = new Map<Id, String>();
		
		for (User user : users)
		{
			emailsById.put(user.Id, user.Email);
		}
		return emailsById;	
	}
}
