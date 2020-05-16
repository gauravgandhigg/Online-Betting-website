require 'cgi'

cgi=CGI.new('html5')
p1="name is empty"
if cgi.params['name']!=""
    p1=cgi.params['name']
end

p2="reason is empty"
if !cgi.params['reason'].empty?
    p2=cgi.params['reason']
end

cgi.out do
    cgi.html do
        cgi.head {cgi.title{"this is a cgi program"}}+
        cgi.body do
            cgi.h1{"your submitted form info is as follows"}
            cgi.p{p1} +cgi.p{p2}
        end
        
    end
end