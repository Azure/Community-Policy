package k8sazuremanagehostnamespace

test_input_empty_hostnamespace_not_allowed {
    input := { "review": input_review(null, null), "parameters": params(false, false)}
    results := violation with input as input
    count(results) == 0
}
test_input_restricted_hostnamespace_not_allowed {
    input := { "review": input_review(false, false), "parameters": params(false, false)}
    results := violation with input as input
    count(results) == 0
}
test_input_hostPID_not_allowed {
    input := { "review": input_review(true, null), "parameters": params(false, false)}
    results := violation with input as input
    count(results) == 1
}
test_input_hostIPC_not_allowed {
    input := { "review": input_review(null, true), "parameters": params(false, false)}
    results := violation with input as input
    count(results) == 1
}
test_input_hostnamespace_both_not_allowed {
    input := { "review": input_review(true, true), "parameters": params(false, false)}
    results := violation with input as input
    count(results) == 1
}

test_input_empty_hostnamespace_allowed {
    input := { "review": input_review(null, null), "parameters": params(true, true)}
    results := violation with input as input
    count(results) == 0
}
test_input_restricted_hostnamespace_allowed {
    input := { "review": input_review(false, false), "parameters": params(true, true)}
    results := violation with input as input
    count(results) == 0
}
test_input_hostPID_allowed {
    input := { "review": input_review(true, null), "parameters": params(true, true)}
    results := violation with input as input
    count(results) == 0
}
test_input_hostIPC_allowed {
    input := { "review": input_review(null, true), "parameters": params(true, true)}
    results := violation with input as input
    count(results) == 0
}
test_input_hostnamespace_both_allowed {
    input := { "review": input_review(true, true), "parameters": params(true, true)}
    results := violation with input as input
    count(results) == 0
}

test_input_empty_hostnamespace_PID_allowed {
    input := { "review": input_review(null, null), "parameters": params(true, false)}
    results := violation with input as input
    count(results) == 0
}
test_input_restricted_hostnamespace_PID_allowed {
    input := { "review": input_review(false, false), "parameters": params(true, false)}
    results := violation with input as input
    count(results) == 0
}
test_input_hostPID_PID_allowed {
    input := { "review": input_review(true, null), "parameters": params(true, false)}
    results := violation with input as input
    count(results) == 0
}
test_input_hostIPC_PID_allowed {
    input := { "review": input_review(null, true), "parameters": params(true, false)}
    results := violation with input as input
    count(results) == 1
}
test_input_hostnamespace_both_PID_allowed {
    input := { "review": input_review(true, true), "parameters": params(true, false)}
    results := violation with input as input
    count(results) == 1
}

test_input_empty_hostnamespace_IPC_allowed {
    input := { "review": input_review(null, null), "parameters": params(false, true)}
    results := violation with input as input
    count(results) == 0
}
test_input_restricted_hostnamespace_IPC_allowed {
    input := { "review": input_review(false, false), "parameters": params(false, true)}
    results := violation with input as input
    count(results) == 0
}
test_input_hostPID_IPC_allowed {
    input := { "review": input_review(true, null), "parameters": params(false, true)}
    results := violation with input as input
    count(results) == 1
}
test_input_hostIPC_IPC_allowed {
    input := { "review": input_review(null, true), "parameters": params(false, true)}
    results := violation with input as input
    count(results) == 0
}
test_input_hostnamespace_both_IPC_allowed {
    input := { "review": input_review(true, true), "parameters": params(false, true)}
    results := violation with input as input
    count(results) == 1
}

test_input_empty_hostnamespace_empty_params {
    input := { "review": input_review(null, null), "parameters": params(null, null)}
    results := violation with input as input
    count(results) == 0
}
test_input_restricted_hostnamespace_empty_params {
    input := { "review": input_review(false, false), "parameters": params(null, null)}
    results := violation with input as input
    count(results) == 0
}
test_input_hostPID_empty_params {
    input := { "review": input_review(true, null), "parameters": params(null, null)}
    results := violation with input as input
    count(results) == 1
}
test_input_hostIPC_empty_params {
    input := { "review": input_review(null, true), "parameters": params(null, null)}
    results := violation with input as input
    count(results) == 1
}
test_input_hostnamespace_both_empty_params {
    input := { "review": input_review(true, true), "parameters": params(null, null)}
    results := violation with input as input
    count(results) == 1
}

input_review(hostPID, hostIPC) = out {
  pid_obj := obj_if_exists("hostPID", hostPID)
  ipc_obj := obj_if_exists("hostIPC", hostIPC)
  containerObj := {
    "containers": [{
        "name": "nginx",
        "image": "nginx"
    }]
  }
  spec := object.union(object.union(containerObj, pid_obj), ipc_obj)
  out := {
    "object": {
      "metadata": {
        "name": "nginx"
      },
      "spec": spec
    }
  }
}

params(hostPID, hostIPC) = out {
  allowed_pid := obj_if_exists("allowedHostPID", hostPID)
  allowed_ipc := obj_if_exists("allowedHostIPC", hostIPC)
  out = object.union(allowed_pid, allowed_ipc)
}

obj_if_exists(key, val) = out {
 not is_null(val)
 out := { key: val }
}
obj_if_exists(key, val) = out {
 is_null(val)
 out := {}
}
