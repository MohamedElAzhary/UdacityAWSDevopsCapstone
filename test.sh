wget -P ./.ml-microservice/bin/ https://www.netfilter.org/projects/conntrack-tools/files/conntrack-tools-1.4.6.tar.bz2
tar -xjvf ./.ml-microservice/bin/conntrack-tools-1.4.6.tar.bz2 -C ./.ml-microservice/bin/
rm -f ./.ml-microservice/bin/conntrack-tools-1.4.6.tar.bz2
mkdir ./.ml-microservice/bin/tmp
cp -r ./.ml-microservice/bin/conntrack-tools-1.4.6/* ./.ml-microservice/bin/tmp
rm -f -r ./.ml-microservice/bin/conntrack-tools-1.4.6
cp -r ./.ml-microservice/bin/tmp/* ./.ml-microservice/bin/
rm -f -r ./.ml-microservice/bin/tmp
if (test -f ./.ml-microservice/bin/conntrack);then chmod +x ./.ml-microservice/bin/conntrack;fi;
