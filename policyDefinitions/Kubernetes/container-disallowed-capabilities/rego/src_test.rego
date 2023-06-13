package k8sazureblockcapabilities

test_input_wildcard_block {
    input := { "review": input_review([cadd(["one", "two"])]), "parameters": {"disallowedCapabilities": ["*"]}}
    results := violation with input as input
    count(results) == 1
}
test_input_wildcard_block_container_x2 {
    input := { "review": input_review([cadd(["one", "two"]), cadd(["three"])]), "parameters": {"disallowedCapabilities": ["*"]}}
    results := violation with input as input
    count(results) == 2
}
test_input_one_blocked {
    input := { "review": input_review([cadd(["one"])]), "parameters": {"disallowedCapabilities": ["one"]}}
    results := violation with input as input
    count(results) == 1
}
test_input_one_blocked_container_x2 {
    input := { "review": input_review([cadd(["one"]), cadd(["one"])]), "parameters": {"disallowedCapabilities": ["one"]}}
    results := violation with input as input
    count(results) == 2
}
test_input_two_blocked_container_x2 {
    input := { "review": input_review([cadd(["one"]), cadd(["two"])]), "parameters": {"disallowedCapabilities": ["one", "two"]}}
    results := violation with input as input
    count(results) == 2
}
test_input_two_blocked_two_used_container_x2 {
    input := { "review": input_review([cadd(["one", "two"]), cadd(["one", "two"])]), "parameters": {"disallowedCapabilities": ["one", "two"]}}
    results := violation with input as input
    count(results) == 2
}
test_input_all_allowed {
    input := { "review": input_review([cadd(["one"])]), "parameters": {"disallowedCapabilities": []}}
    results := violation with input as input
    count(results) == 0
}
test_input_all_allowed_undefined {
    input := { "review": input_review([cadd(["one"])]), "parameters": {}}
    results := violation with input as input
    count(results) == 0
}
test_input_all_allowed_undefined_x2 {
    input := { "review": input_review([cadd(["one", "two"]), cadd(["three", "two"])]), "parameters": {}}
    results := violation with input as input
    trace(sprintf("results are: %v", [results]))
    count(results) == 0
}
test_input_one_allowed {
    input := { "review": input_review([cadd(["three"])]), "parameters": {"disallowedCapabilities": ["one"]}}
    results := violation with input as input
    count(results) == 0
}
test_input_mixed_allowed {
    input := { "review": input_review([cadd(["one"]), cadd(["three", "two"])]), "parameters": {"disallowedCapabilities": ["one"]}}
    results := violation with input as input
    count(results) == 1
}
test_input_mixed_allowed_x2 {
    input := { "review": input_review([cadd(["one"]), cadd(["three", "two"])]), "parameters": {"disallowedCapabilities": ["one", "two"]}}
    results := violation with input as input
    count(results) == 2
}
test_input_empty_seccontext_empty_add {
    input := { "review": empty_input_review, "parameters": {"disallowedCapabilities": []}}
    results := violation with input as input
    count(results) == 0
}
test_input_empty_seccontext_required_add {
    input := { "review": empty_input_review, "parameters": {"disallowedCapabilities": ["one"]}}
    results := violation with input as input
    count(results) == 0
}

# init containers
test_input_all_blocked {
    input := { "review": input_init_review([cadd(["one", "two"])]), "parameters": {"disallowedCapabilities": ["*"]}}
    results := violation with input as input
    count(results) == 1
}
test_input_all_blocked_container_x2 {
    input := { "review": input_init_review([cadd(["one", "two"]), cadd(["three"])]), "parameters": {"disallowedCapabilities": ["*"]}}
    results := violation with input as input
    count(results) == 2
}
test_input_one_blocked {
    input := { "review": input_init_review([cadd(["one"])]), "parameters": {"disallowedCapabilities": ["one"]}}
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

input_review(containers) = output {
    cs := [o | c := containers[i]; o := inject_name(i, c)]
    output = {
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

input_init_review(containers) = output {
    cs := [o | c := containers[i]; o := inject_name(i, c)]
    output = {
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

cadd(add) = output {
  output := {
    "securityContext": {
     "capabilities": {
       "add": add
     }
    }
  }
}
inject_name(name, obj) = out {
  keys := {k | obj[k]}
  all_keys := keys | {"name"}
  out := {k: v | k := all_keys[_]; v:= get_default(obj, k, name)}
}
