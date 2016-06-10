require 'jenkins_api_client'
require 'colorize'
require 'titleize'

##
# This class represents a Jenkins server.
class BuildServer

  ##
  # Creates a new buildserver and generate a JenkinsApi::Client object.
  #
  # ==== Attributes
  #
  # * +username+ - The username to connect to the Jenkins server.
  # * +password+ - The password or API token for the user.
  # * +server+ - The host name or IP address to connect to.
  # * +project_name+ - The name you want to give to your project.
	def initialize(username, password, server, project_name)
		@username  		= username
		@password  		= password
		@server   		= server
		@project_name = project_name

		@client = JenkinsApi::Client.new(
                  :server_ip 	=>	@server,
                  :username 		=>	@username,
                  :password 		=>	@password,
                  :log_location 	=>	'/var/lib/jenkins/projectify/' + project_name + '_jenkins.log'
                )
	end

  ##
  # Setter for @environments and generate the Jenkins job names.
  #
  # ==== Attributes
  #
  # * +environments - An array of strings.
	def set_environments(environments)
    @environments = []
		@environments = environments

		generate_job_names
	end

  ##
  # Generate the job names for the Jenkins jobs.
	def generate_job_names
		@job_names 	= []

		@environments.each do |environment|
			if environment == "master"
				env = "dev"
			else
				env = environment
			end

      name = @project_name.titleize.tr('-', '')

      @job_names.push("#{name}-#{env.upcase}-deploy")
      @job_names.push("#{name}-#{env.upcase}-deployUpdate")
		end
	end

  ##
  # Generate a success message
  #
  # ==== Attributes
  #
  # * +message+ - The message to display.
	def good_job(message)
    puts "{#{'+'.green}} Succesfully created the following job: #{message}"
	end

  ##
  # Generate a error message
  #
  # ==== Attributes
  #
  # * +message+ - The message to display.
	def bad_job(message)
    puts "{#{'+'.red}} Failed to created the following job: #{message}"
	end

  ##
  # Add the build jobs to the Jenkins server
	def add_build_jobs
		@job_names.each do |job|

			if job.include?("deployUpdate")
				task = ":update"
			else
				task = ""
			end

			if job.include?("-DEV-")
				branch = "master"
				env = "dev"
      elsif job.include?("-TEST-")
				branch = "test"
				env = "testing"
      elsif job.include?("-ACC-")
				branch = "acc"
				env = "acc"
      elsif job.include?("-STAG-")
				branch = "staging"
				env = "staging"
      elsif job.include?("-PROD-")
				branch = "prod"
				env = "projd"
			end

			begin 
				deploy = @client.job.create_or_update_freestyle(
                      :name 	      			=>	job,
                      :keep_dependencies	=>	true,
                      :scm_provider		    =>	'git',
                      :scm_url			      =>	"git@bitbucket.org:ausybenelux/#{@project_name}",
                      :scm_branch	    		=>	branch,
                      :shell_command		=>	"cap #{env} deploy#{type_string}",
                      )

				if deploy == "200"
					good_job("#{job}")
				else
					bad_job("#{job}")
				end

			rescue 
				@error_message	= "#{$!}"

				bad_job("#{@error_message}")
			end
		end
	end
end
