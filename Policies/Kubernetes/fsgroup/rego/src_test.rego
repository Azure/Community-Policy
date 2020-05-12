package k8sazurefsgroup

test_input_fsgroup_allowed_all {
    input := { "review": input_review_with_fsgroup, "parameters": input_parameters_runasany}
    results := violation with input as input
    count(results) == 0
}
test_input_no_fsgroup_allowed_all {
    input := { "review": input_review, "parameters": input_parameters_runasany}
    results := violation with input as input
    count(results) == 0
}
test_input_fsgroup_allowed_all_with_range {
    input := { "review": input_review_with_fsgroup, "parameters": input_parameters(anyrun, [range_in_range])}
    results := violation with input as input
    count(results) == 0
}
test_input_no_fsgroup_allowed_all_with_range_outofrange {
    input := { "review": input_review, "parameters": input_parameters(anyrun, [range_outofrange])}
    results := violation with input as input
    count(results) == 0
}
test_input_fsgroup_MustRunAs_allowed {
    input := { "review": input_review_with_fsgroup, "parameters": input_parameters(mustrun, [range_in_range])}
    results := violation with input as input
    count(results) == 0
}
test_input_fsgroup_MustRunAs_not_allowed {
    input := { "review": input_review_with_fsgroup, "parameters": input_parameters(mustrun, [range_outofrange])}
    results := violation with input as input
    count(results) == 1
}
test_input_no_fsgroup_MustRunAs_not_allowed {
    input := { "review": input_review, "parameters": input_parameters(mustrun, [range_in_range])}
    results := violation with input as input
    count(results) == 1
}
test_input_securitycontext_no_fsgroup_MustRunAs_not_allowed {
    input := { "review": input_review_with_securitycontext_no_fsgroup, "parameters": input_parameters(mustrun, [range_in_range])}
    results := violation with input as input
    count(results) == 1
}
test_input_fsgroup_MayRunAs_allowed {
    input := { "review": input_review_with_fsgroup, "parameters": input_parameters(mayrun, [range_in_range])}
    results := violation with input as input
    count(results) == 0
}
test_input_fsgroup_MayRunAs_not_allowed {
    input := { "review": input_review_with_fsgroup, "parameters": input_parameters(mayrun, [range_outofrange])}
    results := violation with input as input
    count(results) == 1
}
test_input_no_fsgroup_MayRunAs_allowed {
    input := { "review": input_review, "parameters": input_parameters(mayrun, [range_in_range])}
    results := violation with input as input
    count(results) == 0
}
test_input_securitycontext_no_fsgroup_MayRunAs_allowed {
    input := { "review": input_review_with_securitycontext_no_fsgroup, "parameters": input_parameters(mayrun, [range_in_range])}
    results := violation with input as input
    count(results) == 0
}
test_input_fsgroup_MayRunAs_two_ranges_allowed {
    input := { "review": input_review_with_fsgroup, "parameters": input_parameters(mayrun, [range_outofrange, range_high_range])}
    results := violation with input as input
    count(results) == 0
}
test_input_fsgroup_MayRunAs_two_ranges_not_allowed {
    input := { "review": input_review_with_fsgroup, "parameters": input_parameters(mayrun, [range_outofrange, range_high_range_outofrange])}
    results := violation with input as input
    count(results) == 1
}
test_input_no_fsgroup_MayRunAs_two_ranges_allowed {
    input := { "review": input_review, "parameters": input_parameters(mayrun, [range_in_range, range_high_range])}
    results := violation with input as input
    count(results) == 0
}
test_input_fsgroup_MustRunAs_allowed_two_ranges {
    input := { "review": input_review_with_fsgroup, "parameters": input_parameters(mustrun, [range_outofrange, range_high_range])}
    results := violation with input as input
    count(results) == 0
}
test_input_fsgroup_MustRunAs_not_allowed_two_ranges {
    input := { "review": input_review_with_fsgroup, "parameters": input_parameters(mustrun, [range_outofrange, range_high_range_outofrange])}
    results := violation with input as input
    count(results) == 1
}
test_input_no_fsgroup_MustRunAs_not_allowed_two_ranges {
    input := { "review": input_review, "parameters": input_parameters(mustrun, [range_outofrange, range_high_range])}
    results := violation with input as input
    count(results) == 1
}


input_review = {
    "object": {
        "metadata": {
            "name": "nginx"
        },
        "spec": {
            "containers": input_containers_one,
            "volumes": input_volumes
      }
    }
}

input_review_with_fsgroup = {
    "object": {
        "metadata": {
            "name": "nginx"
        },
        "spec": {
            "securityContext": {
              "fsGroup": 2000
            },
            "containers": input_containers_one,
            "volumes": input_volumes
      }
    }
}

input_review_with_securitycontext_no_fsgroup = {
    "object": {
        "metadata": {
            "name": "nginx"
        },
        "spec": {
            "securityContext": {
              "runAsUser": "1000"
            },
            "containers": input_containers_one,
            "volumes": input_volumes
      }
    }
}

input_containers_one = [
{
    "name": "nginx",
    "image": "nginx",
    "volumeMounts":[
    {
        "mountPath": "/cache",
        "name": "cache-volume"
    }]
}]

input_volumes = [
{
    "name": "cache-volume",
    "emptyDir": {}
}]

input_parameters_runasany = {
     "rule": anyrun
}

input_parameters(rule, ranges) = {
    "rule": rule,
    "ranges": ranges
}

mustrun = "MustRunAs"
mayrun = "MayRunAs"
anyrun = "RunAsAny"

range_in_range = {
    "min": 1,
    "max": 2000
}

range_outofrange = {
    "min": 1,
    "max": 1000
}

range_high_range = {
    "min": 1200,
    "max": 2000
}

range_high_range_outofrange = {
    "min": 2100,
    "max": 4000
}
