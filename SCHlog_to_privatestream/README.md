This is an example terraform code to create below Oracle cloud resources.
1. OCI Streaming with Private stream pool
2. Network security group 
3. Network security group rule with Ingress and egress rule needed for the connector to work with private stream
4. Service connector hub with Audit log as source and private stream as target.

Create terraform.tfvars to pass the required inputs.

Please specify the appropriate provider authentication if you are running outside OCI cloud shell.

The required policies for service connector hub is not part of this example code.

Reference doc : https://docs.public.oneportal.content.oci.oraclecloud.com/en-us/iaas/Content/connector-hub/create-service-connector-streaming-source.htm#stream-private
https://docs.public.oneportal.content.oci.oraclecloud.com/en-us/iaas/Content/connector-hub/create-service-connector-streaming-source.htm#ingress-egress
