# Configure Diagnostic Settings for all Web App Service Plan SKUs

## Azure Policy Definition Requirements `[intent]`:
*Contoso requires the ability to enable all diagnostic settings for Web Apps. The problem to overcome is Premium App Service Plans have two additional diagnostic settings vs Standard App Service Plans: "AppServiceFileAuditLogs" & "AppServiceAntivirusScanAuditLogs". The App Service Plan is a different resource in Azure from the Web App we will be targeting with this policy, so how do we reference the App Service Plan's SKU to know what diagnostic settings to install on the Web App and avoid an error on Standard App Service Plans for attempting to install diagnostic settings that are not available? (hint: reference() template function)*

> **DISCLAIMER:** This is a custom policy definition. This is **not** a built-in policy definition published by Microsoft and therefore carries no warranty or official support expectation. Please always fully understand your custom Azure Policy Definitions, and only publish to production after testing in your own **unique** environment!

## Scope:
This policy will involve the resource type `Microsoft.Web/sites` and a reference to `Microsoft.Web/serverfarms`.
> Sites Template Documentation: https://learn.microsoft.com/en-us/azure/templates/microsoft.web/sites?pivots=deployment-language-arm-template

> ServerFarms Template Documentation: https://learn.microsoft.com/en-us/azure/templates/microsoft.web/serverfarms?pivots=deployment-language-arm-template

## Functions:
This policy definition utilizes the following Azure Policy and Azure Resource Manager Template functions to accomplish this task:
> `reference()`: https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/template-functions-resource#reference

> `toLower()`: https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/template-functions-string#tolower

> `replace()`: https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/template-functions-string#replace

> `field()`: https://learn.microsoft.com/en-us/azure/governance/policy/concepts/definition-structure#:~:text=days%20to%20add-,field(fieldname),-fieldName%3A%20%5BRequired%5D%20string

> `parameters()`: https://learn.microsoft.com/en-us/azure/governance/policy/samples/pattern-parameters

> `concat()`: https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/template-functions-string#concat

> `if()`: https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/template-functions-logical#if

> `contains()`: https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/template-functions-string#contains

> `variables()`: https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/template-functions-deployment#variables

> `count()`: https://learn.microsoft.com/en-us/azure/governance/policy/samples/pattern-count-operator

> `copyIndex()`: https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/template-functions-numeric#copyindex

> `allOf:[]`: https://learn.microsoft.com/en-us/azure/governance/policy/concepts/definition-structure#logical-operators

> `not:{}`: https://learn.microsoft.com/en-us/azure/governance/policy/concepts/definition-structure#logical-operators

> `Copy:[]`: https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/copy-properties

## Assignment Parameters
> `"effect"`   
> Can be entered as a `string` in the Policy Assignment.  
>
> Options:
> > "DeployIfNotExists" 
> 
> > "Disabled"
>
> `

> `"logsEnabled"`   
> Can be entered as an `string / bool` in the Policy Assignment.
> Used to enable diagnostic logs if `True`.
>
> Options:
> > "True"
> 
> > "False"
> 
> `

> `"metricsEnabled"`   
> Can be entered as an `string / bool` in the Policy Assignment.
> Used to enable diagnostic metrics if `True`.
>
> Options:
> > "True"
> 
> > "False"
> 
> `

> `"profileName"`   
> Can be entered as a `string` in the Policy Assignment. Used to name your Diagnostic Settings resource.
>
> DefaultValue:
> > "EnabledByPolicy"
> 
> `

