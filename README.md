# PRCleanup docker action

This action will delete the argo app associated with the PR being closed.
It will also remove associated infrastructure branch.

## Inputs

### `AWS_ACCESS_KEY_ID`

**Required** secrets.AWS_ACCESS_KEY_ID.

### `AWS_SECRET_ACCESS_KEY`

**Required** secrets.AWS_SECRET_ACCESS_KEY.

### `AWS_DEFAULT_REGION`

**Required** secrets.AWS_DEFAULT_REGION.

### `AWS_ORG_ID`

**Required** secrets.AWS_ORG_ID.

### `aws_eks_cluster_name`

**Required** secrets.aws_eks_cluster_name.

### `github-pat`

**Required** secrets.GITHUBPAT.

### `org`

**Required** github organization.

### `infra-repo`

**Required** repository where the manifests live.

### `pr-ref`

**Required** github.event.pull_request.head.ref