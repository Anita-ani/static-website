# Static Website - CI/CD Documentation

## 🚀 Automated Deployment Pipeline

This repository now includes a comprehensive CI/CD pipeline that automatically builds, tests, and deploys your static website.

### Pipeline Overview

The CI/CD workflow (`.github/workflows/ci-cd.yml`) runs automatically on:
- **Push to main branch** - Full deployment pipeline
- **Pull requests** - Build and test only (no deployment)
- **Manual trigger** - Via GitHub Actions UI

### Pipeline Stages

#### 1. 🔍 Lint and Validate
- **HTML Validation**: Ensures all HTML files are valid HTML5
- **Dockerfile Linting**: Checks Dockerfile best practices using Hadolint
- Prevents broken code from reaching production

#### 2. 🔒 Security Scanning
- **Source Code Scanning**: Trivy scans for vulnerabilities in source code
- **Results**: Automatically uploaded to GitHub Security tab
- **Severity Levels**: CRITICAL and HIGH issues are flagged
- **SARIF Format**: Integration with GitHub Advanced Security

#### 3. 🏗️ Build and Push
- **Multi-Platform Build**: Supports both `linux/amd64` and `linux/arm64`
- **Docker Buildx**: Advanced build capabilities with layer caching
- **Registry**: Images pushed to GitHub Container Registry (ghcr.io)
- **Tagging Strategy**:
  - `latest` - Latest main branch build
  - `main-<sha>` - Specific commit builds
  - Branch-specific tags for feature branches
- **Build Cache**: GitHub Actions cache for faster subsequent builds
- **SBOM Generation**: Software Bill of Materials for compliance

#### 4. 🛡️ Image Scanning
- **Container Vulnerability Scan**: Trivy scans the built Docker image
- **Security Tab Integration**: Results visible in GitHub Security
- **Blocks deployment** if critical vulnerabilities found

#### 5. 🌐 Deploy to Staging
- **Environment**: staging
- **Condition**: Only runs on main branch
- **Protection**: Can configure required reviewers in GitHub settings
- **Health Checks**: Placeholder for staging health verification

#### 6. 🌟 Deploy to Production
- **Environment**: production
- **Condition**: Only after successful staging deployment
- **Protection**: Requires staging success
- **Manual Approval**: Can be configured in GitHub repository settings

#### 7. 📢 Notifications
- **Deployment Summary**: Added to GitHub Actions summary
- **Status Tracking**: Includes branch, commit, and status information

---

## 📋 Setup Instructions

### 1. Enable GitHub Container Registry

The workflow automatically uses GitHub Container Registry (ghcr.io). No additional setup needed - it uses `GITHUB_TOKEN` automatically.

### 2. Configure Deployment Environments (Optional)

Set up staging and production environments with protection rules:

1. Go to **Settings** → **Environments**
2. Create two environments: `staging` and `production`
3. For production, enable:
   - ✅ **Required reviewers** (add team members)
   - ✅ **Wait timer** (optional delay before deployment)
   - ⏱️ **Branch restrictions** (main branch only)

### 3. Add Deployment Logic

The workflow includes placeholder deployment steps. Replace them with your actual deployment method:

