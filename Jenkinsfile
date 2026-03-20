// ┌──────────────────────────────────────────────────────────┐
// │  SECURE CI/CD PIPELINE                                   │
// │  Stages: Build -> Test -> Dev -> Staging -> Approve -> Prod│
// └──────────────────────────────────────────────────────────┘
pipeline {
  agent any
 
  environment {
    APP_NAME        = 'secure-cicd-app'
    APP_VERSION     = "1.0.${BUILD_NUMBER}"
    // IMPORTANT: Replace these with your ACTUAL EC2 Public IPs
    DEV_SERVER      = '11.22.33.44'
    STAGING_SERVER  = '11.22.33.55'
    PROD_SERVER     = '11.22.33.66'
    SSH_CRED        = 'ec2-ssh-key'
  }
 
  triggers {
    githubPush()   // Auto-start when GitHub sends webhook
  }
 
  options {
    buildDiscarder(logRotator(numToKeepStr: '10'))
    timeout(time: 1, unit: 'HOURS')
    timestamps()
    disableConcurrentBuilds()
  }
 
  stages {
 
    // ── STAGE 1: BUILD ─────────────────────────────────────
    stage('Build') {
      steps {
        echo '=== BUILD STAGE ==='
        sh 'npm ci'   // Install all dependencies cleanly
        sh "echo ${APP_VERSION} > version.txt"
        echo 'Build complete!'
      }
      post {
        failure { echo 'BUILD FAILED - check npm errors above' }
      }
    }
 
    // ── STAGE 2: UNIT TESTS ────────────────────────────────
    stage('Unit Tests') {
      steps {
        echo '=== UNIT TEST STAGE ==='
        sh 'npm run test:ci'
      }
      post {
        always {
          archiveArtifacts artifacts: 'coverage/**', allowEmptyArchive: true
        }
        failure {
          error 'TESTS FAILED - fix before deploying!'
        }
      }
    }
 
    // ── STAGE 3: DEPLOY TO DEV ─────────────────────────────
    stage('Deploy to Dev') {
      steps {
        echo "=== DEPLOYING TO DEV (${DEV_SERVER}) ==="
        sshagent(credentials: [SSH_CRED]) {
          sh """
            # Copy deploy script to dev server
            scp -o StrictHostKeyChecking=no scripts/deploy.sh ubuntu@${DEV_SERVER}:/tmp/deploy.sh
            # Run the deploy script on the dev server
            ssh -o StrictHostKeyChecking=no ubuntu@${DEV_SERVER} \
              'chmod +x /tmp/deploy.sh && /tmp/deploy.sh development ${APP_VERSION}'
          """
        }
        // Smoke test from Jenkins
        sh "curl -f http://${DEV_SERVER}:3000/health || exit 1"
        echo 'Dev deployment successful!'
      }
    }
 
    // ── STAGE 4: DEPLOY TO STAGING ─────────────────────────
    stage('Deploy to Staging') {
      steps {
        echo "=== DEPLOYING TO STAGING (${STAGING_SERVER}) ==="
        sshagent(credentials: [SSH_CRED]) {
          sh """
            scp -o StrictHostKeyChecking=no scripts/deploy.sh ubuntu@${STAGING_SERVER}:/tmp/deploy.sh
            ssh -o StrictHostKeyChecking=no ubuntu@${STAGING_SERVER} \
              'chmod +x /tmp/deploy.sh && /tmp/deploy.sh staging ${APP_VERSION}'
          """
        }
        sh """
          curl -f http://${STAGING_SERVER}:3000/health   || exit 1
          curl -f http://${STAGING_SERVER}:3000/         || exit 1
          curl -f http://${STAGING_SERVER}:3000/api/info || exit 1
          echo 'All staging checks passed!'
        """
      }
    }
 
    // ── STAGE 5: MANUAL APPROVAL GATE ─────────────────────
    stage('Manual Approval') {
      when { branch 'main' }   // Only on main branch pushes
      steps {
        echo '=== WAITING FOR PRODUCTION APPROVAL ==='
        // Pipeline PAUSES here until admin acts
        // Times out and ABORTS after 24 hours automatically
        input(
          id:          'prod-deploy',
          message:     "Deploy version ${APP_VERSION} to PRODUCTION?",
          ok:          'Yes, Deploy to Production',
          submitter:   'admin',    // Only 'admin' user can click Proceed
          submitterParameter: 'APPROVED_BY',
          parameters: [
            string(name: 'RELEASE_NOTES', defaultValue: 'Routine deployment',
                   description: 'What changed in this release?')
          ]
        )
        echo "Approved by: ${APPROVED_BY}"
        echo "Release notes: ${RELEASE_NOTES}"
      }
    }
 
    // ── STAGE 6: DEPLOY TO PRODUCTION ─────────────────────
    stage('Deploy to Production') {
      when { branch 'main' }
      steps {
        echo "=== DEPLOYING TO PRODUCTION (${PROD_SERVER}) ==="
        sshagent(credentials: [SSH_CRED]) {
          sh """
            scp -o StrictHostKeyChecking=no scripts/deploy.sh ubuntu@${PROD_SERVER}:/tmp/deploy.sh
            ssh -o StrictHostKeyChecking=no ubuntu@${PROD_SERVER} \
              'chmod +x /tmp/deploy.sh && /tmp/deploy.sh production ${APP_VERSION}'
          """
        }
        sh """
          sleep 5
          curl -f http://${PROD_SERVER}:3000/health || exit 1
          echo '=== PRODUCTION DEPLOYMENT VERIFIED ==='
        """
      }
    }
 
  } // end stages
 
  post {
    success { echo "PIPELINE SUCCEEDED - version ${APP_VERSION} is live!" }
    failure { echo 'PIPELINE FAILED - check the logs above' }
    aborted { echo 'PIPELINE ABORTED - production not deployed' }
    always  { cleanWs() }   // Clean workspace after every build
  }
}