> `"logAnalytics"`   
> Chosen in the Policy Assignment from a dropdown of available workspaces.
>
> **Special Note:**
> If this workspace is outside of the scope of the assignment you must manually grant 'Log Analytics Contributor' permissions (or similar) to the policy assignment's principal ID on the workspace or deployments / remediation will fail."
> 
> `

## The Break Down
---

Starting from the top!
```json
"mode": "All", 
```
We are using `"All"` because it is recommended to default to `"All"` unless you have a reason to use `"Indexed"`
> Documentation: https://learn.microsoft.com/en-us/azure/governance/policy/concepts/definition-structure#mode  

---  

We will skip the initial `parameters` in the break down because they are discussed above.

---

Next lets dive into our `"policyRule"` we will start with the `"if": {}` statement before moving on to the `"then": {}` section. 

### **"if": {}**
In our `if: {}` statement our only Logical Operator is `"allOf": []` meaning that all statements in the following array must return true for the Policy to evaluate as **non-compliant** and the `"then": {}` statement to execute.

We will go one by one through the statements contained in our `"allOf": []` array.
```json
"if": {
    "allOf": [
        {
        "equals": "Microsoft.Web/sites",
        "field": "type"
        },
        {
        "field": "kind",
        "notContains": "functionapp"
        },
        {
        "field": "kind",
        "notContains": "linux"
        }
    ]
},
```

The first condition is setting our resource type scope for what Policy is checking. Using the `"field": "type"` condition is a great way to keep Azure Policy from wasting time checking resources that we are not targeting. This condition is simple and returns true or false if the Azure Resource type equals the specified string.
```json
{
    "field": "type",
    "equals": "Microsoft.Web/sites"
}
```

The next section of our if statement is another field check for `kind`, this is applicable to "Microsoft.Web/sites" because both web apps and function apps use the same underlying resources. So, there is a field on this resource type to identify the kind of resource. With this policy we are only targeting web apps and therefore we are using this statement to exclude function apps. 

```json
{
    "field": "kind",
    "notContains": "functionapp"
},
```

The final section is checking the same `kind` field again, this time to validate the App Service / App Service Plan is running on Windows. At the time of creating this Policy Definition, App Service Diagnostic Setting Logs are not available for Linux App Service Plans. 
```json
{
    "field": "kind",
    "notContains": "linux"
}
```

To read more about the `kind` property please see: [App Service Kind Property Documentation](https://github.com/Azure/app-service-linux-docs/blob/master/Things_You_Should_Know/kind_property.md)

---

If all three qualifying statements in the `allOf[]` logical operator return `true`, then the `allOf[]` will return `true`. This will have the `if:{}` block return `true` as well. When the `if:{}` returns `true` this means the resource is [applicable](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/policy-applicability) to the policy definition and the `then:{}` will be executed.

---

This being a `DeployIfNotExists` Policy Effect Definition, the `then:{}` statement can be quite large compared to other Effects. The specifics for the deployment resource is contained in the `details` object of the `then:{}` statement. Other than the `details` object the other top level key is `effect` which is set by parameter to either `DeployIfNotExists` or `Disabled`.

```json
"then": {
    "effect": "[parameters('effect')]",
    "details": {...}
}
```

If this effect is set to `DeployIfNotExists` then the `details` object will be used to make the changes either automatically on a new resource deployment or by [remediation task](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/remediate-resources?tabs=azure-portal).

The details object contains important information for additional validation through the `existenceCondition` object, the deployment ARM template in the `deployment` object and the top level properties for the `details` object. 

In the code below we can see the direct properties of the `details` object. We can first see the key named `type` and the value of `Microsoft.Insights/diagnosticSettings`. This is the child resource type we want to add to the parent resource `Microsoft.Web/sites`.

Next we have the `name` key, which is using the parameter `profileName` to set for the name of the diagnosticSettings resource. 

Finally we have the `roleDefinitionsIds:[]` array, this is required for any policy effect that needs to take action or make a deployment in your environment. This field uses fully qualified [Built-In RBAC Roles](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles) to grant permissions to your Assignment's [Managed Identity](https://learn.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/overview). The role we are using here is `b24988ac-6180-42a0-ab88-20f7382dd24c` which translates to `Contributor`. 

```json
"details": {
    "type": "Microsoft.Insights/diagnosticSettings",
    "name": "[parameters('profileName')]",
    "roleDefinitionIds": [
        "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
    ],
    "existenceCondition": {...},
    "deployment": {...}
}
```


Next we will look at the `existenceCondition` which is a special object that can be used in `DeployIfNotExists` and `AuditIfNotExists` Effect policy to validate resources on the child resource `Microsoft.Insights/diagnosticSettings` similar to what we did for the parent resource `Microsoft.Web/sites` in the `if:{}` section. 

The major difference between the `existenceCondition` and the `if:{}` statement is the `existenceCondition` will trigger the deployment object if it returns `false` because the desired state we put into the `existenceCondition` does not exist on the resource. Therefore, we need to deploy to bring our resource to match our desired state.

Zooming into the existence condition below we can see we see our friend the `allOf:[]` Logical Operator. Just like before, if all conditions within the `allOf:[]` logical operator return `true`, the logical operator will return `true`. If even one condition returns `false`, the logical operator will return `false`. Because this is an `existenceCondition` we will need the `allOf:[]` logical operator to return `false` for the deployment to execute.

```json
"existenceCondition": {
    "allOf": [
        {
            "not": {
                "count": {
                    "field": "Microsoft.Insights/diagnosticSettings/logs[*]",
                    "where": {
                    "notEquals": "[parameters('logsEnabled')]",
                    "field": "Microsoft.Insights/diagnosticSettings/logs[*].enabled"
                    }
                },
                "greater": 0
            }
        },
        {
            "not": {
                "count": {
                    "field": "Microsoft.Insights/diagnosticSettings/metrics[*]",
                    "where": {
                    "notEquals": "[parameters('metricsEnabled')]",
                    "field": "Microsoft.Insights/diagnosticSettings/metrics[*].enabled"
                    }
                },
                "greater": 0
            }
        }
    ]
},
```


Our first condition involves an array property for `Microsoft.Insights/diagnosticSettings/logs[*]`. To iterate over the array property we will use the `count` functionality.

Because the goal of this policy is to enable/disable all logs, if the parameter `logsEnabled` is set to `true` or `false`, it will iterate through all `Microsoft.Insights/diagnosticSettings/logs[*].enabled` and see if the field matches the parameter value. If it does not equal, it will increase the `count` by `1`. We then use the condition `greater` to validate that the available `logs[*].enabled` are matching the parameter `logsEnabled` by making sure our count is `0`. 

```json
{
    "count": {
        "field": "Microsoft.Insights/diagnosticSettings/logs[*]",
        "where": {
            "notEquals": "[parameters('logsEnabled')]",
            "field": "Microsoft.Insights/diagnosticSettings/logs[*].enabled"
        }
    },
    "greater": 0
},
```
This functionality will work to detect any logs not matching the configured parameter `logsEnabled` in the `if:{}` statement. But for the `existenceCondition` it would return the opposite of what we want. This is because if all logs are set to match the parameter `logsEnabled` the logic above will return `false` because our `count` does not increase for matched types. If we return `false` to the `existenceCondition` it will trigger the deployment. So, in this instance we actually want to wrap the condition with a `not:{}` logical operator to invert the result.

This technique was chosen so if any logs are not set to match the desired configuration it will be flagged and trigger a deployment. 

```json
"allOf": [
{
    "not": {
        "count": {
            "field": "Microsoft.Insights/diagnosticSettings/logs[*]",
            "where": {
                "notEquals": "[parameters('logsEnabled')]",
                "field": "Microsoft.Insights/diagnosticSettings/logs[*].enabled"
            }
        },
        "greater": 0
    }
},
{...}
]
```

The next condition should look familiar, it is the same as the one we did for logs, just for the metrics diagnostic settings. 
```json
"allOf": [
    {...},
    {
        "not": {
        "count": {
            "field": "Microsoft.Insights/diagnosticSettings/metrics[*]",
            "where": {
            "notEquals": "[parameters('metricsEnabled')]",
            "field": "Microsoft.Insights/diagnosticSettings/metrics[*].enabled"
            }
        },
        "greater": 0
        }
    }
]
```
And that finishes our `existenceCondition`, if either of the diagnostic settings checks returns `false` then the deployment will trigger. 


## The Deployment
Finally, on to the fun part the `deployment` object. 

The `deployment` object in this policy definition has a special trick. Typically, the `reference()` template function would not be allowed for use in an Azure Policy `DeployIfNotExists` Effect Policy Definition. Yet, in our case because different SKU's for App Service Plans contain different available diagnostic settings we need to be able to `reference` the App Service Plan SKU from our Web App resource deployment. 

To accomplish this need, we are going to nest a second ARM Template inside our `DeployIfNotExistsPolicy`'s primary ARM Template. This is a work around we can take advantage of to use normally restricted ARM Template functions. 

[View Restricted ARM Template Functions](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/definition-structure#policy-functions)

[What is a nested ARM template?](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/linked-templates?tabs=azure-powershell#nested-template)


First we set up our `deployment properties`, this is where we configure our deployment `mode` and the `parameters` we will pass into the ARM Template.

One **important** `parameter` to point out is the `serverFarm` parameter that is using the `field('Microsoft.Web/sites/serverFarmId')` reference to get the resourceId of the `App Service Plan` for this `Web App` resource. 

```json
"deployment": {
    "properties": {
        "mode": "incremental",
        "parameters": {
            "location": {
            "value": "[toLower(replace(field('location'), ' ',''))]"
            },
            "logsEnabled": {
            "value": "[parameters('logsEnabled')]"
            },
            "metricsEnabled": {
            "value": "[parameters('metricsEnabled')]"
            },
            "profileName": {
            "value": "[parameters('profileName')]"
            },
            "resourceName": {
            "value": "[field('name')]"
            },
            "serverFarm": {
            "value": "[field('Microsoft.Web/sites/serverFarmId')]"
            },
            "logAnalytics": {
            "value": "[parameters('logAnalytics')]"
            }
        },
        "template": {...}
    }
}
```

Next we dive into the `primary template` for this `deployment`. 
This template sets the `parameter` values that will be accepted by the template (should match what we are passing in from the deployment). 

```json
"template": {
            "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
            "contentVersion": "1.0.0.0",
            "parameters": {
                "location": {
                    "type": "string"
                },
                "logsEnabled": {
                    "type": "string"
                },
                "metricsEnabled": {
                    "type": "string"
                },
                "profileName": {
                    "type": "string"
                },
                "resourceName": {
                    "type": "string"
                },
                "serverFarm": {
                    "type": "string"
                },
                "logAnalytics": {
                    "type": "string"
                }
            },
            "resources": [...Nested Template...]
        }
