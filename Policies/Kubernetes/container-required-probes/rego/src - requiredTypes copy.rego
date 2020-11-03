package k8sazurecontainerprobesrequired

violation[{"msg": msg}] {
  container := input.review.object.spec.containers[_]
  probe := input.parameters.probes[_]
  probe_is_missing(container, probe)
  msg := sprintf("Container %v has is missing required probe %v. Required probes: %v", [container.name, probe, input.parameters.probes])
}

violation[{"msg": msg}] {
  container := input.review.object.spec.containers[_]
  probe := input.parameters.probes[_]
  container[probe][probe_type]
  not probe_matches_allowed(probe_type)
  msg := sprintf("Container %v is using disallowed probe type %v. Allowed types: %v", [container.name, probe_type, input.parameters.probeTypes])
}

probe_is_missing(ctr, probe) {
  not ctr[probe]
}

probe_matches_allowed(probe_type) {
  probe_type == input.parameters.probeTypes[_]
}
