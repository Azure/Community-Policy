package k8sazureforbiddensysctls

violation[{"msg": msg, "details": {}}] {
    sysctl := input.review.object.spec.securityContext.sysctls[_].name
    forbiddin_sysctl(sysctl)
    msg := sprintf("The sysctl %v is not allowed, pod: %v. Forbidden sysctls: %v", [sysctl, input.review.object.metadata.name, input.parameters.forbiddenSysctls])
}

# * may be used to forbid all sysctls
forbiddin_sysctl(sysctl) {
    input.parameters.forbiddenSysctls[_] == "*"
}

forbiddin_sysctl(sysctl) {
    input.parameters.forbiddenSysctls[_] == sysctl
}

forbiddin_sysctl(sysctl) {
    startswith(sysctl, trim(input.parameters.forbiddenSysctls[_], "*"))
}
