package k8spsphostnetworkingports

violation[{"msg": msg, "details": {}}] {
	container := input_containers[_]
    input_share_hostnetwork(container)
    msg := sprintf("The specified hostNetwork and hostPort are not allowed, pod: %v, container: %v. Allowed values: %v", [input.review.object.metadata.name, container.name, input.parameters])
}

input_share_hostnetwork(container) {
    not input.parameters.allowHostNetwork
    input.review.object.spec.hostNetwork
}

input_share_hostnetwork(container) {
    hostPort := container.ports[_].hostPort
    hostPort < input.parameters.minPort
}

input_share_hostnetwork(container) {
    hostPort := container.ports[_].hostPort
    hostPort > input.parameters.maxPort
}

input_containers[c] {
    c := input.review.object.spec.containers[_]
}

input_containers[c] {
    c := input.review.object.spec.initContainers[_]
}
