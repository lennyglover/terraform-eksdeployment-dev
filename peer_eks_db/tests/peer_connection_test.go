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

	fmt.Println("in peer_connection_test.Test_Main")

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

		validatePeerConnection(t, workingDir)
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
//Validate the resources - check peer connection ID begins with pcx & status is active
func validatePeerConnection(t *testing.T, workingDir string) bool {

	terraformOptions := test_structure.LoadTerraformOptions(t, workingDir)

	connectionID := terraform.Output(t, terraformOptions, "peer_connection_id")
	goodFormat := assert.Contains(t, connectionID, "pcx-")

	peerStatus := terraform.Output(t, terraformOptions, "peer_connection_status")
	goodStatus := assert.Equal(t, "active", peerStatus)

	// all have to pass
	return (goodFormat && goodStatus)
}
