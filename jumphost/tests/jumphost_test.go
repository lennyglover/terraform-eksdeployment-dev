package test

import (
	"fmt"
	"net"
	"runtime"
	"testing"
	"time"
    //"os/exec"

	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/stretchr/testify/assert"
	"github.com/tatsushid/go-fastping"
)

// Main function, define stages and run.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Entry point has to be declared like this - func TestXxx(*testing.T) - must have upper case T
func Test_Main(t *testing.T) {
	t.Parallel()

	fmt.Println("in jumphost_test.Test_Main")

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

		// validate by pinging - this works for both Windows & Linux jumphosts
		// please see readme.md in jumphost Terraform code directory
		secondsBetweenRetries := 10
		maximumRetries := 10
		assert.True(t, validateJumpHostByPing(t, workingDir, secondsBetweenRetries, maximumRetries))
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
//Validate the resources - ping the instance
func validateJumpHostByPing(t *testing.T, workingDir string, secondsBetweenRetries int, maxRetries int) bool {
	terraformOptions := test_structure.LoadTerraformOptions(t, workingDir)

	// detect OS & privilege level
	//if linux and non-root user set "ping" protocol to udp
	// this is necessary because non-root on linux will
	// always fail with "socket: permission denied" error
	// if protocol is ip
	protocol := "ip"
	if runtime.GOOS == "linux" {
		protocol = "udp"
	}
	fmt.Println("*** - Protocol is", protocol)

	jumpHostPublicDNS := terraform.Output(t, terraformOptions, "jump_host_public_dns")
	fmt.Println("JumpHost Public DNS - ", jumpHostPublicDNS)

	for j := 1; j <= maxRetries; j++ {
		fmt.Println("*** Retry: ", j)

		pingTest := PingSingleIPv4Address(jumpHostPublicDNS, protocol)

		// all replied to ping request
		if pingTest == true {
			return true
		}
        // failed - try setting net.ipv4.ping_group_range="0 65535"
        // sudo sysctl -w net.ipv4.ping_group_range="0 65535"
        //cmd := exec.Command("/bin/sh", "-c", "sudo sysctl -w net.ipv4.ping_group_range='0 65535'")
        //fmt.Println(cmd)
        
		// failed - retry after pause
		time.Sleep(time.Duration(secondsBetweenRetries) * time.Second)
		continue
	}
	// still failing after maxRetries
	return false
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
func PingSingleIPv4Address(ipAddress string, protocol string) bool {

	var pingResult bool

	p := fastping.NewPinger()
	ra, err := net.ResolveIPAddr("ip4:icmp", ipAddress)

	p.MaxRTT = time.Millisecond * 1000
	p.Network(protocol)
	p.AddIPAddr(ra)
	p.OnRecv = func(addr *net.IPAddr, rtt time.Duration) {
		pingResult = true
	}

	err = p.Run()
	if err != nil {
		fmt.Println("*** ", err)
		pingResult = false
	}
	return pingResult
}
