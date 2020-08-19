package k8sazureblockcapabilities

violation[{"msg": msg}] {
  container := input_containers[_]
  has_disallowed_capabilities(container)
  msg := sprintf("container <%v> has a disallowed capability. Allowed capabilities are %v", [container.name, get_default(input.parameters, "disallowedCapabilities", [])])
}

has_disallowed_capabilities(container) {
  input.parameters.disallowedCapabilities[_] == container.securityContext.capabilities.add[_]
}
has_disallowed_capabilities(container) {
  input.parameters.disallowedCapabilities[_] == "*"
}

get_default(obj, param, _default) = out {
  out = obj[param]
}

get_default(obj, param, _default) = out {
  not obj[param]
  not obj[param] == false
  out = _default
}
input_containers[c] {
    c := input.review.object.spec.containers[_]
}
input_containers[c] {
    c := input.review.object.spec.initContainers[_]
}
