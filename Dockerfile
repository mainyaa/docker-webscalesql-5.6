FROM centos:latest
MAINTAINER KazuyukiMori <mainya@gmail.com>

# Install EPEL
RUN rpm -Uvh --force http://mirrors.kernel.org/fedora-epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN yum update -y

# Install g++ 4.7.2
RUN sysctl -w net.ipv6.conf.all.disable_ipv6=1
RUN sysctl -w net.ipv6.conf.default.disable_ipv6=1
RUN cd /etc/yum.repos.d; wget http://people.centos.org/tru/devtools-1.1/devtools-1.1.repo
RUN yum --enablerepo=testing-1.1-devtools-6 install -y devtoolset-1.1-gcc devtoolset-1.1-gcc-c++
ENV PATH $PATH:/opt/centos/devtoolset-1.1/root/usr/bin
ENV CC  /opt/centos/devtoolset-1.1/root/usr/bin/gcc
ENV CXX /opt/centos/devtoolset-1.1/root/usr/bin/g++

# Install Dependencies
RUN yum install -y ncurses-devel cmake bison zlib-devel readline-devel readline svn

# Download Source
RUN svn co https://github.com/webscalesql/webscalesql-5.6/trunk /tmp/webscalesql-5.6
RUN cd /tmp/webscalesql-5.6; find . -type d -name ".svn" -print0 | xargs -0 rm -rf


# Build
RUN cd /tmp/webscalesql-5.6; cmake . -DCMAKE_BUILD_TYPE=Debug
RUN cd /tmp/webscalesql-5.6; make
RUN cd /tmp/webscalesql-5.6; make install
ENV PATH $PATH:/usr/local/mysql/bin

# Setup mysql user
#RUN groupadd mysql
#RUN useradd -g mysql -d /usr/local/mysql mysql
#RUN chown -R mysql:mysql /usr/local/mysql
#RUN /usr/local/mysql/scripts/mysql_install_db --user=mysql --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data

# Install Service
#RUN cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysql
#RUN chmod +x /etc/init.d/mysql
#RUN chkconfig --add mysql
#RUN service mysql start

CMD ["/usr/local/mysql/bin/mysqld", "-d"]

EXPOSE 3306



