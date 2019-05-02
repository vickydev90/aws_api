pipeline
{
    agent {
        kubernetes {
           label "shared-lib-${UUID.randomUUID().toString()}"
           yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    jenkins: jenkins-pipeline
spec:
  containers:
  - name: jnlp
    image: jenkins/jnlp-slave
    ttyEnabled: true
  - name: buildtool
    image: vickyd/buildtool:latest
    command:
    - cat
    tty: true
  securityContext:
    runAsUser: 0
"""
        }
    }

    stages {
        stage('Create Packer AMI') {
            steps {
                container('buildtool') {
                    withCredentials([
                        usernamePassword(credentialsId: 'ada90a34-30ef-47fb-8a7f-r3485r4jdfd4', passwordVariable: 'AWS_SECRET', usernameVariable: 'AWS_KEY')
          ]) {
              sh 'packer build -var aws_access_key=${AWS_KEY} -var aws_secret_key=${AWS_SECRET} packer/packer.json'
                }
            }
        }
        }
        stage('AWS Deploy') {
            steps {
                container('buildtool') {
                    withCredentials([
                        usernamePassword(credentialsId: 'ada90a34-30ef-47fb-8a7f-a97fe69ff93f', passwordVariable: 'AWS_SECRET', usernameVariable: 'AWS_KEY'),
                        usernamePassword(credentialsId: '2facaea2-613b-4f34-9fb7-1dc2daf25c45', passwordVariable: 'REPO_PASS', usernameVariable: 'REPO_USER'),
          ]) {
              sh 'rm -rf terraform'
              sh 'git clone https://github.com/vickydev90/terraform.git'
              sh '''
                 cd terraform
                 terraform init
                 terraform apply -auto-approve -var access_key=${AWS_KEY} -var secret_key=${AWS_SECRET}
                 git add terraform.tfstate
                 git -c user.name="vishal deshmukh" -c user.email="vishdeshmukh2011@gmail.com" commit -m "terraform state update from Jenkins"
                 git push https://${REPO_USER}:${REPO_PASS}@github.com/vickydev90/terraform.git master
                 ''' 
                    }
                }   
            }
        }
    }
}