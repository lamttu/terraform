# To create an IAM role, we need at least 5 things:
# - The aws_iam_role resource
# - An `aws_iam_policy_document` data block for trust policy - this defines who can assume this role
# - What the role can do:
#   - An `aws_iam_policy_document` data block: defines what the role can do
#   - An `aws_iam_policy` resource block: creates the policy from the document
#   - An `aws_iam_role_policy_attachment` resource block: attach the policy to the role

// Resource for the IAM role
resource "aws_iam_role" "example-role" {
  name               = "example-role"
  assume_role_policy = data.aws_iam_policy_document.trust-policy
}

// Allow ec2 to assume the role
data "aws_iam_policy_document" "trust-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

// Create iam policy
resource "aws_iam_policy" "policy" {
  name        = "example-policy"
  description = "My test policy"
  policy      = data.aws_iam_policy_document.example.json
}


data "aws_iam_policy_document" "example" {
  statement {
    actions   = ["s3:ListAllMyBuckets"]
    resources = ["arn:aws:s3:::*"]
    effect    = "Allow"
  }
}

// Attach the policy to the role itself
resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.example-role
  policy_arn = aws_iam_policy.policy.arn
}