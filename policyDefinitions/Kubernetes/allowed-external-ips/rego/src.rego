package k8sazureexternalips

violation[{"msg": msg}] {
  input.review.kind.kind == "Service"
  input.review.kind.group == ""
  allowedIPs := {ip | ip := input.parameters.allowedIPs[_]}
  externalIPs := {ip | ip := input.review.object.spec.externalIPs[_]}
  forbiddenIPs := externalIPs - allowedIPs
  count(forbiddenIPs) > 0
  msg := sprintf("service has forbidden external IPs: %v", [forbiddenIPs])
}
