package k8sazureblockdefault

violation[{"msg": msg}] {
  obj := input.review.object
  is_default_namespace(obj.metadata)
  msg := sprintf("Usage of the default namespace is not allowed, name: %v, kind: %v", [obj.metadata.name, obj.kind])
}

is_default_namespace(metadata) {
  not metadata.namespace
}

is_default_namespace(metadata) {
  metadata.namespace == "default"
}
