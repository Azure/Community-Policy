# Prevent Deletion of Private DNS Zone

This policy definition prevents the deletion of private DNS zones in Azure, using the DenyAction effect. It serves as an alternative to using CanNotDelete resource locks to prevent the deletion of Private DNS Zones that are used with private endpoints. It's important to note that this policy does not prevent the deletion of child resources (i.e. the DNS Zone records themselves).  

