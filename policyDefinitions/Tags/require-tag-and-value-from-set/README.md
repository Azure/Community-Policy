# Require Tag Name and Value From Set

This custom Azure Policy will deny a user from creating a resource if it does not include a specified tag name and a value from a predetermined set of values. 

When assigning this policy I used “Environment” for the tag name and chose all 3 options ([“Dev”, “Test”, “Prod”]) for possible values (when assigning the policy to a specified scope you can choose a subset or all of the values in the list of allowedValues that was specifie din the policy definition.

To get this dropdown during the policy assignment process, I included these values in the “allowedValues” list for “tagValue”. 

For each unique tag you want to create in your environment it would make sense to make multiple copies of this policy definition so that you can customize the list of “allowedValues” for each tag name (the tag name is something that is determined during the time the policy is assigned).

In this particular example, if I did not include the “Env” tag or chose a value that wasn’t in [“Dev”, “Test”, “Prod”], validation failed as expected. While unfortunately there is not a way to create a “dropdown” or auto populate the required tag names, if validation fails taking a look at the raw error can easily show us what is causing the deployment to fail. 

