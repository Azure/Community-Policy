package k8sazurecontainerprobesrequired

violation[{"msg": msg}] {
  container := input.review.object.spec.containers[_]
  probe := input.parameters.probes[_]
  probe_is_missing(container, probe)
  msg := sprintf("Container %v has is missing required probe %v. Required probes: %v", [container.name, probe, input.parameters.probes])
}

probe_is_missing(ctr, probe) {
  not ctr[probe]
}
probe_is_missing(ctr, probe) {
  not is_object(ctr[probe])
}
