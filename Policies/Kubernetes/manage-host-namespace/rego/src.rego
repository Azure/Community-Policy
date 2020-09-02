package k8sazuremanagehostnamespace

violation[{"msg": msg, "details": {}}] {
    input_invalid_hostnamespace(input.review.object)
    msg := sprintf("Host namespace settings are not allowed: %v. Allowed values: { hostPID: %v, hostIPC: %v }", [input.review.object.metadata.name, get_bool_param("allowedHostPID"), get_bool_param("allowedHostIPC")])
}

input_invalid_hostnamespace(o) {
    o.spec.hostPID
    not get_bool_param("allowedHostPID")
}
input_invalid_hostnamespace(o) {
    o.spec.hostIPC
    not get_bool_param("allowedHostIPC")
}

get_bool_param(key) = out {
  not input.parameters
  out = false
}
get_bool_param(key) = out {
  not input.parameters[key]
  out = false
}
get_bool_param(key) = out {
  out = input.parameters[key]
}
