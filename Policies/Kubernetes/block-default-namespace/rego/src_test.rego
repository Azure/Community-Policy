package k8sazureblockdefault

test_input_resource_pod_no_namespace {
    input := { "review": input_review_pod_no_ns }
    results := violation with input as input
    count(results) == 1
}
test_input_resource_pod_default_namespace {
    input := { "review": input_review_pod_default_ns }
    results := violation with input as input
    count(results) == 1
}
test_input_resource_pod_other_namespace {
    input := { "review": input_review_pod_other_ns }
    results := violation with input as input
    count(results) == 0
}
test_input_resource_secret_no_namespace {
    input := { "review": input_review_secret_no_ns }
    results := violation with input as input
    count(results) == 1
}
test_input_resource_secret_default_namespace {
    input := { "review": input_review_secret_default_ns }
    results := violation with input as input
    count(results) == 1
}
test_input_resource_secret_other_namespace {
    input := { "review": input_review_secret_other_ns }
    results := violation with input as input
    count(results) == 0
}

input_review_pod_no_ns = {
    "object": {
        "kind": "Pod",
        "metadata": {
            "name": "nginx"
        },
        "spec": {
            "containers": [{
              "name": "nginx",
              "image": "nignx"
            }]
        }
    }
}
input_review_pod_default_ns = {
    "object": {
        "kind": "Pod",
        "metadata": {
            "name": "nginx",
            "namespace": "default"
        },
        "spec": {
            "containers": [{
              "name": "nginx",
              "image": "nignx"
            }]
        }
    }
}
input_review_pod_other_ns = {
    "object": {
        "kind": "Pod",
        "metadata": {
            "name": "nginx",
            "namespace": "test-namespace"
        },
        "spec": {
            "containers": [{
              "name": "nginx",
              "image": "nignx"
            }]
        }
    }
}

input_review_secret_no_ns = {
    "object": {
        "kind": "Secret",
        "metadata": {
            "name": "nginx"
        },
        "type": "Opaque",
        "data": {
          "token": "secret-token"
        }
    }
}
input_review_secret_default_ns = {
    "object": {
        "kind": "Secret",
        "metadata": {
            "name": "nginx",
            "namespace": "default"
        },
        "type": "Opaque",
        "data": {
          "token": "secret-token"
        }
    }
}
input_review_secret_other_ns = {
    "object": {
        "kind": "Secret",
        "metadata": {
            "name": "nginx",
            "namespace": "test-namespace"
        },
        "type": "Opaque",
        "data": {
          "token": "secret-token"
        }
    }
}
