pipeline {
	agent any
	triggers {
		pollSCM('* * * * *')
	}
	post {
        always {
            sh "docker -H 192.168.0.11:2375 stop calculator"
        }
    }
	stages {
		stage("Compile") {
			steps {
				sh "./gradlew compileJava"
			}
		}
		stage("Unit test") {
			steps {
				sh "./gradlew test"
			}
		}
		stage("Code coverage") {
			steps {
				sh "./gradlew jacocoTestReport"
				publishHTML (target: [
                    reportDir: 'build/reports/jacoco/test/html',
                    reportFiles: 'index.html',
                    reportName: "JaCoCo Report"
                ])
				sh "./gradlew jacocoTestCoverageVerification"
			}
		}
		stage("Static code analysis") {
            steps {
                sh "./gradlew checkstyleMain"
                publishHTML (target: [
                    reportDir: 'build/reports/checkstyle',
                    reportFiles: 'main.html',
                    reportName: "Checkstyle Report"
                ])
            }
		}
		stage("Package") {
            steps {
                sh "./gradlew build"
            }
        }
        stage("Docker build") {
            steps {
                sh "docker -H 192.168.0.11:2375 build -t quercus.elbor.org:5000/calculator ."
            }
        }
        stage("Docker push") {
            steps {
                sh "docker -H 192.168.0.11:2375 push quercus.elbor.org:5000/calculator"
            }
        }
        stage("Deploy to staging") {
            steps {
                sh "docker -H 192.168.0.11:2375 run -d --rm -p 8765:8080 --name calculator quercus.elbor.org:5000/calculator"
            }
        }
        stage("Acceptance test") {
            steps {
                sleep 60
                sh "./acceptance_test.sh"
            }
        }
	}
}
