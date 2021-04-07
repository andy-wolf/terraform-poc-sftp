# PoC for an AWS-based SFTP setup
> SFTP service with bi-directional replication to on-prem data center

This PoC demonstrates the combination of different AWS managed services to run
an SFTP server with S3 backend and replicate the files to our on-prem data center
where it is exposed as NFS network share.


## Installing / Getting started

For running this PoC you will need to have `terraform v0.12.x` and `terragrunt v0.23.x` installed.

```shell
brew install terraform
brew install terragrunt
```

In order to execute the full stack setup in `stage` environment simply execute

````shell
terragrunt apply-all
````

As terraform relies on your `AWS CLI` you can configure profiles and credentials in `~/.aws/` directory.


### Testing / Showcasing

The PoC spins up a setup of multiple managed services in order to showcase the extraction/relocation of SFTP service into the cloud:

* AWS Transfer Family (a.k.a. SFTP Transfer for S3)
* AWS Storage Gateway / File Gateway
    * Storage Gateway including file share configuration
    * Storage Gateway Instance
        * Emulating on-prem VMware-based instance
        * Exposing NFS file share `/demo`
* AWS S3 Bucket with full versioning `sftp-data-bucket-andywolf` (rename for your purposes)

For showcasing the end-to-end process the following steps are recommended after spinning up the stack:

1. Get the SSH private key that has been created automatically for the demo user from AWS Parameter Store and store it somewhere in a file
1. Get the endpoint URL of the AWS Transfer Family server in order to access via an SFTP client
1. Get the SFTP username, e.g. by default this is stage-sftp-server-user1
1. Use any kind of SFTP client to establish the connection using URL, Username and private key
1. Connect to the EC2 instance via AWS Connect (e.g. without keys) for demoing purposes
1. Mount the NFS share exposed by the Storage Gateway Instance on the EC2 instance
1. Showcase both directions of file transfer, e.g. upload via SFTP client and copy on NFS share

