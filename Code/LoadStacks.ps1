# GetAndLoadRepos.ps1
# -------------------
# Get all the repos necessary for the presentation, load them in the AWS account
# of your choice (via the -profile parameter, please use one dash - not two)
#
# GetAndLoadRepos.ps1 -s3bucket -profile myPROFILE
#
# You can use my bucket (read-only, don't use the uploadtos3 switch and the s3bucket
# parameter).
# 
# You can also specify your own bucket name and the uploadtos3 parameter. Because
# you will allow everyone to read the files from your bucket, you need to prepare
# the bucket with the following aws cli command (replace cos20220614 with your own
# bucket name):
#
# aws s3api put-bucket-ownership-controls --bucket cos20220614 --ownership-controls=Rules=[{ObjectOwnership=ObjectWriter}] --profile profilename

param(
     [string]$s3bucket = "cos20220614",
     [switch]$uploadtos3 = $False,
     [string]$REGION = "eu-west-1",
     [string]$PROFILE = "default"
)

$DEFAULT_RELATIVE_PATH = ".\CloudFormation"
$DEFAULT_S3_BUCKET     = $s3bucket

function get_repo {
    param([string] $url)
    git clone $url
}

function load_cloudformation {
    param([string] $stackname,
          [string] $filename)

    $templateurl = "https://${s3bucket}.s3.${region}.amazonaws.com/" + $filename
    aws cloudformation create-stack --stack-name $stackname `
                                    --template-url $templateurl `
                                    --capabilities CAPABILITY_IAM `
                                    --region $REGION `
                                    --profile $PROFILE
}

function upload_s3 {
    param([string] $filename,
          [string] $relative_path = $DEFAULT_RELATIVE_PATH,
          [string] $s3bucket      = $DEFAULT_S3_BUCKET)

    $relative_filename = $relative_path + "\" + $filename

    aws s3 cp $relative_filename s3://${s3bucket} `
           --region  $REGION `
           --profile $PROFILE

    aws s3api put-object-acl --bucket  $s3bucket `
                             --key     $filename `
                             --acl     public-read `
                             --region  $REGION `
                             --profile $PROFILE
}

# MAIN
# ====

if ($uploadtos3) {
    upload_s3 -filename 01_Create_a_Step_Functions_State_Machine_That_Uses_Lambda.yaml
    upload_s3 -filename 02_Handling_Error_Conditions_Using_a_Step_Functions_State_Machine.yaml
    upload_s3 -filename 03_Using_a_Map_State_to_Call_Lambda_Multiple_Times.yaml
    upload_s3 -filename 04_Iterating_a_Loop_using_Lambda.yaml
    upload_s3 -filename 05_TransferDataRecords.yaml
    upload_s3 -filename 06_Manage_a_Container_Task.yaml
    upload_s3 -filename 07_Poll_For_Job_Status.yaml
    upload_s3 -filename 08_Call_From_Eventbridge.yaml
    upload_s3 -filename 09_Call_from_API_Gateway.yaml
    upload_s3 -filename 10_Deploying_an_Example_Human_Approval_Project.yaml
}


load_cloudformation -stackname COS01 `
                    -filename 01_Create_a_Step_Functions_State_Machine_That_Uses_Lambda.yaml
load_cloudformation -stackname COS02 `
                    -filename 02_Handling_Error_Conditions_Using_a_Step_Functions_State_Machine.yaml
load_cloudformation -stackname COS03 `
                    -filename 03_Using_a_Map_State_to_Call_Lambda_Multiple_Times.yaml
load_cloudformation -stackname COS04 `
                    -filename 04_Iterating_a_Loop_using_Lambda.yaml
load_cloudformation -stackname COS05 `
                    -filename 05_TransferDataRecords.yaml
load_cloudformation -stackname COS06 `
                    -filename 06_Manage_a_Container_Task.yaml
load_cloudformation -stackname COS07 `
                    -filename 07_Poll_For_Job_Status.yaml
load_cloudformation -stackname COS08 `
                    -filename 08_Call_From_Eventbridge.yaml
load_cloudformation -stackname COS09 `
                    -filename 09_Call_from_API_Gateway.yaml
load_cloudformation -stackname COS10 `
                    -filename 10_Deploying_an_Example_Human_Approval_Project.yaml