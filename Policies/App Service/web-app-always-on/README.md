# Web App Always On

This folder contains a set of 3 policies which used in combination should ensure that your web app is always on. Since the alwaysOn property is optional in the ARM deployment, a combination of 3 policies are required to ensure true compliance in the environment.

## Web-App-Always-On-DINE

This policy uses a deployIfNotExists effect to set the alwaysOn property to "true" if it is false.

## Web-App-Always-On-Deny

This policy uses a deny effect to prevent changing the alwaysOn property to false after it has been set to true.  

*Note this policy will not give us the true compliance data for the alwaysOn property as the compliance requires us to evaulate resources of type Microsoft.Web/sites/config but the deny requires a resource of type Microsoft.Web/sites.*

## Web-App-Always-On-Audit

This policy will give the true compliance data for the alwaysOn property for web apps in your environment.
