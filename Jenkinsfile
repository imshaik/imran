#!/usr/bin/env groovy

import hudson.model.*
import hudson.EnvVars
import groovy.json.JsonSlurperClassic
import groovy.json.JsonBuilder
import groovy.json.JsonOutput
import java.net.URL

try {
    //agent { label 'docker' } we can use this as well
    node('Docker') 
    {
        //branch name from Jenkins environment variables
            echo "Branch selected is: ${env.BRANCH_NAME}" 
            echo "Build number is: ${env.BUILD_NUMBER}"
		
		def reponame       = "imran"
		def dockerreponame = "httpd"
		def githuburl      = "https://github.com/imshaik/${reponame}.git"
		def dockerurl      = "https://hub.docker.com/r/shaikimranashrafi/${dockerreponame}"
		def buildlabel     = "${env.BRANCH_NAME}-B${env.BUILD_NUMBER}"
        
        stage('Clean workspace')
        {
        /*Clean the workspace before  we do anything
        */
            deleteDir()
        }
        
        stage('Clone repository') 
        {
            git branch: "${env.BRANCH_NAME}", credentialsId: 'Github', url: "https://github.com/imshaik/${reponame}.git"
        }
        //stage ('Checkout')
        //{
          //  checkout imran
        //}   
        stage('Check if dockerfile is exist or not')
        {
            fileExists 'docker/Dockerfile'
		}	
        stage ('Build Docker image')
        {
                def dockerimage = docker.build "shaikimranashrafi/${dockerreponame}:${buildlabel}"
        }
        
        stage ('Archive the .txt artifacts')
        {
			archiveArtifacts artifacts: 'docker/*.yml', fingerprint: true
		}
      }
	} 
catch (exc) 
{
    echo "Caught: ${exc}"
    
    String recipient = 'shaik.imran@lowes.com'

    mail subject: "${env.JOB_NAME} (${env.BUILD_NUMBER}) failed",
            body: "It appears that ${env.BUILD_URL} is failing, somebody should do something about that",
              to: recipient,
         replyTo: recipient,
            from: 'noreply@ci.jenkins.io'

    /* Rethrow to fail the Pipeline properly */
    throw exc
}
