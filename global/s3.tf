resource "aws_s3_bucket" "hobby_static_websites" {
  bucket = "hobby-static-websites"
}

locals {
  flatten_static_files = flatten([
    for key, obj in var.static_website_files : [
      for v in obj.files : {
        name = key
        source = obj.build_path
        file_path = v
      }
    ]
  ])

  content_types = {
    ".html"  = "text/html",
    ".css"   = "text/css",
    ".js"    = "application/javascript",
    ".jpg"   = "image/jpeg",
    ".png"   = "image/png",
    ".json"  = "text/json",
    ".woof"  = "font/woff"
    ".woof2" = "font/woff2"
  } 
}

resource "aws_s3_object" "solar_files" {
  for_each = { for k, v in local.flatten_static_files : "${v.source}${v.file_path}" => v }

  bucket = aws_s3_bucket.hobby_static_websites.bucket
  key    = "${each.value.name}/${each.value.file_path}"
  source = "${each.value.source}${each.value.file_path}"
  content_type = lookup(local.content_types, regex("\\.[^.]+$", each.value.file_path), "text/html")
}

resource "aws_s3_bucket_policy" "allow_access_from_specific_vpc" {
  bucket = aws_s3_bucket.hobby_static_websites.id
  policy = data.aws_iam_policy_document.allow_access_from_specific_vpc.json
}

data "aws_iam_policy_document" "allow_access_from_specific_vpc" {
  statement {
    sid = "StmtHobbyEC2S3"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.hobby_static_websites.arn,
      "${aws_s3_bucket.hobby_static_websites.arn}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:sourceVpc"
      values    = ["${aws_default_vpc.default.id}"]
    }
  }
}