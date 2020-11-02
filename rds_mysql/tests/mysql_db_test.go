package test

import (
	"fmt"
	"testing"
    "strconv"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/stretchr/testify/assert"
)

// Main function, define stages and run.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Entry point has to be declared like this - func TestXxx(*testing.T) - must have upper case T
func Test_Main(t *testing.T) {
	t.Parallel()

	fmt.Println("in mysql_db_test.Test_Main")

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

		validateRDSInstance(t, workingDir)
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
//Validate the resources - instance ID, instance status, endpoint, port
func validateRDSInstance(t *testing.T, workingDir string) bool {
	terraformOptions := test_structure.LoadTerraformOptions(t, workingDir)

	instanceID := terraform.Output(t, terraformOptions, "rds_instance_id")
    awsRegion := terraform.Output(t, terraformOptions, "aws_region")

    // Check port
    requestedPort := terraform.Output(t, terraformOptions, "requested_port")
    expectedPort, err := strconv.Atoi(requestedPort)
    if err != nil {
        // may as well fail....
        return false
    }    
	instancePort := aws.GetPortOfRdsInstance(t, instanceID, awsRegion)
	goodPort := assert.Equal(t, int64(expectedPort), instancePort)
       
	// check RDS instance status
	instanceStatus := terraform.Output(t, terraformOptions, "rds_instance_status")
	goodStatus := assert.Equal(t, "available", instanceStatus)

	// check endpoint exists in region
	instanceAddress := aws.GetAddressOfRdsInstance(t, instanceID, awsRegion)
	goodAddress := assert.NotNil(t, instanceAddress)


	// all have to pass
	return (goodStatus && goodAddress && goodPort)
}
