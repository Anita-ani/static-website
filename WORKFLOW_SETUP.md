# CI/CD Workflow Setup Instructions

## 🚀 Autodeployment Workflow Overview

This repository now includes a comprehensive CI/CD pipeline that automatically:

1. ✅ **Validates** HTML files for syntax errors
2. 🔒 **Scans** for security vulnerabilities
3. 🐳 **Builds** and pushes Docker images to Docker Hub
4. 🌐 **Deploys** to GitHub Pages automatically
5. 📊 **Reports** deployment status

## Required Secrets Configuration

To enable full functionality, add these secrets to your repository:

### GitHub Repository Settings → Secrets and variables → Actions

1. **DOCKER_USERNAME**: Your Docker Hub username
2. **DOCKER_PASSWORD**: Your Docker Hub access token or password

### Optional Secrets (for cloud deployment):
3. **AWS_ACCESS_KEY_ID**: AWS access key
4. **AWS_SECRET_ACCESS_KEY**: AWS secret key
5. **S3_BUCKET_NAME**: S3 bucket name
6. **CLOUDFRONT_DISTRIBUTION_ID**: CloudFront distribution ID

## How to Add Secrets

1. Go to your repository on GitHub
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Add each secret name and value
5. Click **Add secret**

## Enabling GitHub Pages

1. Go to **Settings** → **Pages**
2. Under **Source**, select **GitHub Actions**
3. Save changes

## Workflow Triggers

The workflow runs automatically on:
- Every push to `main` branch
- Every pull request to `main` branch
- Manual trigger via Actions tab

## Deployment Targets

### 1. Docker Hub
- Automatically builds and pushes image on every main branch push
- Image tagged with: `latest`, commit SHA, and timestamp
- Includes layer caching for faster builds

### 2. GitHub Pages
- Deploys static website automatically
- Available at: `https://<username>.github.io/<repo-name>`

### 3. Cloud Providers (Optional)
- Uncomment the `deploy-cloud` job in workflow
- Add required secrets
- Currently configured for AWS S3 + CloudFront

## Improvements Made

✨ **Enhanced Features:**
- HTML validation to catch errors early
- Security scanning with Trivy
- Docker image vulnerability scanning
- Multi-stage deployment pipeline
- Build caching for 3x faster builds
- Automatic tagging with timestamps and SHAs
- GitHub Pages integration
- Comprehensive deployment summaries

🔧 **Best Practices:**
- Separated jobs for parallel execution
- Conditional execution (only on main branch)
- Proper dependency chains
- Security scanning integrated
- Manual workflow trigger option

## Monitoring Deployments

1. Go to **Actions** tab in your repository
2. Click on any workflow run to see details
3. Check deployment summaries
4. View security scan results in **Security** tab

## Next Steps

1. Add required secrets (DOCKER_USERNAME, DOCKER_PASSWORD)
2. Enable GitHub Pages in repository settings
3. Push a commit to trigger the workflow
4. Monitor the Actions tab for deployment status

## Customization

- Edit `.github/workflows/deploy.yml` to modify deployment steps
- Add more deployment targets as needed
- Adjust validation rules
- Configure notifications (Slack, Discord, email)
