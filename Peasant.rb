#!/usr/bin/env ruby
require 'json'
require 'fileutils'

peasantfileFilename = 'Peasantfile'

class CommandStream
	def initialize
		@commands = []
	end

	def push(line)
		@commands << line.join(' ')
	end

	def print
		puts @commands.join("\n")
	end
end

class WindowsCommandStream < CommandStream
end

class UnixCommandStream < CommandStream
end

class VCDriver
end

class GitDriver < VCDriver
	def repo_exist?(path)
		File.exist? path + '/.git'
	end

	def fetch
		['git', 'fetch']
	end

	def update(revision)
		['git', 'checkout', revision]
	end

	def clone(url)
		['git', 'clone', url, '.']
	end
end

class HgDriver < VCDriver
	def repo_exist?(path)
		File.exist? path + '/.hg'
	end

	def fetch()
		['hg', 'pull']
	end

	def update(revision)
		['hg', 'update', revision]
	end

	def clone(url)
		['hg', 'clone', url, '.']
	end
end

class Peasant
	# runs the Peasant application
	def self.run(peasantfileFilename)
		unless File.exist? peasantfileFilename
			raise peasantfileFilename + ' does not exist in current directory.'
		end

		peasantfileBuffer = File.read peasantfileFilename

		peasantfile = JSON.parse peasantfileBuffer

		vcDriverInstances = {}

		originalDir = Dir.pwd

		is_windows = (ENV['OS'] == 'Windows_NT')

		commandStream = is_windows ? WindowsCommandStream.new : UnixCommandStream.new

		peasantfile['repositories'].each do |repository|
			vcDriverType = repository['type']
			# no driver yet for version control type in instance cache
			# => create new instance of the desired driver type
			unless vcDriverInstances[vcDriverType]
				case vcDriverType
				when 'git'
					vcDriverInstances[vcDriverType] = GitDriver.new
				when 'hg'
					vcDriverInstances[vcDriverType] = HgDriver.new
				else
					raise 'Unknown repository type: ' + vcDriverType
				end		
			end

			# resolve the correct version control driver
			vcDriver = vcDriverInstances[vcDriverType]

			path_to_repository = repository['path']

			# path does not exist => create it so we can cd into it
			unless File.exist? path_to_repository
				puts 'Creating directory ' + path_to_repository

				FileUtils.mkdir_p path_to_repository
			end

			# cd into the directory
			commandStream.push ['cd', originalDir + '/' + path_to_repository]

			# repository does not exist (directory does, however) => clone the repository
			unless vcDriver.repo_exist? path_to_repository
				commandStream.push vcDriver.clone(repository['url'])

			# repository exists => fetch latest updates, so we can definitely update to the desired revision
			else
				commandStream.push vcDriver.fetch()
			end

			# update to defined revision
			commandStream.push vcDriver.update(repository['revision'])
		end

		# print the command stream to stdout. it is up to the caller to decide
		# whether to pipe it to sh or cmd, or to view it before executing
		commandStream.print
	end
end

Peasant.run peasantfileFilename
