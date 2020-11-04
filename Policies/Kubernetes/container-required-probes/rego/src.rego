package k8sazurecontainerprobesrequired

violation[{"msg": msg}] {
  container := input_containers[_]
  probe := input.parameters.requiredProbes[_]
  probe_is_missing(container, probe)
  msg := sprintf("Container %v is missing required probe %v. Required probes: %v", [container.name, probe, input.parameters.requiredProbes])
}

probe_is_missing(ctr, probe) {
  not ctr[probe]
}
probe_is_missing(ctr, probe) {
  not is_object(ctr[probe])
}

input_containers[c] {
  c := input.review.object.spec.containers[_]
}
input_containers[c] {
  c := input.review.object.spec.initContainers[_]
}