```

Next we can start work on our nested template through the `resources` array of the primary template. We will be using the `variables` and `parameters` from the primary template in the nested template. 

In the following template, you can see we are specifying the `Microsoft.Resources/deployments` resource as a `nestedDeployment` in the `name` field.

We then set up our `parameters` for the nested deployment to pass to our nested template. 
Within the parameters section of the deployment we can see the `sku` parameter that is performing the `reference()` ARM template function to return the `sku.tier` of the App Service Plan we specify in the `serverFarm` variable. 

The `reference()` arguments are first the Resource Id from the `serverFarm` parameter, then the API Version `2022-03-01` we are using to query the resource and finally we are requesting the `Full` resource details be returned. Outside of the `reference()` function we then specify the `.sku.tier` to be saved into the `sku` parameter for use. 

```json
"resources": [
{
    "apiVersion": "2018-02-01",
    "type": "Microsoft.Resources/deployments",
    "name": "nestedDeployment",
    "properties": {
    "mode": "Incremental",
    "expressionEvaluationOptions": {
        "scope": "inner"
    },
    "parameters": {
        "location": {
        "value": "[parameters('location')]"
        },
        "logsEnabled": {
        "value": "[parameters('logsEnabled')]"
        },
        "metricsEnabled": {
        "value": "[parameters('metricsEnabled')]"
        },
        "profileName": {
        "value": "[parameters('profileName')]"
        },
        "resourceName": {
        "value": "[parameters('resourceName')]"
        },
        "sku": {
        "value": "[reference(parameters('serverFarm'), '2022-03-01','Full').sku.tier]"
        },
        "logAnalytics": {
        "value": "[parameters('logAnalytics')]"
        }
    },
    "template": {...}
    }
}
]
```

Finally, we have drilled down far enough to find the ARM template that does the work. 

First, we set up our parameters to accept the values from the nested deployment above.

Then, we set up our `variables` object and specify all available log names with the `logNamesOrderSpecific` variable that will be referenced in our nested template's resource array. 

> Note: it is very important that the two additional diagnostic settings available to Premium SKUs are at the end of the array by index or this will not function. This variable is index/sort/order specific. 

After setting the `variables` we then start the `resources` array on the nested template that will complete the deployment of the resources. 

```json
   "template": {
        "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
        "contentVersion": "1.0.0.0",
        "parameters": {
        "location": {
            "type": "string"
        },
        "logsEnabled": {
            "type": "string"
        },
        "metricsEnabled": {
            "type": "string"
        },
        "profileName": {
            "type": "string"
        },
        "resourceName": {
            "type": "string"
        },
        "sku": {
            "type": "string"
        },
        "logAnalytics": {
            "type": "string"
        }
        },
        "variables": {
        "logNamesOrderSpecific": [
            "AppServiceHTTPLogs",
            "AppServiceConsoleLogs",
            "AppServiceAppLogs",
            "AppServiceAuditLogs",
            "AppServiceIPSecAuditLogs",
            "AppServicePlatformLogs",
            "AppServiceFileAuditLogs",
            "AppServiceAntivirusScanAuditLogs"
        ]
        },
        "resources": [...]
    }
