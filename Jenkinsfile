node {

  try {
    slackSend (color: '#FFFF00', message: "STARTED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")

    def project = 'proudcity-1184'
    def appName = 'sendy'
    //def feSvcName = "${appName}-frontend"
    def imageTag = "gcr.io/${project}/${appName}:${env.BRANCH_NAME}.${env.BUILD_NUMBER}"

    // @todo: get name from tag
    echo 'TAGNAME'
    sh(returnStdout: true, script: "git tag --sort version:refname | tail -1").trim()

    checkout scm

    stage 'Build image'
    sh("docker build -t ${imageTag} .")

    //stage 'Run Go tests'
    //sh("docker run ${imageTag} go test")

    stage 'Push image to registry'
    sh("gcloud docker push ${imageTag}")

    slackSend (color: '#00FF00', message: "SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")

  } catch (e) {
    currentBuild.result = "FAILED"
    slackSend (color: '#FF0000', message: "FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
    throw e
  }
 

}