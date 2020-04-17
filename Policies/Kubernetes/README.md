# Kubernetes Polices
Here are sample files for building Azure Policy for Kubernetes policy defintions.

> [!NOTE]
> 
> Azure Policy for Kubernetes is in Preview and only supports built-in policy definitions at this time.

To onboard to Azure policy for AKS, please refer:
- [Azure Policy for AKS](https://aka.ms/akspolicydoc)
- [Azure Policy for AKS Engine](https://aka.ms/kubepolicydoc)

## Contents
These policies consist of the [OPA Constraint Framework](https://github.com/open-policy-agent/frameworks/tree/master/constraint) constraint template and constraint YAML artifacts used by [Gatekeeper v3](https://github.com/open-policy-agent/gatekeeper), the json files used to configure the [Azure Policy](https://aka.ms/akspolicydoc) definition files, and positive and negative example kubernetes resources.

# Tests
Inside the `rego/` folder in each policy, is the source rego and unit tests. These unit tests can be run via the [Open Policy Agent](https://www.openpolicyagent.org/docs/latest/) command line tool.

Run this command from the folder of the policy under test.
```
opa test -v rego/src.rego rego/src_test.rego
```

[Install Open Policy Agent](https://www.openpolicyagent.org/docs/latest/#running-opa).