```

In the resources array, we are deploying a single resource which is our diagnostic settings resource. 

In this resource's configuration the `copy:[]` element is used with the Properties Syntax to configure the correct log settings based on the SKU we queried earlier. 

The `count` key for the `copy` element is set by an `if()` function that checks the `sku` parameter. If the `sku` string contains the word `Premium` it means all logs are available to this web app, so all `8` indexes are used from our `logNamesOrderSpecific` variable. If the `sku` does not contain the word `Premium` then only the first `6` indexes of the `logNamesOrderSpecific` variable are used because that is all that is available to the non-premium web app. 

The `input` of our `copy` element contains the specifics for how the diagnostics logs should be configured. 
The `category` is set by taking the current index of the `copy` iteration loop using the `copyIndex()` function and applying that index value to the `logNamesOrderSpecific` variable. 

Finally, we have the metrics, right now there is only the choice for `AllMetrics` or none, so the `metricsEnabled` parameter will be used to set if the `AllMetrics` field is `true` or `false`.

```json
"resources": [
    {
        "apiVersion": "2021-05-01-preview",
        "dependsOn": [],
        "location": "[parameters('location')]",
        "name": "[concat(parameters('resourceName'), '/', 'Microsoft.Insights/', parameters('profileName'))]",
        "properties": {
        "workspaceId": "[parameters('logAnalytics')]",
        "copy": [
            {
                "name": "logs",
                "count": "[if(contains(parameters('sku'), 'Premium'),8,6)]",
                "input": {
                    "category": "[variables('logNamesOrderSpecific')[copyIndex('logs')]]",
                    "enabled": "[parameters('logsEnabled')]"
                }
            }
        ],
        "metrics": [
            {
                "category": "AllMetrics",
                "enabled": "[parameters('metricsEnabled')]"
            }
        ]
        },
        "type": "Microsoft.Web/sites/providers/diagnosticSettings"
    }
]
```

### Credits
I cannot take credit for creating this technique and it took collaboration from many engineers on my team to develop this policy definition.
I did offer to write the documentation and get it published to the community policies repository for people to reference.