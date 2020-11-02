package test

import (
	"fmt"
	"testing"
    "strings"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

// Main function, define stages and run.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Entry point has to be declared like this - func TestXxx(*testing.T) - must have upper case T
func Test_Main(t *testing.T) {
	t.Parallel()

	fmt.Println("in vpc_test.Test_Main")

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

		//set test parameters
		awsRegionOutput := "aws_region"
		vpcIDOutput := "vpc_id"
		privateSubnetsOutput := "vpc_private_subnets_deployed"
		publicSubnetsOutput := "vpc_public_subnets_deployed"
        privateSubnetsInput := "vpc_private_subnets_requested"
        publicSubnetsInput := "vpc_public_subnets_requested"

		validateVPC(t, workingDir, awsRegionOutput, vpcIDOutput, privateSubnetsInput, publicSubnetsInput, privateSubnetsOutput, publicSubnetsOutput)
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
//Validate the resources - check VPC subnets total, private, public?
func validateVPC(t *testing.T,
	workingDir string,
	awsRegionOutput string,
	vpcIDOutput string,
	privateSubnetsInput string,
	publicSubnetsInput string,
	privateSubnetsOutput string,
	publicSubnetsOutput string) {

	terraformOptions := test_structure.LoadTerraformOptions(t, workingDir)
	vpcID := terraform.Output(t, terraformOptions, vpcIDOutput)
    awsRegion := terraform.Output(t, terraformOptions, awsRegionOutput)

	// did we get all the subnets we asked for?
    // these were requested
    privateSubnetsExpected := terraform.Output(t, terraformOptions, privateSubnetsInput)
    publicSubnetsExpected := terraform.Output(t, terraformOptions, publicSubnetsInput)
    count_privateSubnetsExpectedArray := stringArrayCountElements(privateSubnetsExpected)
    count_publicSubnetsExpectedArray := stringArrayCountElements(publicSubnetsExpected)
    count_totalSubnetsExpected := count_privateSubnetsExpectedArray + count_publicSubnetsExpectedArray
                
    // and these were deployed
	deployedSubnets := aws.GetSubnetsForVpc(t, vpcID, awsRegion)
    count_deployedSubnets := len(deployedSubnets)
    
    // the numbers should add up
    //fmt.Printf("%d\n", count_totalSubnetsExpected)
    //fmt.Printf("%d\n", count_deployedSubnets)
	require.Equal(t, count_totalSubnetsExpected, count_deployedSubnets)

    // those deployed public should actually be public
	for _, subnetID := range terraform.OutputList(t, terraformOptions, publicSubnetsOutput) {
		fmt.Println(publicSubnetsOutput, " - ", subnetID)
		assert.True(t, aws.IsPublicSubnet(t, subnetID, awsRegion))
	}

    // likewise for private subnets
	for _, subnetID := range terraform.OutputList(t, terraformOptions, privateSubnetsOutput) {
		fmt.Println(privateSubnetsOutput, " - ", subnetID)
		assert.False(t, aws.IsPublicSubnet(t, subnetID, awsRegion))
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
func stringArrayCountElements(stringInput string) int {

    // format and convert to array
    stringInput = strings.Trim(stringInput, "[]")
    stringInput = strings.Replace(stringInput, "\n", "", -1)
    stringArray := strings.Split(stringInput, ", ")

    // and count elements
    elementCount := len(stringArray)
    //fmt.Printf("%d\n", elementCount)
    
	return elementCount
}