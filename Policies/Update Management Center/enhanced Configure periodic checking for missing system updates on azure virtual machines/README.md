# Enhanced Configure periodic checking for missing system updates on azure virtual machines

This custom policy is **enhancing** Microsofts Configure auto-assessment (every 24 hours) for OS updates on native Azure virtual machines. You can control the scope of assignment according to machine subscription, resource group, location or tags. Learn more about this for Windows: https://aka.ms/computevm-windowspatchassessmentmode, for Linux: https://aka.ms/computevm-linuxpatchassessmentmode.

The Microsoft provided built-in policy for Azure Update Management Center lacks of the possibility to define multiple possible tag-values for the same tag-key. This prohibits the strategy to enable periodic checking for missing system updates on VMs that belong to one of the "valid" update schedules.

Many organizations pre-define possible update schedules like "wave1", "wave2" or "Dev", "Test" and "Prod". The current implementation of Microsofts policy does not allow to apply the policy to all VMs belonging to one of those update schedules. That is why I enhanced this policy with the logic from another Microsoft policy ("[Preview]: Schedule recurring updates using Update Management Center") which allows the definition of an array of possible tag-values for the same key which are then combined with a logical OR operator via the tagOperator "Any". This approach also supports the "All" (or logical AND) operator.

In Microsofts policy, you would have to define something like this as a tags parameter (which does not work of course).
{
    'UpdateWave': 'Alpha',
    'UpdateWave': 'Beta',
    'UpdateWave': 'Production1-AP',
}

With my modified policy this now becomes possible as you could define the tag filter as follows:
[
    {
        "key": "UpdateWave",
        "value": "Alpha"
    },
    {
        "key": "UpdateWave",
        "value": "Beta"
    },
    {
        "key": "UpdateWave",
        "value": "Production1-EU"
    }
]