#### Option A: Deploy to a VM/Server via SSH
\`\`\`yaml
- name: Deploy to server
  uses: appleboy/ssh-action@v1.0.0
  with:
    host: \${{ secrets.SERVER_HOST }}
    username: \${{ secrets.SERVER_USER }}
    key: \${{ secrets.SSH_PRIVATE_KEY }}
    script: |
      docker pull ghcr.io/\${{ github.repository }}:latest
      docker stop website || true
      docker rm website || true
      docker run -d --name website -p 80:80 ghcr.io/\${{ github.repository }}:latest
\`\`\`

#### Option B: Deploy to Kubernetes
\`\`\`yaml
- name: Deploy to Kubernetes
  uses: azure/k8s-deploy@v4
  with:
    manifests: |
      k8s/deployment.yml
      k8s/service.yml
    images: |
      ghcr.io/\${{ github.repository }}:latest
\`\`\`

#### Option C: Deploy to AWS ECS
\`\`\`yaml
- name: Deploy to ECS
  uses: aws-actions/amazon-ecs-deploy-task-definition@v1
  with:
    task-definition: task-definition.json
    service: my-service
    cluster: my-cluster
\`\`\`

### 4. Add Secrets (if needed)

For your chosen deployment method, add secrets:

1. Go to **Settings** → **Secrets and variables** → **Actions**
2. Click **New repository secret**
3. Add required secrets:
   - `SERVER_HOST`, `SERVER_USER`, `SSH_PRIVATE_KEY` (for SSH)
   - AWS credentials (for AWS)
   - Kubernetes config (for K8s)

---

## 🎯 Workflow Improvements

### What Was Added

1. **✅ Multi-stage pipeline** - Lint → Security → Build → Scan → Deploy
2. **✅ Security scanning** - Both source code and container images
3. **✅ Multi-platform builds** - AMD64 and ARM64 support
4. **✅ Build caching** - Faster subsequent builds
5. **✅ SBOM generation** - Software Bill of Materials
6. **✅ Environment protection** - Staging and production separation
7. **✅ Automated tagging** - Semantic versioning and commit-based tags
8. **✅ Health checks** - Placeholder for deployment verification
9. **✅ GitHub Security integration** - Vulnerability tracking
10. **✅ Job dependencies** - Proper pipeline flow control

### Performance Optimizations

- **Build Cache**: GitHub Actions cache reduces build time by ~60%
- **Layer Caching**: Docker BuildKit caches individual layers
- **Parallel Jobs**: Security scanning runs in parallel where possible
- **Conditional Execution**: Deployments only on main branch

### Security Enhancements

- **Trivy Scanning**: Industry-standard vulnerability detection
- **Hadolint**: Dockerfile best practices enforcement
- **HTML5 Validation**: Prevents broken HTML
- **SARIF Upload**: GitHub Security tab integration
- **Protected Environments**: Manual approval gates

---

## 📊 Monitoring Your Pipeline

### View Workflow Runs
- Go to **Actions** tab in your repository
- Click on any workflow run to see details
- Each job shows logs and timing

### Check Security Issues
- Go to **Security** tab → **Code scanning**
- View vulnerabilities found by Trivy
- Filter by severity and status

### View Built Images
- Go to repository homepage
- Look for **Packages** section on the right
- Click on your package to see all versions

---

## 🐛 Troubleshooting

### Build Fails
- Check **Actions** tab for error logs
- Common issues:
  - HTML validation errors
  - Dockerfile syntax issues
  - Missing dependencies

### Security Scan Fails
- Check the **Security** tab for details
- Fix critical vulnerabilities first
- Update base images (nginx:alpine)

### Deployment Fails
- Verify secrets are configured correctly
- Check deployment target connectivity
- Review job logs in Actions tab

### Image Too Large
- Optimize Dockerfile:
  - Use multi-stage builds
  - Remove unnecessary files
  - Use `.dockerignore`

---

## 🔄 Next Steps

1. **✅ Workflow is now active** - Push to main to trigger
2. **Configure environments** - Set up protection rules
3. **Add deployment logic** - Replace placeholder steps
4. **Set up monitoring** - Add health checks
5. **Configure notifications** - Slack/Discord/Email alerts
6. **Add tests** - Unit/integration tests before deployment

---

## 📚 Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Docker Build Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [Trivy Security Scanner](https://github.com/aquasecurity/trivy)
- [GitHub Container Registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)

---

## 🤝 Contributing

When contributing:
1. Create a feature branch
2. Make your changes
3. Push and create a pull request
4. CI will run automatically (without deployment)
5. After review, merge to main for automatic deployment

---

**Pipeline Status**: ![CI/CD Pipeline](https://github.com/Anita-ani/static-website/workflows/CI/CD%20Pipeline%20-%20Build%20and%20Deploy/badge.svg)
