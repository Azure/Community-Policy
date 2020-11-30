package k8sazureblockautomounttoken

test_input_automount_false {
    input := { "review": input_review_automount_false }
    results := violation with input as input
    count(results) == 0
}
test_input_automount_true {
    input := { "review": input_review_automount_true}
    results := violation with input as input
    count(results) == 1
}
test_input_automount_empty {
    input := { "review": input_review_automount_empty}
    results := violation with input as input
    count(results) == 1
}

input_review_automount_false = {
    "object": {
        "metadata": {
            "name": "nginx"
        },
        "spec": {
            "serviceAccountName": "test-account",
            "automountServiceAccountToken": false,
            "containers": [{
              "name": "nginx",
              "image": "nginx",
          }]
        }
    }
}

input_review_automount_true = {
    "object": {
        "metadata": {
            "name": "nginx"
        },
        "spec": {
            "serviceAccountName": "test-account",
            "automountServiceAccountToken": true,
            "containers": [{
              "name": "nginx",
              "image": "nginx",
          }]
        }
    }
}

input_review_automount_empty = {
    "object": {
        "metadata": {
            "name": "nginx"
        },
        "spec": {
            "serviceAccountName": "test-account",
            "containers": [{
              "name": "nginx",
              "image": "nginx",
          }]
        }
    }
}
