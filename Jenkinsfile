pipeline {
    agent {
        kubernetes {
            serviceAccount 'jenkins-admin'
            yaml """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: kaniko
    image: gcr.io/kaniko-project/executor:debug
    command: ['sleep']
    args: ['99d']
  - name: git
    image: alpine/git
    command: ['sleep']
    args: ['99d']
"""
        }
    }

   environment {
        ECR_REPO = "211125349493.dkr.ecr.us-east-1.amazonaws.com/dev-lesson-8-9-test"
        GITOPS_REPO = "github.com/PavloRohozhyn/django-app-for-terraform.git"
        IMAGE_TAG = "${env.BUILD_NUMBER}"
    }

    stages {
        stage('Build & Push to ECR') {
            steps {
                container('kaniko') {
                    // Kaniko dont need docker login, his use IRSA (IAM role)
                    sh """
                    /kaniko/executor --context `pwd` \
                        --dockerfile Dockerfile \
                        --destination ${ECR_REPO}:${IMAGE_TAG} \
                        --destination ${ECR_REPO}:latest
                    """
                }
            }
        }

        stage('Update GitOps Manifests') {
            steps {
                container('git') {
                    script {
                        withCredentials([usernamePassword(
                            credentialsId: 'github-token', 
                            usernameVariable: 'GH_USER', 
                            passwordVariable: 'GH_TOKEN'
                        )]) {
                            sh """
                                git config --global user.email "jenkins@example.com"
                                git config --global user.name "Jenkins CI"
                                git clone https://${GH_TOKEN}@${env.GITOPS_REPO} temp_infra
                                cd temp_infra
                                sed -i "s/tag: .*/tag: \\"${IMAGE_TAG}\\"/" charts/django-app/values.yaml
                                git add charts/django-app/values.yaml
                                git commit -m "Update Django image to ${IMAGE_TAG} [skip ci]"
                                git push origin main
                            """
                        }
                    }
                }
            }
        }
    }
}

