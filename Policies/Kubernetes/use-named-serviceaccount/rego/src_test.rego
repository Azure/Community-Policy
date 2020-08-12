package k8sazurenamedserviceaccount

test_input_service_account_with_automount {
    input := { "review": input_review }
    results := violation with input as input
    count(results) == 0
}
test_input_no_service_account {
    input := { "review": input_review_no_serviceaccount }
    results := violation with input as input
    count(results) == 1
}
test_input_service_account_no_automount {
    input := { "review": input_review_no_serviceaccount_no_automount }
    results := violation with input as input
    count(results) == 1
}
test_input_service_account_true_automount {
    input := { "review": input_review_no_serviceaccount_true_automount }
    results := violation with input as input
    count(results) == 1
}

input_review = {
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

input_review_no_serviceaccount = {
    "object": {
        "metadata": {
            "name": "nginx"
        },
        "spec": {
            "containers": [{
              "name": "nginx",
              "image": "nginx",
          }]
        }
    }
}

input_review_no_serviceaccount_no_automount = {
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

input_review_no_serviceaccount_true_automount = {
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
