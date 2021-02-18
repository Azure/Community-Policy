# Remote Debugging Should be Turned Off for Web Applications

This folder contains a set of 3 policies which used in combination should ensure that remote debugging is turned off for web app. Since the remoteDebuggingEnabled property is optional in the ARM deployment, a combination of 3 policies are required to ensure true compliance in the environment.

## Web-App-Remote-Debugging-Off-DINE

This policy uses a deployIfNotExists effect to set the remoteDebuggingEnabled property to "false" if it is true.

## Web-App-Remote-Debugging-Off-Deny

This policy uses a deny effect to prevent changing the remoteDebuggingEnabled property to true after it has been set to false.  

*Note this policy will not give us the true compliance data for the remoteDebuggingEnabled property as the compliance requires us to evaulate resources of type Microsoft.Web/sites/config but the deny requires a resource of type Microsoft.Web/sites.*

## Web-App-Remote-Debugging-Off-Audit

This policy will give the true compliance data for the remoteDebuggingEnabled property for web apps in your environment.
