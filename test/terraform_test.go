package test

import (
    "testing"

    "github.com/gruntwork-io/terratest/modules/terraform"
)

func TestTerraformDev(t *testing.T) {

    tf := &terraform.Options{
        TerraformDir: "../terraform/environments/dev",
    }

    defer terraform.Destroy(t, tf)
    terraform.InitAndApply(t, tf)

	output := terraform.Output(t, tf, "resource_group_name")
if output == "" {
    t.Fatal("resource_group_name should not be empty")
}
}
