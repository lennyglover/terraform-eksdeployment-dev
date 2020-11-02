package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
    "github.com/stretchr/testify/assert"
)

// Main function, define stages and run.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Entry point has to be declared like this - func TestXxx(*testing.T) - must have upper case T
func Test_Main(t *testing.T) {
	t.Parallel()

	fmt.Println("in cluster_test.Test_Main")

	// set directory containing Terraform code
	workingDir := "..//"
	terraformBinary := "terragrunt"

	// At the end of the test, destroy deployed resources
	defer test_structure.RunTestStage(t, "cleanup", func() {
		fmt.Println("in RunTestStage - cleanup")
		destroyResources(t, workingDir)
	})

	// Deploy resources with Terraform
	test_structure.RunTestStage(t, "deploy", func() {
		fmt.Println("in RunTestStage - deploy")
		deployResources(t, workingDir, terraformBinary)
	})

	// Validate
	test_structure.RunTestStage(t, "validate", func() {
		fmt.Println("in RunTestStage - validate")
		validateEKSCluster(t, workingDir)
	})
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Deploy the resources using Terraform
func deployResources(t *testing.T, workingDir string, terraformBinary string) {

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformBinary: terraformBinary,
		TerraformDir:    workingDir,
	}

	// Save the Terraform Options struct, instance name, and instance text so future test stages can use it
	test_structure.SaveTerraformOptions(t, workingDir, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Destroy the resources
func destroyResources(t *testing.T, workingDir string) {

	// Load the Terraform Options saved by the earlier deploy_terraform stage
	terraformOptions := test_structure.LoadTerraformOptions(t, workingDir)
	terraform.Destroy(t, terraformOptions)
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Validate the resources - check cluster_endpoint, cluster_security_group_id, kubectl_config
func validateEKSCluster(t *testing.T, workingDir string) bool {

	terraformOptions := test_structure.LoadTerraformOptions(t, workingDir)

	// check cluster_endpoint
	clusterEndpoint := terraform.Output(t, terraformOptions, "cluster_endpoint")
    goodEndpoint := assert.NotNil(t, clusterEndpoint)

	// check cluster_security_group_id
	clusterSecGroup := terraform.Output(t, terraformOptions, "cluster_security_group_id")
	goodSecGroupID := assert.NotNil(t, clusterSecGroup)

	// check kubectl_config
	kubCtlConfig := terraform.Output(t, terraformOptions, "kubectl_config")
	goodKubConfig := assert.NotNil(t, kubCtlConfig)

	// all have to pass
	return (goodEndpoint && goodSecGroupID && goodKubConfig)
}
