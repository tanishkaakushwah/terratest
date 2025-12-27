package test
import (
    "testing"
    "time"
    "github.com/gruntwork-io/terratest/modules/terraform"
    "github.com/gruntwork-io/terratest/modules/http-helper"
)

func TestTerraformDev(t *testing.T) {

    tf := &terraform.Options{
        TerraformDir: "../terraform/environments/dev",
    }

    defer terraform.Destroy(t, tf)
    terraform.InitAndApply(t, tf)
// test case 1
    output := terraform.OutputMap(t, tf, "resource_group_names")

    if len(output) == 0 {
        t.Fatal("resource_group_names should not be empty")
    }
// test case 2
    publicIP := terraform.Output(t, tf, "frontend_public_ip")

    url := "http://" + publicIP

    // Retry because VM + nginx may take time to be ready
    maxRetries := 10
    timeBetweenRetries := 15 * time.Second

    http_helper.HttpGetWithRetryWithCustomValidation(
        t,
        url,
        nil,
        maxRetries,
        timeBetweenRetries,
        func(status int, body string) bool {
            return status == 200
        },
    )
}
