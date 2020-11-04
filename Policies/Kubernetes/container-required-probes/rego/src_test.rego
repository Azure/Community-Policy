package k8sazurecontainerprobesrequired

test_input_one_required_one_existing {
    input := { "review": review([cont([p("livenessProbe")])]), "parameters": {"requiredProbes": ["livenessProbe"]}}
    results := violation with input as input
    count(results) == 0
}
test_input_one_required_none_existing {
    input := { "review": review([cont([])]), "parameters": {"requiredProbes": ["livenessProbe"]}}
    results := violation with input as input
    count(results) == 1
}
test_input_one_required_empty_existing {
    input := { "review": review([cont([empty("livenessProbe")])]), "parameters": {"requiredProbes": ["livenessProbe"]}}
    results := violation with input as input
    count(results) == 1
}
test_input_one_required_empty_input {
    input := { "review": empty_input_review, "parameters": {"requiredProbes": ["livenessProbe"]}}
    results := violation with input as input
    count(results) == 1
}
test_input_two_required_two_existing {
    input := { "review": review([cont([p("livenessProbe"), p("readinessProbe")])]), "parameters": {"requiredProbes": ["livenessProbe", "readinessProbe"]}}
    results := violation with input as input
    count(results) == 0
}
test_input_two_required_one_existing {
    input := { "review": review([cont([p("livenessProbe")])]), "parameters": {"requiredProbes": ["livenessProbe", "readinessProbe"]}}
    results := violation with input as input
    count(results) == 1
}
test_input_two_required_none_existing {
    input := { "review": review([cont([])]), "parameters": {"requiredProbes": ["livenessProbe", "readinessProbe"]}}
    results := violation with input as input
    count(results) == 2
}
test_input_two_required_empty_existing {
    input := { "review": review([cont([empty("livenessProbe"), empty("readinessProbe")])]), "parameters": {"requiredProbes": ["livenessProbe", "readinessProbe"]}}
    results := violation with input as input
    count(results) == 2
}
test_input_two_required_mixed_existing {
    input := { "review": review([cont([p("livenessProbe"), empty("readinessProbe")])]), "parameters": {"requiredProbes": ["livenessProbe", "readinessProbe"]}}
    results := violation with input as input
    count(results) == 1
}
test_input_two_required_three_existing {
    input := { "review": review([cont([p("livenessProbe"), p("readinessProbe"), p("startupProbe")])]), "parameters": {"requiredProbes": ["livenessProbe", "readinessProbe"]}}
    results := violation with input as input
    count(results) == 0
}
test_input_two_required_empty_input {
    input := { "review": empty_input_review, "parameters": {"requiredProbes": ["livenessProbe", "readinessProbe"]}}
    results := violation with input as input
    count(results) == 2
}
test_input_one_required_one_existing_two_containers {
    input := { "review": review([cont([p("livenessProbe")]), cont([p("livenessProbe")])]), "parameters": {"requiredProbes": ["livenessProbe"]}}
    results := violation with input as input
    count(results) == 0
}
test_input_one_required_none_existing_two_containers {
    input := { "review": review([cont([]), cont([])]), "parameters": {"requiredProbes": ["livenessProbe"]}}
    results := violation with input as input
    count(results) == 2
}
test_input_two_required_mixed_existing_two_containers {
    input := { "review": review([cont([p("livenessProbe"), p("readinessProbe")]), cont([p("livenessProbe")])]), "parameters": {"requiredProbes": ["livenessProbe", "readinessProbe"]}}
    results := violation with input as input
    count(results) == 1
}
test_input_two_required_mixed_existing_two_containers_1 {
    input := { "review": review([cont([p("livenessProbe")]), cont([p("readinessProbe")])]), "parameters": {"requiredProbes": ["livenessProbe", "readinessProbe"]}}
    results := violation with input as input
    count(results) == 2
}
test_input_none_required_two_existing {
    input := { "review": review([cont([p("livenessProbe"), p("readinessProbe")])]), "parameters": {"requiredProbes": []}}
    results := violation with input as input
    count(results) == 0
}
test_input_none_required_none_existing {
    input := { "review": review([cont([])]), "parameters": {"requiredProbes": []}}
    results := violation with input as input
    count(results) == 0
}
test_input_none_required_empty_existing {
    input := { "review": review([cont([empty("livenessProbe")])]), "parameters": {"requiredProbes": []}}
    results := violation with input as input
    count(results) == 0
}
# Init
test_input_init_one_required_one_existing {
    input := { "review": init_review([cont([p("livenessProbe")])]), "parameters": {"requiredProbes": ["livenessProbe"]}}
    results := violation with input as input
    count(results) == 0
}
test_input_init_one_required_none_existing {
    input := { "review": init_review([cont([])]), "parameters": {"requiredProbes": ["livenessProbe"]}}
    results := violation with input as input
    count(results) == 1
}
test_input_init_one_required_empty_existing {
    input := { "review": init_review([cont([empty("livenessProbe")])]), "parameters": {"requiredProbes": ["livenessProbe"]}}
    results := violation with input as input
    count(results) == 1
}



empty_input_review = {
    "object": {
        "metadata": {
            "name": "nginx"
        },
        "spec": {
            "containers": [{
                "name": "nginx",
                "image": "nginx"
            }],
        }
    }
}

review(containers) = out {
    cs := [o | c := containers[i]; o := inject_name(i, c)]
    out = {
      "object": {
        "metadata": {
            "name": "nginx"
        },
        "spec": {
            "containers": cs,
        }
      }
     }
}

init_review(containers) = out {
    cs := [o | c := containers[i]; o := inject_name(i, c)]
    out = {
      "object": {
        "metadata": {
            "name": "nginx"
        },
        "spec": {
            "initContainers": cs,
        }
      }
     }
}

mock_probe = {
  "httpGet": {
    "path": "/pathz",
    "port": 9090
  }
}
cont(probes) = out {
  out := {k: v | probe := probes[_]; probe[k]; v := probe[k]}
}
p(probe_name) = out {
  out := { probe_name: mock_probe }
}
empty(probe_name) = out {
  out := { probe_name: null }
}
inject_name(name, obj) = out {
  out := object.union(obj, {
    "name": name,
  })
}
