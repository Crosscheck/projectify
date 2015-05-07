require 'jenkins_api_client'
require 'colorize'

class BuildServer

	@environments 	= Array.new
	@job_names 		= Array.new

	def initialize (username, password, server_ip, project_name, namespace)
		########## constructor ################################################################################
		#
		# @string: username, @string: password, @string: server_ip, @string: project_name, @string: namespace
		# We'll initialize the class here.
		# We'll also generate the object that we need for the communication with jenkins.
		#
		######################################################################################################
		@USERNAME  		= username
		@PASSWORD  		= password
		@SERVER_IP 		= server_ip
		@PROJECT_NAME 	= project_name
		@NAMESPACE		= namespace

		@client = JenkinsApi::Client.new(

										 :server_ip 	=>	@SERVER_IP,
										 :username 		=>	@USERNAME,
										 :password 		=>	@PASSWORD,
										 :log_location 	=>	'/var/lib/jenkins/projectify/' + project_name + '_jenkins.log'
										
										)

	end

	def set_environment (environments)
		########## set_environment ####################################################################
		#
		# @array of strings: environments
		# We'll set the environments that we have to make build jobs for.
		# In addition, we will also generate the job names that we can use later on for our API calls.
		#
		###############################################################################################
		@environments = environments
		generate_job_names()
	end

	def generate_job_names()
		########## generate_job_names ########################################################
		#
		# We'll generate the job names.
		# We'll also add the environment type with a pipe to the name for future use.
		#
		######################################################################################
		@environments.each do |build_env|
			@job_names.push("(#{@PROJECT_NAME.upcase}-#{build_env}) deploy|#{build_env}")
			@job_names.push("(#{@PROJECT_NAME.upcase}-#{build_env}) deploy update|#{build_env}")
		end
	end

	def set_notifier(notifier_email)
		########## set_notifier ########################################################
		#
		# @string: notifier_email
		# We'll set the email that will be used for notification emails.
		#
		################################################################################
		@notifier = notifier_email
	end

	def good_job(message)
		########## good_job ########################################################
		#
		# @string: message
		# Function for generating a success message
		#
		############################################################################
		puts "{" + "+".green + "} Succesfully created the following job: #{message}"
	end

	def bad_job(message)
		########## bad_job ########################################################
		#
		# @string: message
		# Function for generating an error message
		#
		###########################################################################
		puts "{" + "-".red + "} Failed to create the following job: #{message}"
	end
	def add_build_jobs()
		########## add_build_jobs ############################################################################################
		#
		# We will loop through all job names and do the following actions:
		# - First we'll see what type of jobs we have and set the type_string (type: string)
		# - We'll also see what environments we have, and if we encounter dev, we'll set the branch to master (type: string)
		# - When all that is set, we will start creating the job through the jenkins api object (@client).
		# - The jenkins api object (@client) will return a status code. If it's 200, we know the job has been created. 
		#
		#####################################################################################################################
		@job_names.each do |job|

			if job.split('|')[1] == "dev"
				job_env = "master"
			else
				job_env = job.split('|')[1]
			end

			if job.split('|')[0].include?("update")
				type_string = " update"
			else
				type_string = ""
			end

			deploy = @client.job.create_or_update_freestyle(
															:name 				=>	"#{job.split('|')[0]}",
															:keep_dependencies	=>	true,
															:scm_provider		=>	'git',
															:scm_url			=>	"git@gitlab.crosscheck.be:#{@NAMESPACE}/#{@PROJECT_NAME}",
															:scm_branch			=>	job_env,
															:shell_command		=>	"cap #{job_env} deploy#{type_string}",
															:notification_email	=>	@notifier
															)
			if deploy == "200"
				good_job("#{job.split('|')[0]}")
			else
				bad_job("#{job.split('|')[0]}")
			end
		end
	end
end