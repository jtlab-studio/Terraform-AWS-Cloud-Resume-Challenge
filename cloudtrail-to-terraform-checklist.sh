#!/usr/bin/env bash
set -euo pipefail

REGIONS=("us-east-1" "eu-central-1")
LOOKBACK_DAYS=90

RAW_EVENTS="cloudtrail-events-raw.txt"
CHECKLIST="terraform-import-checklist.txt"

> "$RAW_EVENTS"
> "$CHECKLIST"

echo "Pulling CloudTrail events (last $LOOKBACK_DAYS days)..."

START_TIME=$(date -u -d "-$LOOKBACK_DAYS days" +"%Y-%m-%dT%H:%M:%SZ")

for REGION in "${REGIONS[@]}"; do
  echo "  → Region: $REGION"

  aws cloudtrail lookup-events \
    --region "$REGION" \
    --start-time "$START_TIME" \
    --max-results 50 \
    --query 'Events[].CloudTrailEvent' \
    --output text |
  jq -r '
    fromjson
    | select(.eventName | test("Create|Put|Enable|Request"))
    | "\(.eventSource)|\(.eventName)"
  ' >> "$RAW_EVENTS"
done

sort -u "$RAW_EVENTS" -o "$RAW_EVENTS"

echo
echo "Generating Terraform import checklist..."

{
cat <<'EOF'
# Terraform Import Checklist
# ==========================
#
# ✔ = should be imported
# ✖ = do NOT import (ephemeral / noise)
# ⚠ = conditional (only if you manage it in Terraform)
#
# Use this as a validation checklist — not a source of truth.
#
EOF

grep -q "s3.amazonaws.com|CreateBucket" "$RAW_EVENTS" && cat <<'EOF'
✔ aws_s3_bucket
✔ aws_s3_bucket_policy
✔ aws_s3_bucket_server_side_encryption_configuration
✔ aws_s3_bucket_public_access_block
✔ aws_s3_bucket_versioning
✔ aws_s3_bucket_website_configuration
EOF

grep -q "dynamodb.amazonaws.com|CreateTable" "$RAW_EVENTS" && cat <<'EOF'

✔ aws_dynamodb_table
EOF

grep -q "lambda.amazonaws.com|CreateFunction" "$RAW_EVENTS" && cat <<'EOF'

✔ aws_lambda_function
EOF

grep -q "lambda.amazonaws.com|CreateFunctionUrlConfig" "$RAW_EVENTS" && cat <<'EOF'
✔ aws_lambda_function_url
EOF

grep -q "cloudfront.amazonaws.com|CreateDistribution" "$RAW_EVENTS" && cat <<'EOF'

✔ aws_cloudfront_distribution
⚠ aws_cloudfront_origin_access_control (only if referenced)
✖ cloudfront invalidations (never import)
EOF

grep -q "acm.amazonaws.com|RequestCertificate" "$RAW_EVENTS" && cat <<'EOF'

✔ aws_acm_certificate (us-east-1)
EOF

grep -q "route53.amazonaws.com|CreateHostedZone" "$RAW_EVENTS" && cat <<'EOF'

⚠ aws_route53_zone (import only if you own it)
✔ aws_route53_record
EOF

grep -q "wafv2.amazonaws.com|CreateWebACL" "$RAW_EVENTS" && cat <<'EOF'

⚠ aws_wafv2_web_acl (only if attached to CloudFront)
EOF

grep -q "iam.amazonaws.com|CreateRole" "$RAW_EVENTS" && cat <<'EOF'

⚠ aws_iam_role
⚠ aws_iam_policy
⚠ aws_iam_role_policy_attachment
EOF

cat <<'EOF'

# Explicitly NOT Terraform resources
✖ aws_cloudwatch_log_group
✖ aws_cloudwatch_log_stream
✖ kms grants
✖ autoscaling scaling policies (unless managing ASGs)
✖ pricing / billing services
EOF

} > "$CHECKLIST"

echo
echo "Done."
echo "  Raw events:        $RAW_EVENTS"
echo "  Import checklist:  $CHECKLIST"

