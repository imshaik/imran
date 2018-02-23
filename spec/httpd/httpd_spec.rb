require 'spec_helper'
require 'docker'
require 'serverspec'

    describe "test Dockerfile" do
      before(:all) do
	#Docker.authenticate!('username' => ENV['DOCKER_USERNAME'], 'password' => ENV['DOCKER_PASSWORD'])
        @image = Docker::Image.build_from_dir('../../../docker')
	#let(:image) { Docker::Image.build_from_dir('.') }
	#@imageid = %x( docker images | grep shaikimranashrafi/httpd | awk 'NR==1{print $3;exit}' )
	#@image = Docker::Image.get('imageid')

        set :os, family: :RedHat
	#set :os, family: :Linux
        set :backend, :docker
        set :docker_image, @image.id

      @container = Docker::Container.create(
          'Image'      => @image.id,
        )
        @container.start
       end

     it 'installs httpd' do
      expect(package('httpd')).to be_installed
     end

    describe file('/etc/httpd/conf/httpd.conf') do
        it { should exist }
    end

    def Check_the_httpd_status
      command("ps -ef | grep httpd").stderr
    end
     
    #describe port(80) do
     # it { should be_listening }
    #end
     
    #describe process("apache2") do
     #	it { should be_enabled }
      #	it { should be_running }
    #end

    describe 'Check whether httpd.sh script is exist' do
     describe file('/root/httpd.sh') do
      ## validate file exists in the container
      it { should exist }
     end
    end
    
     describe file('/root/httpd.sh') do
  	its(:content) { should match '/usr/sbin/httpd -k start && tail -f /dev/null' }
     end

    describe 'Check whether index.html is exist' do
     describe file('/var/www/html/index.html') do
      ## validate file exists in the container
      it { should exist }
     end
    end

    after(:all) do
      @container.stop
      @container.kill
      @container.kill(:signal => "SIGHUP")
      @container.delete(:force => true)
      #sleep 5     
      #@image.remove(:force => true)
      #we can use image.remove(:force => true) let(:image) is define###
    end
 end
