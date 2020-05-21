package k8sazureprocmount

violation[{"msg": msg, "details": {}}] {
    c := input_containers[_]
    not input_proc_mount_type_allowed(c)
    msg := sprintf("ProcMount type is not allowed, container: %v. Allowed procMount types: %v", [c.name, input.parameters.procMountType])
}

input_proc_mount_type_allowed(c) {
    lower(input.parameters.procMountType) == lower(c.securityContext.procMount)
}

input_containers[c] {
    c := input.review.object.spec.containers[_]
    c.securityContext.procMount
}

input_containers[c] {
    c := input.review.object.spec.initContainers[_]
    c.securityContext.procMount
}
