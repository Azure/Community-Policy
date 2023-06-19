The deployifnotexists-defender-for-vm policy will run a scan of all subscriptions in your tenant to identify the one's wthout defender for servers enabled. 
Once this is identified, the deployment condition will flip the tier of security setting for defender for vm from free to standard tier. 
The region and scope can be specified in paramter file.
