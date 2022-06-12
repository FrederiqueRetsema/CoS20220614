param(
     [string]$REGION = "eu-west-1",
     [string]$PROFILE = "default"
)

function delete_stack {
    param([string] $stackname)

    aws cloudformation delete-stack --stack-name $stackname `
                                    --region  $REGION `
                                    --profile $PROFILE
}

delete_stack COS01
delete_stack COS02
delete_stack COS03
delete_stack COS04
delete_stack COS05
delete_stack COS06
delete_stack COS07
delete_stack COS08
delete_stack COS09
delete_stack COS10
